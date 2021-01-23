import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neko/engine/http.dart';
import 'package:neko/widget/httpImage.dart';
import 'package:neko/widget/ripple.dart';

Widget subjectTypeIcon(String subjectType) => Icon(
      subjectType == "book"
          ? Icons.book
          : subjectType == "music"
              ? Icons.music_note
              : subjectType == "video"
                  ? Icons.movie
                  : Icons.error,
      color: Colors.black38,
      size: 16,
    );

class SubjectInfo extends StatelessWidget {
  final Map info;
  final bool isCollected;
  final void Function() onCollectTap;

  const SubjectInfo({
    Key key,
    this.info,
    this.isCollected = false,
    this.onCollectTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HttpImage(
                  req: Http.wrapReq(info["image"]),
                  borderRadius: BorderRadius.circular(6),
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info["name"] ?? "",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                subjectTypeIcon(info["type"]),
                                SizedBox(width: 4),
                                Text(info["site"] ?? ""),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            (info["score"] ?? "-").toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Ripple(
              onTap: onCollectTap,
              borderless: false,
              borderRadius: BorderRadius.circular(1000),
              padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
              backgroundColor: Theme.of(context).primaryColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCollected ? Icons.favorite : Icons.favorite_outline,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(width: 6),
                  Text(
                    isCollected ? "已收藏" : "收藏",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Wrap(
            spacing: 8,
            children: [
              ...(info["tags"] ?? []).map((v) {
                return Ripple(
                  onTap: () {},
                  borderless: false,
                  borderRadius: BorderRadius.circular(1000),
                  backgroundColor: Colors.black12,
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Text(v),
                );
              })
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(info["summary"]),
        SizedBox(height: 8),
      ],
    );
  }
}
