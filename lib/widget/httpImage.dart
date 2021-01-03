import 'package:flutter/cupertino.dart';

class HttpImage extends StatelessWidget {
  final Map req;
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;
  const HttpImage({
    Key key,
    this.req,
    this.borderRadius,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(req["url"] ?? ""),
          fit: BoxFit.cover,
        ),
        borderRadius: borderRadius,
      ),
    );
  }
}
