import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:neko/db/dataHelper.dart';
import 'package:neko/db/database.dart';
import 'package:neko/engine/database.dart';
import 'package:neko/engine/datasource.dart';
import 'package:neko/engine/http.dart';
import 'package:neko/page/subject/subjectInfo.dart';
import 'package:neko/widget/actionbar.dart';
import 'package:neko/widget/httpImage.dart';

class SubjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubjectPage();
  }
}

class _SubjectPage extends State<SubjectPage> {
  Map subjectInfo;
  Collection collection;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final Subject subject = ModalRoute.of(context).settings.arguments;
      Database.subject.getCollection(subject).then((value) {
        collection = value;
        setState(() {});
      });
      setState(() {
        subjectInfo = subjectToMap(subject);
        updateSubject();
      });
    });
  }

  Completer subjectUpdateJob;
  updateSubject() {
    if (subjectUpdateJob?.isCompleted == false) {
      subjectUpdateJob.completeError("cancel"); // cancel
    }
    subjectUpdateJob = Completer();
    DataSource.getProvider(subjectInfo["site"]).then((value) async {
      final newInfo = await value["getSubjectInfo"].invoke([subjectInfo]);
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
      child: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: HttpImage.getImage(Http.wrapReq(subjectInfo["image"])),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
          Column(mainAxisSize: MainAxisSize.max, children: [
            Theme(
              data: Theme.of(context).copyWith(brightness: Brightness.dark),
              child: ActionBar(children: [
                Expanded(
                  child: Text(
                    subjectInfo != null ? subjectInfo["name"] : "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.white),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 700,
                ),
                child: LayoutBuilder(builder: (context, constraint) {
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Material(
                      clipBehavior: Clip.hardEdge,
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: Container(
                        constraints:
                            BoxConstraints(minHeight: constraint.maxHeight),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SubjectInfo(
                              info: subjectInfo ?? {},
                              isCollected: collection != null,
                              onCollectTap: () {
                                if (collection != null) {
                                  Database.subject.removeCollection(collection);
                                  collection = null;
                                } else {
                                  final subject = subjectfromMap(subjectInfo);
                                  final nowTime = DateTime.now();
                                  collection = Collection(
                                    site: subject.site,
                                    id: subject.id,
                                    createTime: nowTime,
                                    updateTime: nowTime,
                                  );
                                  Database.subject.insertSubjectCollection(
                                      SubjectCollection()
                                        ..subject = subject
                                        ..collection = collection);
                                }
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
