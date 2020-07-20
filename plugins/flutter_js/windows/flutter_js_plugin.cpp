/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-07-18 16:22:37
 * @LastEditors: ekibun
 * @LastEditTime: 2020-07-20 15:04:30
 */ 
#include "include/flutter_js/flutter_js_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

#include "quickjs/quickjspp.hpp"
#include <future>

namespace {

class FlutterJsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterJsPlugin();

  virtual ~FlutterJsPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void FlutterJsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "io.abner.flutter_js",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<FlutterJsPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

// std::map<int,qjs::Runtime*> jsEngineMap;

FlutterJsPlugin::FlutterJsPlugin() {}

FlutterJsPlugin::~FlutterJsPlugin() {
  // jsEngineMap.clear();
}

// Looks for |key| in |map|, returning the associated value if it is present, or
// a Null EncodableValue if not.
const flutter::EncodableValue &ValueOrNull(const flutter::EncodableMap &map, const char *key) {
  static flutter::EncodableValue null_value;
  auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) {
    return null_value;
  }
  return it->second;
}

void println(std::string data){
  std::cout << data << std::endl;
}

void FlutterJsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // Replace "getPlatformVersion" check with your plugin's method.
  // See:
  // https://github.com/flutter/engine/tree/master/shell/platform/common/cpp/client_wrapper/include/flutter
  // and
  // https://github.com/flutter/engine/tree/master/shell/platform/glfw/client_wrapper/include/flutter
  // for the relevant Flutter APIs.
  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    flutter::EncodableValue response(version_stream.str());
    result->Success(&response);
  } else if (method_call.method_name().compare("initEngine") == 0) {
    int engineId = method_call.arguments()->IntValue();
    std::cout << engineId << std::endl;
    // TODO use threadpool
    // qjs::Runtime* runtime = new qjs::Runtime();
    // jsEngineMap[engineId] = runtime;
    // qjs::Context ctx(*runtime);
    flutter::EncodableValue response(engineId);
    result->Success(&response);
  } else if (method_call.method_name().compare("evaluate") == 0) {
    flutter::EncodableMap args = method_call.arguments()->MapValue();
    std::string command = ValueOrNull(args, "command").StringValue();
    int engineId = ValueOrNull(args, "engineId").IntValue();
    // qjs::Runtime* runtime = jsEngineMap.at(engineId);
    std::async(std::launch::async, [&result, &command]() {
      qjs::Runtime runtime;
      qjs::Context ctx(runtime);
      JSContext* pctx = ctx.ctx;
      try
      {
        auto &module = ctx.addModule("__WindowsBaseMoudle");
        module.function<&println>("println");
        ctx.global()["_result"] = ctx.newValue((HANDLE) &result);
        ctx.eval(R"xxx(
          import * as __WindowsBaseMoudle from "__WindowsBaseMoudle";
          globalThis.print = (...a) => __WindowsBaseMoudle.println(a.join(' '));
        )xxx", "<init>", JS_EVAL_TYPE_MODULE);
        std::string cmd = "const __ret = Promise.resolve(eval(" + command + ")).then(ret => __ret.__value = ret); __ret";
        std::cout << cmd << std::endl;
        auto ret = ctx.eval(cmd, "<eval>");
        // js_std_loop(ctx.ctx);
        pctx = nullptr;
        for(;;) {
          int err = JS_ExecutePendingJob(runtime.rt, &pctx);
          if (err <= 0) {
            if (err < 0)
              throw qjs::exception{};
            break;
          }
        }
        std::string retValue = (std::string) ret["__value"];
        std::cout << retValue << std::endl;
        flutter::EncodableValue response(retValue);
        result->Success(&response);
      }
      catch(qjs::exception)
      {
        auto exc = qjs::Value{pctx, JS_GetException(pctx)};
        std::string err = (std::string) exc;
        if((bool) exc["stack"])
              err += "\n" + (std::string) exc["stack"];
        std::cerr << err << std::endl;
        result->Error("FlutterJSException", err);
      }
    });
  } else if (method_call.method_name().compare("close") == 0) {
    flutter::EncodableMap args = method_call.arguments()->MapValue();
    // TODO
    // int engineId = ValueOrNull(args, "engineId").IntValue();
    // if(jsEngineMap.count(engineId)) {
    //   delete jsEngineMap.at(engineId);
    //   jsEngineMap.erase(engineId);
    // }
    result->Success();
  } else {
    result->NotImplemented();
  }
}

}  // namespace

void FlutterJsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  FlutterJsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
