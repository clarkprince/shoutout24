import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoutout24/utils/color.dart';

class Badge extends StatelessWidget {
  final int count;
  final Color color;

  const Badge({Key key, @required this.count, this.color = colorAccent})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        // padding: EdgeInsets.all(5.0),
        height: 25.0,
        width: 25.0,
        color: color,
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
