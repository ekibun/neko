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
import 'package:neko/db/database.dart';
import 'package:neko/engine/database.dart';
import 'package:neko/engine/datasource.dart';
import 'package:neko/view/subjectList.dart';
import 'package:neko/widget/actionbar.dart';
import 'package:neko/widget/ripple.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  String searchKey = "";
  int searchPage = 0;
  List<SubjectCollection> searchResult = [];
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
    final site = provider;
    DataSource.getProvider(site).then((value) async {
      if (searchJob.isCompleted) return;
      if (value["search"] is IsolateJSFunction) {
        searchJob.complete(await value["search"].invoke([key, page]));
      } else {
        searchJob.completeError("datasource $site.search is not a function");
      }
      jobs.remove(searchJob);
    });

    searchJob.future.then((value) {
      if (!(value is List)) throw Exception("return data error");
      (value as List).forEach((item) {
        searchResult.add(SubjectCollection()
          ..subject = Subject(
            id: item["id"]?.toString() ?? "",
            site: item["site"] ?? site,
            subjectType: item["type"] ?? "",
            name: item["name"],
            image: jsonEncode(item["image"]),
            summary: item["summary"],
            score: item["score"],
            tags: jsonEncode(item["tags"]),
          ));
      });
      setState(() {});
    }, onError: (e) {
      print("search error:\n$e");
    });
    jobs.add(searchJob);
  }

  @override
  Widget build(BuildContext context) {
    SubjectDatabase subjectDatabase =
        Provider.of<Database>(context, listen: false).subject;
    return Material(
      child: Stack(children: [
        SafeArea(
          child: SubjectList(
            items: searchResult,
            padding: EdgeInsets.fromLTRB(12, 60, 12, 12),
            onTapItem: (data) {
              final nowTime = DateTime.now();
              subjectDatabase.insertSubjectCollection(data
                ..collection = Collection(
                  site: data.subject.site,
                  id: data.subject.id,
                  createTime: nowTime,
                  updateTime: nowTime,
                ));
              // collectionBox.put(data['id'], data);
            },
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
