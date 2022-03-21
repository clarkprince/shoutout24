import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/drawer/drawer.dart';
import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/view/tabpages/contacts.dart';
import 'package:shoutout24/view/tabpages/groupList.dart';
import 'package:shoutout24/view/tabpages/helpmenu.dart';
import 'package:shoutout24/view/tabpages/home.dart';
import 'package:shoutout24/view/tabpages/profile.dart';

class HomePage extends StatefulWidget {
  final int selectedPage;

  const HomePage({Key key, this.selectedPage}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onBarItemTap(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(),
        body: [HomeTab(), HelpMenu(), ContactsTab(), GroupListPage()].elementAt(
            widget.selectedPage != null ? widget.selectedPage : _selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_sharp), label: "Contacts"),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups")
          ],
          currentIndex: _selectedIndex,
          onTap: _onBarItemTap,
        ),
      ),
    );
  }
}
