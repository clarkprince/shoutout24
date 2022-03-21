import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/common/customdialog.dart';
import 'package:shoutout24/common/drawer/drawer.dart';
import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/model/groupModel.dart';
import 'package:shoutout24/model/messageMode.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/services/recorder_provider.dart';
import 'package:shoutout24/services/timer_service.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/utils/style.dart';
import 'package:shoutout24/view/group/chat_page.dart';
import 'package:shoutout24/view/message/history_message_list.dart';
import 'package:shoutout24/view/tabpages/addcontact.dart';
import 'package:shoutout24/widgets/roundedShoutOut24Btn.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class HomeTab extends StatelessWidget {
  final List<Color> circleColors = [
    colorPrimary,
    Colors.black,
    colorAccent,
    colorOrange
  ];
  List<ContactModel> _contacts;
  UserModel _user;
  Color randomColor() {
    return circleColors[new Random().nextInt(4)];
  }

  @override
  Widget build(BuildContext context) {
    _contacts = Provider.of<List<ContactModel>>(context);
    _user = Provider.of(context);
    List<Group> _myGroups = _user?.group;

    double _screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: AppDrawer(),
        body: Column(
          children: [
            customAppBar(
                title: "Home",
                centered: true,
                showLogout: true,
                context: context,
                showHomeMenu: true),
            VerticalSpacing(),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: ListView(
                children: [
                  _user != null
                      ? Text(
                          "Hi, ${_user.name}",
                          style: titleStyle,
                        )
                      : Text('loading ...'),
                  VerticalSpacing(
                    height: 20.0,
                  ),
                  Column(
                    children: [
                      !Provider.of<CustomTimerService>(context).isSharing
                          ? InkWell(
                              splashColor: colorAccent,
                              onLongPress: () async {
                                bool isLocationServiceEnabled =
                                    await Geolocator.isLocationServiceEnabled();

                                if (!isLocationServiceEnabled) {
                                  // await Geolocator.openLocationSettings();
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (dialogContext) => CustomDialog(
                                            icon: FontAwesome.info_circle,
                                            title: "Alert",
                                            description:
                                                "Location services are disabled Please enable them from your app settings to allow ShoutOut24 get your location",
                                            cancelButtonText: "Ok",
                                            okayPress: () async {
                                              // await Geolocator
                                              //     .openAppSettings();
                                              Navigator.pop(dialogContext);
                                            },
                                          ));

                                  return;
                                }

                                if (_contacts.length == 0) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (dialogContext) => CustomDialog(
                                            icon: FontAwesome.info_circle,
                                            title: "Alert",
                                            description: "Create contact first",
                                            cancelButtonText: "Ok",
                                            okayPress: () {
                                              Navigator.pop(dialogContext);
                                            },
                                          ));
                                  return;
                                }
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (dialogContext) => CustomDialog(
                                          icon: FontAwesome5.question_circle,
                                          title: "Confirmation",
                                          description:
                                              "Are you sure you want to send an Emergency Message ?",
                                          okayButtonText: "Yes",
                                          cancelButtonText: "Cancel",
                                          okayPress: () {
                                            Navigator.pop(dialogContext);

                                            Provider.of<CustomTimerService>(
                                                    context,
                                                    listen: false)
                                                .handleSendingLocationDetails(
                                                    user: _user,
                                                    contacts: _contacts);

                                            Provider.of<AudioRecorderProvider>(
                                                    context,
                                                    listen: false)
                                                .startRecording();
                                          },
                                        ));
                              },
                              child: Container(
                                height: _screenHeight / 4,
                                width: _screenHeight / 4,
                                decoration: BoxDecoration(
                                    color: colorAccent,
                                    borderRadius: BorderRadius.circular(
                                        _screenHeight / 8),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 15.0,
                                          spreadRadius: 0.1,
                                          offset: Offset(0.7, 0.7))
                                    ]),
                                child: Center(
                                    child: Text(
                                  "HOLD FOR HELP",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                )),
                              ),
                            )
                          :
                          // show recording status
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Text(
                                      "sharing your location with your contacts & recording Audio"),
                                  VerticalSpacing(),
                                  ShoutOut24Btn(
                                    text: "Stop Sharing",
                                    press: () {
                                      Provider.of<AudioRecorderProvider>(
                                              context,
                                              listen: false)
                                          .stopRecording();
                                      Provider.of<CustomTimerService>(context,
                                              listen: false)
                                          .stopSharingLocation();
                                    },
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                  VerticalSpacing(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  VerticalSpacing(),
                  Text("My Contacts",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  // VerticalSpacing(),
                  (_contacts?.length ?? 0) > 0
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (final contact in _contacts)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: randomColor(),
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        child: Center(
                                            child: Text(
                                          contact.name
                                              .substring(0, 2)
                                              .toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        )),
                                      ),
                                      Container(
                                          width: 70.0,
                                          child: Text(
                                            contact.name,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            Text('No Contacts found'),
                            SizedBox(
                              width: 20.0,
                            ),
                            FlatButton(
                              child: Text("Add contact"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddContact()));
                              },
                            )
                          ],
                        ),
                  Divider(
                    color: Colors.grey,
                  ),
                  VerticalSpacing(
                    height: 15,
                  ),
                  Text("My Groups",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  (_myGroups?.length ?? 0) > 0
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (final group in _myGroups)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 20),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MultiProvider(
                                                        providers: [
                                                          StreamProvider<
                                                              UserModel>.value(
                                                            value: DatabaseService()
                                                                .getUserDetails(),
                                                          )
                                                        ],
                                                        child: ChatPage(
                                                          groupName:
                                                              group.groupName,
                                                          groupId: group.id,
                                                        ),
                                                      )));
                                        },
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: randomColor(),
                                              borderRadius:
                                                  BorderRadius.circular(35)),
                                          child: Center(
                                              child: Text(
                                            group.groupName
                                                .substring(0, 2)
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          )),
                                        ),
                                      ),
                                      VerticalSpacing(
                                        height: 6.0,
                                      ),
                                      Container(
                                          width: 70.0,
                                          child: Text(
                                            group.groupName,
                                            overflow: TextOverflow.ellipsis,
                                          ))
                                    ],
                                  ),
                                ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 20.0, bottom: 10),
                          child: Text("You don't belong to any group")),
                  Divider(
                    color: Colors.grey,
                  ),
                  VerticalSpacing(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StreamProvider<List<MessageModel>>.value(
                                      value:
                                          DatabaseService().getUserMessages(),
                                      child: SentMessageHistoryList())));
                    },
                    child: Text("My message history",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
