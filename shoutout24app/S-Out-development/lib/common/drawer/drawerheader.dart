import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoutout24/utils/color.dart';

Widget createDrawerHeader({String username}) {
  return DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
    ),
    child: Stack(
      children: <Widget>[
        Positioned(
          bottom: 2.0,
          left: 16.0,
          child: Text(
            username,
            style: TextStyle(fontSize: 18, color: colorAccent),
          ),
        )
      ],
    ),
  );
}
