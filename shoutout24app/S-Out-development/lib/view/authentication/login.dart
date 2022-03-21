import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shoutout24/common/progressDialog.dart';
import 'package:shoutout24/services/auth_service.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/utils/style.dart';
import 'package:shoutout24/view/authentication/forgotpassword.dart';
import 'package:shoutout24/view/authentication/signup.dart';
import 'package:shoutout24/widgets/custom_input_decoration.dart';
import 'package:shoutout24/widgets/roundedShoutOut24Btn.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _passwordVisible = true;

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        labelText: 'Email Address',
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      validator: (String value) {
        if (value.isEmpty) {
          return "Email address is required";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: colorAccent)),
          filled: true,
          fillColor: Colors.white,
          hintText: "Password",
          suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                  print(_passwordVisible);
                });
              })),
      obscureText: _passwordVisible ? true : false,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete: () {},
      validator: (String value) {
        if (value.isEmpty) {
          return "Password is required";
        }
        return null;
      },
    );
  }

  void _showError(String error) {
    final snackBar = SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _showSuccess(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      // backgroundColor: Theme.of(context).errorColor,
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _clearInput() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "WELCOME",
                        style: titleStyle,
                      ),
                      VerticalSpacing(),
                      Text("This is your safe space")
                    ],
                  ),
                ),
                VerticalSpacing(
                  height: 20.0,
                ),
                _buildEmailField(),
                VerticalSpacing(),
                _buildPasswordField(),
                VerticalSpacing(),
                ShoutOut24Btn(
                  text: "Login",
                  press: () async {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      try {
                        showDialog(
                          context: context,
                          builder: (context) => ProgressDialog(
                            status: "Authenticating user please Wait ....",
                          ),
                        );
                        final User user = await AuthService.signInWithEmail(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim());
                        Navigator.pop(context);

                        if (user != null) {
                          _showSuccess("Success");
                          _clearInput();
                          Timer(Duration(seconds: 3), () {
                            Navigator.of(context)
                                .pushReplacementNamed('/wrapper');
                          });
                        }
                      } catch (e) {
                        print(e);
                        FirebaseException pe = e;
                        _showError(pe.message);
                        Navigator.pop(context);
                        print(e);
                      }
                    }
                  },
                ),
                VerticalSpacing(),
                Align(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                    child: Text("Forgot Password ?"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                    },
                  ),
                ),
                VerticalSpacing(
                  height: 20,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: "New User ? ",
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        children: <TextSpan>[
                          TextSpan(
                              text: " Create an account",
                              style: TextStyle(
                                  color: colorPrimaryDark,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SignUpPage(
                                            userModel: null,
                                          )));
                                })
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
