import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neko/db/database.dart';
import 'package:neko/widget/httpImage.dart';
import 'package:neko/widget/ripple.dart';

class SubjectList extends StatelessWidget {
  final List<SubjectCollection> items;
  final EdgeInsets padding;
  final void Function(SubjectCollection) onTapItem;
  final bool showCollection;

  const SubjectList({
    Key key,
    this.items,
    this.padding,
    this.onTapItem,
    this.showCollection = true,
  }) : super(key: key);

  Widget _buildItem(BuildContext context, int index) {
    var data = items[index];
    return Ripple(
      padding: EdgeInsets.all(12),
      borderless: false,
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Theme.of(context).cardColor,
      onTap: () {
        onTapItem?.call(data);
      },
      child: Row(
        children: [
          HttpImage(
            req: jsonDecode(data?.subject?.image ?? "") ?? {},
            borderRadius: BorderRadius.circular(6),
            width: 100,
            height: 100,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        (data?.subject?.subjectType ?? "") +
                            (data?.subject?.name ?? ""),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ]..addAll(showCollection && data?.collection != null
                      ? [
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10000),
                            ),
                            child: Text(
                              "已收藏",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ]
                      : []),
                ),
                SizedBox(height: 8),
                Text(
                  data?.subject?.summary ?? "",
                  softWrap: true,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      clipBehavior: Clip.none,
      padding: padding,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500,
        mainAxisExtent: 124,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: _buildItem,
      itemCount: items.length,
    );
  }
}
