/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-07-18 14:28:58
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-27 17:17:05
 */
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(10000),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: null,
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                  onSubmitted: (v) {},
                ),
              )
            ],
          ),
        ),
      ),
      body: ListView(),
    );
  }
}