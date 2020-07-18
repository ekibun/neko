/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-06-24 20:26:20
 * @LastEditors: ekibun
 * @LastEditTime: 2020-07-18 15:14:05
 */

import 'package:neko/page/home.dart';
import 'package:neko/page/search.dart';
import 'package:flutter/material.dart';

import 'lifecycle.dart';

void main() {
  runApp(LifecycleWatcher(
    child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {

  const MyApp({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bangumew',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(brightness: Brightness.dark, elevation: 0),
        primaryColor: Color(0xfff09199),
        accentColor: Color(0xffec818a),
        backgroundColor: Colors.grey[300],
        primaryColorBrightness: Brightness.dark,
      ),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'search': (BuildContext context) => SearchPage(),
      },
      initialRoute: 'home',
    );
  }

}