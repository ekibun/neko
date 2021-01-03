/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-06-25 11:36:16
 * @LastEditors: ekibun
 * @LastEditTime: 2020-07-18 14:35:02
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void _updateSystemUI(BuildContext context) {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).backgroundColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark));
  }
}

class LifecycleWatcher extends StatefulWidget {
  final Widget child;

  const LifecycleWatcher({Key key, this.child}) : super(key: key);
  @override
  _LifecycleWatcherState createState() => new _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateSystemUI(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _updateSystemUI(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class OrientationBox extends StatefulWidget {
  final Widget child;
  final List<DeviceOrientation> orientations;

  const OrientationBox({Key key, this.child, this.orientations})
      : super(key: key);
  @override
  _OrientationBoxState createState() => new _OrientationBoxState();
}

class _OrientationBoxState extends State<OrientationBox> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(widget.orientations);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
