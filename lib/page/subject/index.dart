import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neko/db/dataHelper.dart';
import 'package:neko/db/database.dart';
import 'package:neko/engine/datasource.dart';
import 'package:neko/widget/actionbar.dart';

class SubjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubjectPage();
  }
}

class _SubjectPage extends State<SubjectPage> {
  Map subjectInfo;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final Subject subject = ModalRoute.of(context).settings.arguments;
      setState(() {
        subjectInfo = subjectToMap(subject);
        updateSubject();
      });
    });
  }

  Completer subjectUpdateJob;
  Future updateSubject() {
    if (subjectUpdateJob?.isCompleted == false) {
      subjectUpdateJob.completeError("cancel"); // cancel
    }
    subjectUpdateJob = Completer();
    DataSource.getProvider(subjectInfo["site"]).then((value) async {
      final newInfo = await value["getSubjectInfo"].invoke([subjectInfo]);
      assert(newInfo["site"] == subjectInfo["site"] &&
          newInfo["id"] == subjectInfo["id"]);
      if (!subjectUpdateJob.isCompleted) subjectUpdateJob.complete(newInfo);
    }).catchError((error) {
      print(error);
      if (subjectUpdateJob.isCompleted) return;
      subjectUpdateJob.completeError(error);
    });
    subjectUpdateJob.future.then((value) {
      setState(() {
        subjectInfo = value;
      });
    }).catchError((error) {
      print("subject update error:\n$error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(12, 60, 12, 12),
            child: Text(subjectInfo.toString() ?? ""),
          ),
        ),
        ActionBar(children: [
          Expanded(
            child: Text(subjectInfo["name"]),
          ),
        ]),
      ]),
    );
  }
}
