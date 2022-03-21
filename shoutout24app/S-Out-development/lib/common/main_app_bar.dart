import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/pop_up_option_menu.dart';
import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/services/auth_service.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/view/message/history_message_list.dart';

Widget mainAppBar(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 15.0),
    width: MediaQuery.of(context).size.width,
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: InkWell(
            splashColor: colorAccent,
            onTap: () {},
            child: Icon(
              Icons.menu,
              color: colorAccent,
              size: 27.0,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            height: 50.0,
            width: 300.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain)),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: colorAccent,
                size: 27.0,
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
              }),
        ),
      ],
    ),
  );
}
