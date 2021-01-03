/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-08-27 16:19:23
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-27 16:31:58
 */
import 'package:flutter/cupertino.dart';

typedef MediaQueryTrigger = bool Function(MediaQueryData);

class ScreenAdapt extends StatelessWidget {
  final Widget child;
  final Widget childElse;
  final MediaQueryTrigger trigger;

  const ScreenAdapt({
    Key key,
    this.child,
    this.childElse,
    this.trigger,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return trigger(MediaQuery.of(context)) ? child : childElse;
  }
}

class MediaQueryTriggers {
  static final MediaQueryTrigger isTablet =
      (mediaquery) => mediaquery.size.width > 500;
}
