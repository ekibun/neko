/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-07-21 12:48:55
 * @LastEditors: ekibun
 * @LastEditTime: 2020-07-24 00:16:44
 */
#pragma once

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
  bool has_object;
  JSValue func;
} JSOSFuture;

typedef struct JSThreadState
{
  struct list_head os_future; /* list of JSOSFuture.link */
  int eval_script_recurse;    /* only used in the main thread */
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
    std::cout << "begin request:" << url << std::endl;
    auto rsp = requests::Get(url);
    std::cout << "end request:" << url  << rsp.status << std::endl;
    return (std::function<JSOSFutureArgv(JSContext *)>) [rspstr = rsp.GetText()](JSContext *ctx) { 
      JSValue ret[1] = { JS_DupValue(ctx, JS_NewString(ctx, rspstr.c_str())) };
      return JSOSFutureArgv { 1, ret };
    };
  }));
  
  
  // return js_add_future(cb, async([url]() {
    
  //   return (std::function<JSOSFutureArgv(JSContext *)>) [](JSContext *ctx) { 
  //     // JSValue ret[1] = { JS_EXCEPTION }; // { JS_DupValue(ctx, JS_NewString(ctx, "hello")) };
  //     return JSOSFutureArgv { 0, nullptr };
  //   };
  // }));
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
    th->future.wait();
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
  func1 = JS_DupValue(ctx, func);
  ret = JS_Call(ctx, func1, JS_UNDEFINED, count, const_cast<JSValueConst *>(argv));
  JS_FreeValue(ctx, func1);
  for(int i = 0; i < count; ++i)
    JS_FreeValue(ctx, argv[i]);
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
      std::future_status status = th->future.wait_for(std::chrono::seconds(0));
      if (status == std::future_status::ready)
      {
        JSOSFutureArgv argv = th->future.get()(ctx);
        JSValue func;
        int64_t delay;
        /* the timer expired */
        func = th->func;
        th->func = JS_UNDEFINED;
        unlink_future(rt, th);
        if (!th->has_object)
          free_future(rt, th);
        call_handler(ctx, func, argv.count, argv.argv);
        JS_FreeValue(ctx, func);
        return 0;
      }
    }
  }
  return 0;
}