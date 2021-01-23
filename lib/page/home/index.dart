/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-06-26 12:38:36
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-28 11:17:51
 */

import 'package:flutter/material.dart';
import 'package:neko/widget/tabItem.dart';
import 'package:provider/provider.dart';
import 'navigator.dart';

class HomePage extends StatefulWidget {
  final HomePageStateData beginState;
  final homeContainerKey = GlobalKey<NavigatorState>();

  HomePage({Key key, this.beginState}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageStateData {
  String currentRoute;
}

class HomePageState extends State<HomePage> implements HomePageStateData {
  String currentRoute;

  Widget build(BuildContext context) {
    // init state
    currentRoute =
        currentRoute ?? widget.beginState?.currentRoute ?? routes.first.route;

    final _currentRoute = routes.firstWhere((r) => r.route == currentRoute);

    final homeContainer = AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: Provider<HomePageStateData>(
        create: (_) => this,
        child: Material(
          key: ValueKey(_currentRoute.route),
          child: _currentRoute.builder(context),
        ),
      ),
    );
    return Material(
      type: MaterialType.transparency,
      child: OrientationBuilder(
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
                  width: 200,
                  child: Material(
                    color: Theme.of(context).cardColor,
                    child: ListView(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor.withAlpha(100),
                          ),
                        ),
                        SizedBox(height: 8),
                        ...tabs,
                      ],
                    ),
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
                  height: 56,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                      )
                    ],
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Row(
                      children: tabs.map((e) => Expanded(child: e)).toList(),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
