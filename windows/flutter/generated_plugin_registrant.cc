//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <flutter_iconv/flutter_iconv_plugin.h>
#include <flutter_qjs/flutter_qjs_plugin.h>
#include <flutter_webview/flutter_webview_plugin.h>
#include <neko_desktop/neko_desktop_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterIconvPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterIconvPlugin"));
  FlutterQjsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterQjsPlugin"));
  FlutterWebviewPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWebviewPlugin"));
  NekoDesktopPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("NekoDesktopPlugin"));
}
