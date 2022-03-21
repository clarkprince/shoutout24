import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/services/recorder_provider.dart';
import 'package:shoutout24/services/timer_service.dart';
import 'package:shoutout24/view/authentication/login.dart';
import 'package:shoutout24/view/homepage.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return MultiProvider(providers: [
              ChangeNotifierProvider<AudioRecorderProvider>(
                  create: (_) => AudioRecorderProvider()),
              ChangeNotifierProvider<CustomTimerService>(
                  create: (_) => CustomTimerService()),
              StreamProvider<List<ContactModel>>.value(
                value: DatabaseService().getUserContact(),
              ),
              StreamProvider<UserModel>.value(
                value: DatabaseService().getUserDetails(),
              )
            ], child: HomePage());
          }
          return LoginPage();
        });
  }
}
