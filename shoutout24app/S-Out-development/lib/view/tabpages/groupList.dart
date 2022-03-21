import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/model/groupModel.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/view/group/chat_page.dart';
import 'package:shoutout24/view/group/create_group.dart';
import 'package:shoutout24/view/group/search_group.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class GroupListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    List<Group> _myGroups = _userModel?.group;

    return SafeArea(
      child: Scaffold(
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: colorAccent, size: 20),
                  elevation: 6.0,
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  title: Text(
                    "My Groups",
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          color: colorAccent,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchGroupPage()));
                        })
                  ],
                ),
                VerticalSpacing(),
                Expanded(
                    child: (_myGroups?.length ?? 0) > 0
                        ? ListView.separated(
                            itemCount: _myGroups.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: colorAccent,
                                  child: Text(_myGroups[index]
                                      .description
                                      .substring(0, 2)
                                      .toUpperCase())),
                              title: Text(_myGroups[index].groupName),
                              subtitle: Text(_myGroups[index].description),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MultiProvider(
                                            providers: [
                                              StreamProvider<UserModel>.value(
                                                value: DatabaseService()
                                                    .getUserDetails(),
                                              )
                                            ],
                                            child: ChatPage(
                                              groupName:
                                                  _myGroups[index].groupName,
                                              groupId: _myGroups[index].id,
                                            ),
                                          ))),
                            ),
                            separatorBuilder: (context, index) => Divider(),
                          )
                        : Center(
                            child: Text(
                                "You Haven't Joined or created any group")))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateGroup(
                            userModel: _userModel,
                          )));
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
            ),
          )),
    );
  }
}
