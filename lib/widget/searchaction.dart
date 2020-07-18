/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-06-26 12:49:08
 * @LastEditors: ekibun
 * @LastEditTime: 2020-07-18 15:38:29
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchAction extends StatelessWidget {

  final VoidCallback onPressed;

  const SearchAction({
    Key key,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const icon = const Icon(
      Icons.search,
      color: Colors.white
    );
    return MediaQuery.of(context).size.width > 500 
      ? Container(
        alignment: Alignment.centerLeft,
        width: 200,
        margin: EdgeInsets.all(10),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10000),
          child: Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
              Icons.search,
              color: Colors.white70
            )),
            Text(
              '搜索...',
              style: TextStyle(color:  Colors.white70),
            )
          ],
        )),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withAlpha(200),
          borderRadius: BorderRadius.circular(10000)
        ),
      ) : IconButton(
        onPressed: onPressed, 
        icon: icon
      );
  }
}