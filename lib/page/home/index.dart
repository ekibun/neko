/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-06-26 12:38:36
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-28 11:17:51
 */

import 'package:flutter/material.dart';
import 'package:neko/widget/tabItem.dart';
import 'navigator.dart';

class HomePage extends StatefulWidget {
  final homeContainerKey = GlobalKey<NavigatorState>();

  Widget _buildHomeContainer(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: homeContainerKey,
      initialRoute: routes.first.route,
      theme: Theme.of(context),
      routes: Map.fromIterable(
        routes,
        key: (r) => r.route,
        value: (r) => r.builder,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String currentRoute = routes.first.route;
  @override
  Widget build(BuildContext context) {
    final _currentRoute = routes.firstWhere((r) => r.route == currentRoute);
    final homeContainer = AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(_currentRoute.route),
        child: _currentRoute.builder(context),
      ),
    );
    return OrientationBuilder(
      builder: (context, orientation) {
        var tabs = routes.map(
          (e) => TabItem(
            e.icon,
            e.title,
            orientation: orientation,
            isSelected: currentRoute == e.route,
            onTap: () {
              setState(() {
                currentRoute = e.route;
              });
            },
          ),
        );
        if (orientation == Orientation.landscape) {
          return Row(
            children: [
              Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: Material(
                  child: Column(children: tabs.toList()),
                ),
              ),
              Expanded(
                child: homeContainer,
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: homeContainer,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: Material(
                  child: Row(
                    children: tabs.map((e) => Expanded(child: e)).toList(),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
