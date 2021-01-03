/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-06-26 12:49:08
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-27 16:34:36
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screenAdapt.dart';

class SearchAction extends StatelessWidget {
  final VoidCallback onPressed;

  const SearchAction({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const icon = const Icon(Icons.search, color: Colors.white);
    return ScreenAdapt(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Ink(
            width: 200,
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10000)),
            child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(10000),
                child: Row(
                  children: const [
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.search, color: Colors.white70)),
                    Text(
                      '搜索...',
                      style: TextStyle(color: Colors.white70),
                    )
                  ],
                )),
          )),
      childElse: IconButton(onPressed: onPressed, icon: icon),
      trigger: MediaQueryTriggers.isTablet,
    );
  }
}
