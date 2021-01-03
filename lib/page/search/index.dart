/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-07-18 14:28:58
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-27 17:17:05
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_qjs/isolate.dart';
import 'package:neko/engine/provider.dart';
import 'package:neko/view/subjectList.dart';
import 'package:neko/widget/actionbar.dart';
import 'package:neko/widget/ripple.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  String searchKey = "";
  int searchPage = 0;
  List<Map> searchResult = [];
  List<Completer> jobs = [];
  String provider = "bgm.tv";

  search(String key, int page) {
    searchPage = page;
    searchKey = key;
    jobs.forEach((element) {
      element.completeError("cancel"); // cancel
    });
    jobs.clear();
    searchResult.clear();
    setState(() {});

    var searchJob = Completer();
    Provider.getProvider(provider).then((value) async {
      if (searchJob.isCompleted) return;
      if (value["search"] is IsolateJSFunction) {
        searchJob.complete(await value["search"].invoke([key, page]));
      } else {
        searchJob.completeError("provider $provider.search is not a function");
      }
      jobs.remove(searchJob);
    });

    searchJob.future.then((value) {
      if (!(value is List)) throw Exception("return data error");
      (value as List).forEach((item) {
        searchResult.add(item);
      });
      setState(() {});
    }, onError: (e) {
      print("search error:\n$e");
    });
    jobs.add(searchJob);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        SafeArea(
          child: SubjectList(
            items: searchResult,
            padding: EdgeInsets.fromLTRB(12, 60, 12, 12),
          ),
        ),
        ActionBar(children: [
          Expanded(
            child: _buildSearchAction(context),
          ),
        ]),
      ]),
    );
  }

  Widget _buildSearchAction(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Colors.black12,
      ),
      child: Row(
        children: [
          SizedBox(width: 12),
          Icon(
            Icons.search,
            color: Colors.black38,
          ),
          SizedBox(width: 6),
          Expanded(
            child: TextField(
              autofocus: true,
              decoration: null,
              textInputAction: TextInputAction.search,
              onSubmitted: (key) {
                search(key, 1);
              },
            ),
          ),
          SizedBox(width: 6),
          Container(
            width: 2,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.black38,
            ),
          ),
          Ripple(
            onTap: () {},
            padding: EdgeInsets.all(12),
            borderless: false,
            borderRadius: BorderRadius.horizontal(right: Radius.circular(1000)),
            child: Text(provider),
          ),
        ],
      ),
    );
  }
}
