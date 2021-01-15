#include "include/neko_desktop/neko_desktop_plugin.h"

#include <flutter/plugin_registrar_windows.h>

namespace {

class NekoDesktopPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NekoDesktopPlugin();

  virtual ~NekoDesktopPlugin();
};

// static
void NekoDesktopPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
}

NekoDesktopPlugin::NekoDesktopPlugin() {}

NekoDesktopPlugin::~NekoDesktopPlugin() {}

}  // namespace

void NekoDesktopPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  NekoDesktopPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
