import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String status;
  ProgressDialog({this.status});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
        child: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            CircularProgressIndicator(),
            SizedBox(
              width: 25.0,
            ),
            Expanded(
              child: Text(
                status,
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
