import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/common/customdialog.dart';
import 'package:shoutout24/common/progressDialog.dart';
import 'package:shoutout24/model/group_details_model.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/services/group_service.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/view/group/chat_page.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class SearchGroupPage extends StatefulWidget {
  @override
  _SearchGroupPageState createState() => _SearchGroupPageState();
}

class _SearchGroupPageState extends State<SearchGroupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _searchController = TextEditingController();

  List<GroupDetails> _groupDetails = [];
  List<GroupDetails> _searchedGroup = [];
  bool _alreadyMember = false;

  Widget _buildSearchField() {
    return TextFormField(
      decoration: InputDecoration(
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: colorAccent)),
          filled: true,
          fillColor: Colors.white,
          hintText: "Search group....",
          suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
              })),
      controller: _searchController,
      keyboardType: TextInputType.name,
      onChanged: _handleOnSearch,
    );
  }

  _handleOnSearch(String searchKey) async {
    print('searching $searchKey');
    _searchedGroup.clear();
    if (searchKey.isEmpty) {
      setState(() {
        return;
      });
    }
    _groupDetails.forEach((GroupDetails data) {
      if (data.groupName.toLowerCase().contains(searchKey.toLowerCase()) ||
          data.description.contains(searchKey)) {
        setState(() {
          _searchedGroup.add(data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Column(
            children: [
              customAppBar(title: "Search Group"),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 16, right: 16),
                child: _buildSearchField(),
              ),
              VerticalSpacing(),
              Expanded(
                  child: StreamBuilder<List<GroupDetails>>(
                stream: GroupService().getAllGroups(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("An error has occurred: ${snapshot.error}");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null)
                    return Center(child: CircularProgressIndicator());
                  _groupDetails = snapshot.data;
                  return _searchedGroup.length != 0 ||
                          _searchController.text.isNotEmpty
                      ? ListView.separated(
                          itemCount: _searchedGroup.length,
                          itemBuilder: (context, index) {
                            return _groupDetailsWidget(_searchedGroup[index]);
                          },
                          separatorBuilder: (context, index) => Divider(),
                        )
                      : _groupDetails.length > 0
                          ? ListView.separated(
                              itemCount: _groupDetails.length,
                              itemBuilder: (context, index) {
                                return _groupDetailsWidget(
                                    _groupDetails[index]);
                              },
                              separatorBuilder: (context, index) => Divider(),
                            )
                          : Center(
                              child: Text("No Group Available"),
                            );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _groupDetailsWidget(GroupDetails groupDetail) {
    // _checkIfJoined(groupDetail);
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: colorAccent,
          child: Text(groupDetail.groupName.substring(0, 2).toUpperCase())),
      title: Text(groupDetail.groupName),
      subtitle: Text(groupDetail.description),
      trailing: InkWell(
        onTap: () {
          _handleGroupJoining(groupDetails: groupDetail);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: colorPrimary,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(_alreadyMember ? 'Member' : 'Join',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  _handleGroupJoining({GroupDetails groupDetails}) async {
    showDialog(
        context: context,
        builder: (dialogContext) => ProgressDialog(
              status: "Joining Group",
            ));
    try {
      await GroupService().joinGroup(groupDetails: groupDetails);
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
                      groupId: groupDetails.groupId,
                      groupName: groupDetails.groupName,
                    ),
                  )));
    } catch (error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => CustomDialog(
                icon: FontAwesome.exclamation,
                title: "Error",
                description: "Unable to Join Group try again later",
                cancelButtonText: "Ok",
                okayPress: () {
                  Navigator.pop(dialogContext);
                },
              ));
      print(error);
    }
  }
}
