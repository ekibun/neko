/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-06-26 12:38:36
 * @LastEditors: ekibun
 * @LastEditTime: 2020-07-18 15:10:13
 */

import 'package:neko/widget/searchaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: <Widget>[
              Tab(text: '热门'),
              Tab(text: '推荐'),
              Tab(text: '关注')
            ],
            indicatorColor: Colors.white,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
          ),
          actions: [
            SearchAction(onPressed: () => {
              Navigator.pushNamed(context, 'search')
            })
          ],),
        body: Text('home')
      )
    );
  }
}
