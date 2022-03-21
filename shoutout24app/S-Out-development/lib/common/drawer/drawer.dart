import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/drawer/drawerheader.dart';
import 'package:shoutout24/common/drawer/draweritem.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/services/auth_service.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/services/recorder_provider.dart';
import 'package:shoutout24/view/audio_recordings/audio_recording.dart';
import 'package:shoutout24/view/tabpages/profile.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  UserModel _user;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          createDrawerHeader(username: _user.name ?? "No User"),
          SizedBox(height: 15.0),
          createDrawerItem(
              icon: Icons.group,
              text: 'Profile',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(providers: [
                              StreamProvider<UserModel>.value(
                                value: DatabaseService().getUserDetails(),
                              )
                            ], child: ProfileTab())));
              }),
          createDrawerItem(
              icon: FontAwesome.file_sound_o,
              text: "My Audios",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(providers: [
                              ChangeNotifierProvider<AudioRecorderProvider>(
                                create: (_) => AudioRecorderProvider(),
                              )
                            ], child: AudioRecordingPage())));
              }),
          createDrawerItem(
              icon: FontAwesome.lock,
              text: "Log out",
              onTap: () {
                AuthService.logOut();
              }),
          VerticalSpacing(
            height: 20,
          ),
          createDrawerItem(
            icon: Icons.verified_user,
            text: "V-0.01",
          )
        ],
      ),
    );
  }
}
