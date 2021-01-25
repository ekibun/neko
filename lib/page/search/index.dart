/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-07-18 14:28:58
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-27 17:17:05
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neko/db/dataHelper.dart';
import 'package:neko/db/database.dart';
import 'package:neko/engine/database.dart';
import 'package:neko/engine/datasource.dart';
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
  List<SubjectCollection> searchResult = [];
  List<Completer> jobs = [];
  String provider = "acfun.cn";

  search(String key, int page) {
    searchPage = page;
    searchKey = key;
    jobs.forEach((element) {
      if (!element.isCompleted) element.completeError("cancel"); // cancel
    });
    jobs.clear();
    searchResult.clear();
    setState(() {});

    var searchJob = Completer();
    final site = provider;
    DataSource.getProvider(site).then((value) async {
      final searchData = await value["search"](key, page);
      if (searchJob.isCompleted) return;
      if (!(searchData is List)) throw Exception("return data error");
      final List<SubjectCollection> searchResultData =
          List<SubjectCollection>.from(
        searchData.map((item) =>
            SubjectCollection()..subject = subjectfromMap(item, site: site)),
      );
      final collections = await AppDatabase.subject
          .getCollections(searchResultData.map((e) => e.subject));
      searchResultData.forEach((e) {
        e.collection = collections.firstWhere(
          (c) => e.subject.site == c.site && e.subject.id == c.id,
          orElse: () => null,
        );
      });
      if (!searchJob.isCompleted) searchJob.complete(searchResultData);
    }).catchError((error) {
      if (searchJob.isCompleted) return;
      searchJob.completeError(error);
    }).whenComplete(() => jobs.remove(searchJob));

    searchJob.future.then((value) async {
      searchResult.addAll(value);
      setState(() {});
    }).catchError((e) {
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
            onTapItem: (data) async {
              Navigator.of(context)
                  .pushNamed("subject", arguments: data.subject);
            },
          ),
        ),
        GradientBackground(
          child: ActionBar(children: [
            Expanded(
              child: _buildSearchAction(context),
            ),
          ]),
        ),
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
