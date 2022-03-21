import 'package:flutter/material.dart';
import 'package:shoutout24/utils/color.dart';

Widget createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          color: colorOrange,
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            text,
            style: TextStyle(color: colorAccent, fontSize: 16.0),
          ),
        )
      ],
    ),
    onTap: onTap,
  );
}
