import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/common/customdialog.dart';
import 'package:shoutout24/common/main_app_bar.dart';
import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/view/tabpages/addcontact.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class ContactsTab extends StatelessWidget {
  _optionSelection(BuildContext parentContext, {ContactModel contactModel}) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Options"),
          children: [
            SimpleDialogOption(
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: colorAccent,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Edit")
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddContact(
                              contactModel: contactModel,
                            )));
              },
            ),
            Divider(),
            SimpleDialogOption(
              child: Row(
                children: [
                  Icon(
                    Icons.delete_forever,
                    color: colorAccent,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Delete")
                ],
              ),
              onPressed: () async {
                Navigator.pop(context);
                await DatabaseService().deleteContacts(contactModel.id);
              },
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Center(
              child: SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ContactModel> _contacts = Provider.of<List<ContactModel>>(context);
    return SafeArea(
      child: Scaffold(
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            child: Column(
              children: [
                customAppBar(
                    title: "Contacts",
                    centered: true,
                    showLogout: true,
                    context: context,
                    showHomeMenu: true),
                VerticalSpacing(),
                Expanded(
                    child: _contacts.length > 0
                        ? ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) => ListTile(
                                  leading: CircleAvatar(
                                      backgroundColor: colorAccent,
                                      child: Text(_contacts[index]
                                          .name
                                          .substring(0, 2))),
                                  title: Text(_contacts[index].name),
                                  subtitle: Text(_contacts[index].mobileNo),
                                  trailing: IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {
                                      _optionSelection(context,
                                          contactModel: _contacts[index]);
                                    },
                                  ),
                                ),
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: _contacts.length)
                        : Center(child: Text("You haven't created  contact")))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddContact()));
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
            ),
          )),
    );
  }
}
