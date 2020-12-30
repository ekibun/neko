import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String title;
  final bool isSelected;
  final Orientation orientation;

  const TabItem(
    this.icon,
    this.title, {
    Key key,
    this.isSelected = false,
    this.onTap,
    this.orientation = Orientation.portrait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLandscape = this.orientation == Orientation.landscape;
    var childern = <Widget>[
      Icon(
        icon,
        size: isLandscape ? 24 : 18,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      SizedBox.fromSize(
        size: isLandscape ? Size(4, 0) : Size(0, 4),
      ),
      Text(
        title,
        style: TextStyle(
            fontSize: isLandscape ? 18 : 12,
            color: isSelected ? Theme.of(context).primaryColor : null),
      ),
    ];
    return InkWell(
        onTap: onTap,
        child: isLandscape
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  children: childern,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: childern,
              ));
  }
}
