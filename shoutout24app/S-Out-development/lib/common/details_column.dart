import 'package:flutter/material.dart';

class DetailsColumn extends StatelessWidget {
  final String value;
  final String title;

  const DetailsColumn({Key key, this.value, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5.0),
        Text(title, style: TextStyle(fontSize: 18.0, color: Colors.grey)),
        SizedBox(height: 8.0),
        Text(value,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
        SizedBox(height: 4.0),
        Divider(
          thickness: 1.0,
        )
      ],
    );
  }
}
