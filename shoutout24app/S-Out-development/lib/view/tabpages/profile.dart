import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/common/details_column.dart';
import 'package:shoutout24/common/main_app_bar.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/view/authentication/signup.dart';
import 'package:shoutout24/widgets/roundedShoutOut24Btn.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _user = Provider.of<UserModel>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // mainAppBar(context),
            customAppBar(
              title: "Profile",
              centered: true,
              showLogout: true,
              context: context,
            ),

            VerticalSpacing(),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  GestureDetector(
                    onTap: () => print('clicked'),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            // gradient: MyTheme.linearGradient,
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/images/camera.png",
                              height: 18,
                              width: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DetailsColumn(
                    title: "Name",
                    value: _user?.name ?? 'loading',
                  ),
                  DetailsColumn(
                    title: "email",
                    value: _user?.email ?? 'loading',
                  ),
                  DetailsColumn(
                    title: "Mobile Number",
                    value: _user?.mobileNo ?? 'loading',
                  ),
                  (_user?.address ?? null) != null
                      ? DetailsColumn(
                          title: "Address",
                          value: _user?.address ?? 'loading',
                        )
                      : Container(),
                  VerticalSpacing(),
                  ShoutOut24Btn(
                    text: "Edit",
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpPage(
                                userModel: _user,
                              )));
                    },
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
