import 'package:flutter/material.dart';
import 'package:shoutout24/utils/color.dart';

class CustomInputDecoration extends InputDecoration {
  final String labelText;
  final String hintText;

  CustomInputDecoration({this.hintText, this.labelText})
      : super(
            labelText: labelText,
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor, fontSize: 18.0),
            border: InputBorder.none,
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: colorAccent)),
            fillColor: Colors.white,
            filled: true);
}
