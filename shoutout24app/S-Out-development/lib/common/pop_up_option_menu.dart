import 'package:flutter/material.dart';
import 'package:shoutout24/services/auth_service.dart';

enum MenuOption { LogOut, TermsCondition }

class PopupOptionMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOption>(
      onSelected: (value) {
        if (value == MenuOption.LogOut) AuthService.logOut();
        if (value == MenuOption.TermsCondition) print("opening amount App");
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<MenuOption>>[
          PopupMenuItem(
            child: Text("Sign out"),
            value: MenuOption.LogOut,
          ),
          PopupMenuItem(
            child: Text("Terms & Conditions"),
            value: MenuOption.TermsCondition,
          ),
        ];
      },
    );
  }
}
