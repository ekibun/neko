/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-06-24 20:26:20
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-28 00:00:09
 */

import 'dart:io';

import 'package:neko/page/home/index.dart';
import 'package:flutter/material.dart';
import 'package:neko/page/search/index.dart';
import 'package:neko/page/subject/index.dart';
import 'package:neko/theme.dart';
import 'package:provider/provider.dart';

import 'engine/database.dart';
import 'lifecycle.dart';

void main() async {
  runApp(LifecycleWatcher(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Database(),
      child: MaterialApp(
        title: 'neko',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(brightness: Brightness.dark, elevation: 0),
            primaryColor: AppTheme.primaryColor,
            accentColor: AppTheme.accentColor,
            canvasColor: AppTheme.backgroundColor,
            hintColor: AppTheme.primaryColor,
            backgroundColor: Colors.transparent,
            splashColor: AppTheme.accentColor.withAlpha(50),
            primaryColorBrightness: Brightness.dark,
            fontFamily: Platform.isWindows ? "Microsoft Yahei UI" : null),
        routes: {
          'home': (BuildContext context) => HomePage(),
          'search': (BuildContext context) => SearchPage(),
          'subject': (BuildContext context) => SubjectPage(),
        },
        initialRoute: 'home',
      ),
    );
  }
}
