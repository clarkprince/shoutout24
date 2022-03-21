import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/common/customdialog.dart';
import 'package:shoutout24/common/progressDialog.dart';
import 'package:shoutout24/model/groupModel.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/services/group_service.dart';
import 'package:shoutout24/view/group/chat_page.dart';
import 'package:shoutout24/view/homepage.dart';
import 'package:shoutout24/widgets/custom_input_decoration.dart';
import 'package:shoutout24/widgets/roundedShoutOut24Btn.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class CreateGroup extends StatefulWidget {
  final UserModel userModel;

  const CreateGroup({Key key, this.userModel}) : super(key: key);
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController _groupNameController = TextEditingController();

  TextEditingController _groupDescController = TextEditingController();

  FocusNode _groupDescFocus = FocusNode();

  _groupNameEditingComplete() {
    Focus.of(context).requestFocus(_groupDescFocus);
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildGroupNameField() {
      return TextFormField(
        decoration: CustomInputDecoration(
          labelText: 'Group Name',
        ),
        keyboardType: TextInputType.name,
        controller: _groupNameController,
        textInputAction: TextInputAction.next,
        onEditingComplete: _groupNameEditingComplete,
        validator: (String value) {
          if (value.isEmpty) {
            return "Name is required";
          }
          return null;
        },
      );
    }

    Widget _buildGroupDescField() {
      return TextFormField(
        decoration: CustomInputDecoration(
          labelText: 'Group Description',
        ),
        keyboardType: TextInputType.text,
        controller: _groupDescController,
        focusNode: _groupDescFocus,
        textInputAction: TextInputAction.next,
        validator: (String value) {
          if (value.isEmpty) {
            return " Group Description is required";
          }
          return null;
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(title: "Create Group"),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGroupNameField(),
              VerticalSpacing(),
              _buildGroupDescField(),
              VerticalSpacing(),
              ShoutOut24Btn(
                text: "Create Group",
                press: () {
                  // print("creating group");
                  if (_groupNameController.text.isNotEmpty &&
                      _groupDescController.text.isNotEmpty) {
                    _handleGroupCreation();
                  } else {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) => CustomDialog(
                              icon: FontAwesome.info,
                              title: "Validation Error",
                              description:
                                  "Group Name and Description are required",
                              cancelButtonText: "Ok",
                              okayPress: () {
                                Navigator.pop(dialogContext);
                              },
                            ));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleGroupCreation() async {
    showDialog(
      context: context,
      builder: (dialogContext) => ProgressDialog(
        status: "Creating Group",
      ),
    );
    try {
      String groupId = await GroupService().createGroup(
          userModel: widget.userModel,
          group: Group(
              groupName: _groupNameController.text.trim(),
              description: _groupDescController.text.trim()));
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MultiProvider(
                    providers: [
                      StreamProvider<UserModel>.value(
                        value: DatabaseService().getUserDetails(),
                      )
                    ],
                    child: ChatPage(
                      groupId: groupId,
                      groupName: _groupNameController.text.trim(),
                    ),
                  )));

      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (dialogContext) => CustomDialog(
      //           icon: FontAwesome.check_circle,
      //           title: "Success",
      //           description: "Group Created successfully",
      //           cancelButtonText: "Ok",
      //           okayPress: () {
      //             Navigator.of(context).pop();
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (dialogContext) => HomePage(
      //                           selectedPage: 3,
      //                         )));
      //           },
      //         ));
    } catch (error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => CustomDialog(
                icon: FontAwesome.exclamation,
                title: "Error",
                description: "Unable to create Group try again later",
                cancelButtonText: "Ok",
                okayPress: () {
                  Navigator.pop(dialogContext);
                },
              ));
      print(error);
    }
  }
}
