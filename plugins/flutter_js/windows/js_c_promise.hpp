/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-07-21 12:48:55
 * @LastEditors: ekibun
 * @LastEditTime: 2020-07-22 14:31:59
 */
#pragma once

#include "quickjs/quickjs/quickjs.h"
#include "quickjs/quickjs/list.h"
#include "quickjs/quickjspp.hpp"
#include <future>

static JSClassID js_promise_class_id;

template <typename F, typename... Args>
auto really_async2(F &&f, Args &&... args)
    -> std::future<typename std::result_of<F(Args...)>::type>
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
  std::future<std::function<JSOSFutureArgv(JSContext *)>> future;
  bool has_object;
  JSValue func;
} JSOSFuture;

typedef struct JSThreadState
{
  struct list_head os_future; /* list of JSOSFuture.link */
  int eval_script_recurse;    /* only used in the main thread */
} JSThreadState;

static JSValue js_os_setTimeout(JSContext *ctx, JSValueConst this_val,
                                int argc, JSValueConst *argv)
{
  JSRuntime *rt = JS_GetRuntime(ctx);
  JSThreadState *ts = (JSThreadState *)JS_GetRuntimeOpaque(rt);
  int64_t delay;
  JSValueConst func;
  JSOSFuture *th;
  JSValue obj;

  func = argv[0];
  if (!JS_IsFunction(ctx, func))
    return JS_ThrowTypeError(ctx, "not a function");
  if (JS_ToInt64(ctx, &delay, argv[1]))
    return JS_EXCEPTION;
  obj = JS_NewObjectClass(ctx, js_promise_class_id);
  if (JS_IsException(obj))
    return obj;
  th = (JSOSFuture *)js_mallocz(ctx, sizeof(*th));
  if (!th)
  {
    JS_FreeValue(ctx, obj);
    return JS_EXCEPTION;
  }
  th->future = really_async2([delay, &ctx]() {
    std::cout << "begin timeout:" << delay << std::endl;
    std::this_thread::sleep_for(std::chrono::milliseconds(delay));
    std::cout << "end timeout:" << delay << std::endl;
    return (std::function<JSOSFutureArgv(JSContext *)>) [](JSContext *ctx) { 
      JSValue ret[1] = { JS_DupValue(ctx, JS_NewString(ctx, "hello")) };
      return JSOSFutureArgv { 1, ret };
    };
  });
  th->func = JS_DupValue(ctx, func);
  list_add_tail(&th->link, &ts->os_future);
  JS_SetOpaque(obj, th);
  return obj;
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