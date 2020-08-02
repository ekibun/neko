/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-07-21 12:48:55
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-02 16:45:24
 */
#pragma once

#include <iostream>
#include "quickjs/quickjs/quickjs.h"
#include "quickjs/quickjs/list.h"
#include "quickjs/quickjspp.hpp"
#include <future>
#include "requests/requests.h"

static JSClassID js_promise_class_id;

template <typename F, typename... Args>
auto async2(F &&f, Args &&... args)
    -> std::shared_future<typename std::result_of<F(Args...)>::type>
{
  using _Ret = typename std::result_of<F(Args...)>::type;
  auto _func = std::bind(std::forward<F>(f), std::forward<Args>(args)...);
  std::packaged_task<_Ret()> tsk(std::move(_func));
  auto _fut = tsk.get_future();
  std::thread thd(std::move(tsk));
  thd.detach();
  return _fut;
}

typedef struct
{
  int count;
  JSValue* argv;
} JSOSFutureArgv;

typedef struct
{
  struct list_head link;
  std::shared_future<std::function<JSOSFutureArgv(JSContext *)>> future;
  JSValue func;
} JSOSFuture;

typedef struct JSThreadState
{
  struct list_head os_future; /* list of JSOSFuture.link */
} JSThreadState;

static JSValue js_add_future(qjs::Value cb, std::shared_future<std::function<JSOSFutureArgv(JSContext *)>> future){
  JSRuntime *rt = JS_GetRuntime(cb.ctx);
  JSThreadState *ts = (JSThreadState *)JS_GetRuntimeOpaque(rt);
  JSValueConst func;
  JSOSFuture *th;
  JSValue obj;

  func = cb.v;
  if (!JS_IsFunction(cb.ctx, func))
    return JS_ThrowTypeError(cb.ctx, "not a function");
  obj = JS_NewObjectClass(cb.ctx, js_promise_class_id);
  if (JS_IsException(obj))
    return obj;
  th = (JSOSFuture *)js_mallocz(cb.ctx, sizeof(*th));
  if (!th)
  {
    JS_FreeValue(cb.ctx, obj);
    return JS_EXCEPTION;
  }
  th->future = future;
  th->func = JS_DupValue(cb.ctx, func);
  list_add_tail(&th->link, &ts->os_future);
  JS_SetOpaque(obj, th);
  return obj;
}

JSValue js_os_setTimeout(qjs::Value cb, int64_t delay) {
  return js_add_future(cb, async2([delay]() {
    std::cout << "begin timeout:" << delay << std::endl;
    std::this_thread::sleep_for(std::chrono::milliseconds(delay));
    std::cout << "end timeout:" << delay << std::endl;
    return (std::function<JSOSFutureArgv(JSContext *)>) [](JSContext *ctx) { 
      // JSValue ret[1] = { JS_EXCEPTION }; // { JS_DupValue(ctx, JS_NewString(ctx, "hello")) };
      return JSOSFutureArgv { 0, nullptr };
    };
  }));
}

JSValue js_os_http_get(qjs::Value cb, std::string url) {    
  return js_add_future(cb, async2([url]() {
    try {
      auto rsp = requests::Get(url);
      auto len = rsp.size();
      uint8_t *buf = new uint8_t[len];
      memcpy(buf, rsp.GetBinary(), len);
      return (std::function<JSOSFutureArgv(JSContext *)>) [buf, len](JSContext *ctx) {
        JSValue *ret = new JSValue { JS_NewArrayBufferCopy(ctx, buf, len) };
        delete[] buf;
        return JSOSFutureArgv { 1, ret };
      };
    } catch (char* err) {
       return (std::function<JSOSFutureArgv(JSContext *)>) [err = std::string(err)](JSContext *ctx) -> JSOSFutureArgv {
        char *e = (char *)js_malloc(ctx, err.size());
        err.copy(e, err.size());
        JS_Throw(ctx, JS_DupValue(ctx, JS_NewString(ctx, e)));
        throw qjs::exception {};
      };
    }
  }));
}

static void unlink_future(JSRuntime *rt, JSOSFuture *th)
{
  if (th->link.prev)
  {
    list_del(&th->link);
    th->link.prev = th->link.next = NULL;
  }
}

static void free_future(JSRuntime *rt, JSOSFuture *th)
{
  JS_FreeValueRT(rt, th->func);
  js_free_rt(rt, th);
}

void js_std_init_handlers(JSRuntime *rt)
{
  JSThreadState *ts = (JSThreadState *)malloc(sizeof(*ts));
  if (!ts)
  {
    fprintf(stderr, "Could not allocate memory for the worker");
    exit(1);
  }
  memset(ts, 0, sizeof(*ts));
  init_list_head(&ts->os_future);

  JS_SetRuntimeOpaque(rt, ts);
}

void js_std_free_handlers(JSRuntime *rt)
{
  JSThreadState *ts = (JSThreadState *)JS_GetRuntimeOpaque(rt);
  struct list_head *el, *el1;

  list_for_each_safe(el, el1, &ts->os_future)
  {
    JSOSFuture *th = list_entry(el, JSOSFuture, link);
    th->future.get();
    unlink_future(rt, th);
    free_future(rt, th);
  }
  
  free(ts);
  JS_SetRuntimeOpaque(rt, NULL); /* fail safe */
  std::cout << "runtime free" << std::endl;
}

static void call_handler(JSContext *ctx, JSValueConst func, int count, JSValue *argv)
{
  JSValue ret, func1;
  /* 'func' might be destroyed when calling itself (if it frees the
       handler), so must take extra care */
  uint8_t arr[100];
  func1 = JS_DupValue(ctx, func);
  ret = JS_Call(ctx, func1, JS_UNDEFINED, count, argv);
  JS_FreeValue(ctx, func1);
  if (JS_IsException(ret))
    throw qjs::exception{};
  JS_FreeValue(ctx, ret);
}

static int js_os_poll(JSContext *ctx)
{
  JSRuntime *rt = JS_GetRuntime(ctx);
  JSThreadState *ts = (JSThreadState *)JS_GetRuntimeOpaque(rt);
  struct list_head *el;

  /* XXX: handle signals if useful */

  if (list_empty(&ts->os_future))
    return -1; /* no more events */

  /* XXX: only timers and basic console input are supported */
  if (!list_empty(&ts->os_future))
  {
    list_for_each(el, &ts->os_future)
    {
      JSOSFuture *th = list_entry(el, JSOSFuture, link);
      if (th->future._Is_ready())
      {
        JSOSFutureArgv argv = th->future.get()(ctx);
        JSValue func;
        int64_t delay;
        /* the timer expired */
        func = th->func;
        th->func = JS_UNDEFINED;
        unlink_future(rt, th);
        free_future(rt, th);
        call_handler(ctx, func, argv.count, argv.argv);
        for(int i = 0; i < argv.count; ++i)
          JS_FreeValue(ctx, argv.argv[i]);
        JS_FreeValue(ctx, func);
        delete argv.argv;
        return 0;
      }
    }
  }
  return 0;
}