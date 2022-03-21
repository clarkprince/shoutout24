import 'package:flutter/material.dart';
import 'package:shoutout24/utils/color.dart';

class ShoutOut24Btn extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final bool wrapContent = false;
  const ShoutOut24Btn({
    Key key,
    this.text,
    this.press,
    this.color = colorPrimaryDark,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29.0),
        child: FlatButton(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            color: color,
            child: Text(
              text.toUpperCase(),
              style: TextStyle(color: textColor),
            ),
            onPressed: press),
      ),
    );
  }
}
