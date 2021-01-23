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

import 'lifecycle.dart';

void main() async {
  runApp(LifecycleWatcher(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppTheme>.value(value: AppTheme.instance),
        ],
        child: Consumer<AppTheme>(
          builder: (context, appTheme, _) => MaterialApp(
            title: 'neko',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeData(Brightness.light),
            darkTheme: AppTheme.getThemeData(Brightness.dark),
            themeMode: appTheme.themeMode,
            routes: {
              'home': (BuildContext context) => HomePage(),
              'search': (BuildContext context) => SearchPage(),
              'subject': (BuildContext context) => SubjectPage(),
            },
            initialRoute: 'home',
          ),
        ));
  }
}
