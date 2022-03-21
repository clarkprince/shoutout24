import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shoutout24/common/customdialog.dart';
import 'package:shoutout24/common/progressDialog.dart';
import 'package:shoutout24/services/auth_service.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/view/authentication/login.dart';
import 'package:shoutout24/widgets/custom_input_decoration.dart';
import 'package:shoutout24/widgets/roundedShoutOut24Btn.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();

  Widget _buildEmailField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        labelText: 'Email Address',
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.done,
      validator: (String value) {
        if (value.isEmpty) {
          return "Email address is required";
        }
        return null;
      },
      onSaved: (String value) {},
      onChanged: (value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter your email address and we will sent you a link to reset",
                textAlign: TextAlign.center,
              ),
              VerticalSpacing(
                height: 20,
              ),
              _buildEmailField(),
              VerticalSpacing(
                height: 20,
              ),
              ShoutOut24Btn(
                text: "Reset Password",
                press: () async {
                  print("resetting password");
                  if (_emailController.text.isNotEmpty) {
                    try {
                      showDialog(
                        context: context,
                        builder: (context) => ProgressDialog(
                          status: "Resetting password ....",
                        ),
                      );

                      await AuthService.resetPassword(
                        email: _emailController.text.trim(),
                      );
                      Navigator.pop(context);

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) => CustomDialog(
                                icon: FontAwesome.info_circle,
                                title: "Info",
                                description:
                                    "Password reset has been send to ${_emailController.text.trim()}",
                                cancelButtonText: "Ok",
                                okayPress: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ));
                      // _emailController.text = "";
                    } catch (e) {
                      print(e);
                      FirebaseException pe = e;
                      Navigator.pop(context);

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) => CustomDialog(
                                icon: FontAwesome.exclamation_circle,
                                title: "Error",
                                description: "${pe.message}",
                                cancelButtonText: "Ok",
                                okayPress: () {
                                  Navigator.pop(dialogContext);
                                  Navigator.pop(context);
                                },
                              ));

                      print(e);
                    }
                  }
                },
              ),
              VerticalSpacing(
                height: 20,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                      text: "Already have an account ? ",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: " Login",
                            style: TextStyle(
                                color: colorPrimaryDark,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("login clicked");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                              })
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
