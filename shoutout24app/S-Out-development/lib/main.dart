import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/utils/routes.dart';
import 'package:shoutout24/view/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoutOut24',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: colorPrimary,
          accentColor: colorAccent,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            textTheme: GoogleFonts.oswaldTextTheme(Theme.of(context).textTheme),
          ),
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)),
      home: Wrapper(),
      routes: routes,
    );
  }
}
