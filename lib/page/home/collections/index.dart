import 'package:flutter/material.dart';
import 'package:neko/db/database.dart';
import 'package:neko/engine/database.dart';
import 'package:neko/view/subjectList.dart';
import 'package:neko/widget/actionbar.dart';
import 'package:neko/widget/ripple.dart';
import 'package:provider/provider.dart';

class CollectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: StreamBuilder(
            stream: Database.subject.watchCollections(),
            builder: (context, snapshot) {
              List<SubjectCollection> subjects = snapshot.data ?? [];
              return SubjectList(
                items: subjects,
                padding: EdgeInsets.fromLTRB(12, 56, 12, 12),
                showCollection: false,
              );
            },
          ),
        ),
        ActionBar(
          showGoBack: false,
          children: [
            Expanded(
              child: Container(
                child: Text(
                  "本地收藏",
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            ActionButton(
              icon: Icons.search,
              onTap: () {
                Navigator.of(context).pushNamed("search");
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 14),
              child: Ripple(
                onTap: () {},
                borderless: false,
                borderRadius: BorderRadius.circular(1000),
                backgroundColor: Colors.black12,
                child: Container(
                    padding: EdgeInsets.fromLTRB(12, 4, 8, 4),
                    child: Row(
                      children: [
                        Text("排序"),
                        SizedBox(width: 8),
                        Icon(
                          Icons.sort,
                          size: 21,
                          color: Colors.black54,
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ],
    );
  }
}
