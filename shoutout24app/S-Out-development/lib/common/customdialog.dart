import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/widgets/roundedShoutOut24Btn.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, okayButtonText, cancelButtonText;
  final Function okayPress;
  final IconData icon;

  const CustomDialog(
      {Key key,
      @required this.title,
      @required this.description,
      this.icon,
      this.okayButtonText,
      this.okayPress,
      this.cancelButtonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon != null
                  ? Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: new BoxDecoration(
                        color: colorOrange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: Colors.white,
                        ),
                      ))
                  : Container(),
              VerticalSpacing(),
              Text(
                title,
                style: GoogleFonts.oswald(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0),
              ),
              VerticalSpacing(),
              Text(
                description,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              VerticalSpacing(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  okayButtonText != null
                      ? Expanded(
                          child: ShoutOut24Btn(
                            press: okayPress,
                            text: okayButtonText,
                            color: colorAccent,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: cancelButtonText != null
                        ? ShoutOut24Btn(
                            text: cancelButtonText,
                            color: Colors.grey,
                            press: () {
                              Navigator.of(context).pop();
                            },
                          )
                        : Container(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
