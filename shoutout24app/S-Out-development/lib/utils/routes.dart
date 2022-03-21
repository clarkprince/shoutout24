import 'package:flutter/material.dart';
import 'package:shoutout24/view/authentication/login.dart';
import 'package:shoutout24/view/authentication/signup.dart';
import 'package:shoutout24/view/homepage.dart';
import 'package:shoutout24/view/tabpages/profile.dart';
import 'package:shoutout24/view/wrapper.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomePage(),
  "/login": (BuildContext context) => LoginPage(),
  "/signUp": (BuildContext context) => SignUpPage(),
  "/wrapper": (BuildContext context) => Wrapper(),
  "/profile": (BuildContext context) => ProfileTab(),
};
