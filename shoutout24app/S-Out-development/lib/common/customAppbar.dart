import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shoutout24/services/auth_service.dart';
import 'package:shoutout24/utils/color.dart';

Widget customAppBar(
    {String title,
    bool centered = false,
    bool showLogout = false,
    BuildContext context,
    bool showHomeMenu = false}) {
  return AppBar(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: colorAccent, size: 20),
    elevation: 1.0,
    leading: showHomeMenu
        ? IconButton(
            icon: Icon(
              Icons.menu,
              color: colorAccent,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            })
        : null,
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    centerTitle: centered,
    actions: [
      showLogout
          ? IconButton(
              icon: Icon(
                Icons.more_vert,
                color: colorAccent,
              ),
              onPressed: () {
                return showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Options"),
                      children: [
                        SimpleDialogOption(
                          child: Row(
                            children: [
                              Icon(
                                FontAwesome.lock,
                                color: colorAccent,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Log out")
                            ],
                          ),
                          onPressed: () {
                            AuthService.logOut();
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: SimpleDialogOption(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        )
                      ],
                    );
                  },
                );
              })
          : Container()
    ],
  );
}
