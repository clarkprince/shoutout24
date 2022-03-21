import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/common/customdialog.dart';
import 'package:shoutout24/common/progressDialog.dart';
import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/model/help_menuModel.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/services/send_message.dart';
import 'package:shoutout24/services/timer_service.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class HelpMenu extends StatelessWidget {
  HelpMenu({Key key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ContactModel> _contacts;
  UserModel _user;

  _handleSendingMessage(HMenu help, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        status: "Sending Message",
      ),
    );
    String message = '';
    if (help.id == 1) {
      message = "Shoutout24: ${_user.name} would like you to check on them.";
    }
    if (help.id == 2) {
      message =
          "Shoutout24: ${_user.name} would like your help getting home safely";
    }

    if (help.id == 3) {
      message =
          "Shoutout24: ${_user.name} would like to get some healthy relationship advice";
    }

    try {
      if (help.id == 4) {
        Provider.of<CustomTimerService>(context, listen: false)
            .handleSendingLocationDetails(contacts: _contacts, user: _user);
        Navigator.pop(context);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => CustomDialog(
                  icon: FontAwesome5.check_circle,
                  title: "Success",
                  description: "Sharing location with your contacts",
                  cancelButtonText: "Ok",
                  okayPress: () {
                    Navigator.pop(dialogContext);
                  },
                ));
      } else {
        SendMessageService.sendMessage(message: message, contacts: _contacts);
        await DatabaseService()
            .sendMessage(message: message, contacts: _contacts);
        Navigator.pop(context);

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => CustomDialog(
                  icon: FontAwesome5.check_circle,
                  title: "Success",
                  description: "Message Sent Successfully",
                  cancelButtonText: "Ok",
                  okayPress: () {
                    Navigator.pop(dialogContext);
                  },
                ));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _contacts = Provider.of<List<ContactModel>>(context);
    _user = Provider.of(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customAppBar(
                title: "Help",
                centered: true,
                showLogout: true,
                context: context,
                showHomeMenu: true),
            VerticalSpacing(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: appMenu.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Column(
                        children: [
                          InkWell(
                            splashColor: colorAccent,
                            onTap: () {
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
                                  context: _scaffoldKey.currentContext,
                                  barrierDismissible: false,
                                  builder: (dialogContext) => CustomDialog(
                                        icon: FontAwesome5.question_circle,
                                        title: "Confirmation",
                                        description:
                                            "Are you sure you want to send Message ?",
                                        okayButtonText: "Yes",
                                        cancelButtonText: "Cancel",
                                        okayPress: () {
                                          Navigator.pop(dialogContext);
                                          _handleSendingMessage(
                                              appMenu[index], context);
                                        },
                                      ));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10.0),
                              child: Text(
                                appMenu[index].title,
                                style: GoogleFonts.oswald(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: Divider(
                              thickness: 1,
                              color: colorAccent,
                            ),
                          ),
                          VerticalSpacing(),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
