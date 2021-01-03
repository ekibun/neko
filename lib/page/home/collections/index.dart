import 'package:flutter/material.dart';
import 'package:neko/model/collection.dart';
import 'package:neko/view/subjectList.dart';
import 'package:neko/widget/actionbar.dart';
import 'package:neko/widget/httpImage.dart';
import 'package:neko/widget/ripple.dart';
import 'package:provider/provider.dart';

class CollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Consumer<CollectionModel>(
            builder: (context, model, child) {
              return SubjectList(
                items: model.lists,
                padding: EdgeInsets.fromLTRB(12, 56, 12, 12),
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
