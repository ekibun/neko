import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neko/widget/ripple.dart';

class EpisodeInfo extends StatelessWidget {
  final List eps;
  final void Function(Map ep) onEpisodeTap;

  const EpisodeInfo({
    Key key,
    this.eps,
    this.onEpisodeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1, color: Colors.grey.withOpacity(0.2)),
        SizedBox(height: 12),
        Text(
          "  剧集",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Wrap(
            spacing: 8,
            children: [
              ...(eps ?? []).map((v) {
                return Ripple(
                  onTap: () {
                    if (v is Map) onEpisodeTap(v);
                  },
                  borderless: false,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.black12,
                  width: 200,
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Text(
                    (v is Map ? v["name"] : null) ?? v.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              })
            ],
          ),
        ),
      ],
    );
  }
}
