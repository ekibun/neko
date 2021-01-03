import 'package:flutter/material.dart';
import 'collections/index.dart';
import 'download/index.dart';
import 'provider/index.dart';
import 'setting/index.dart';

class _Route {
  IconData icon;
  String title;
  String route;
  WidgetBuilder builder;
  _Route(this.icon, this.title, this.route, this.builder);
}

var routes = <_Route>[
  _Route(
    Icons.collections,
    "收藏",
    "collections",
    (context) => CollectionPage(),
  ),
  _Route(
    Icons.cloud_download,
    "下载",
    "downloads",
    (context) => DownloadPage(),
  ),
  _Route(
    Icons.apps,
    "扩展",
    "provider",
    (context) => ProviderPage(),
  ),
  _Route(
    Icons.settings,
    "设置",
    "settings",
    (context) => SettingPage(),
  ),
];
