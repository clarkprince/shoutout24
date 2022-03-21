import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/model/chat_message_model.dart';
import 'package:shoutout24/model/groupModel.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/services/group_service.dart';
import 'package:shoutout24/view/group/widgets/message_body.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  ChatPage({Key key, @required this.groupId, this.groupName}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  UserModel _userModel;

  Widget _messageComposer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 70,
        width: double.infinity,
        color: Colors.grey,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _onMessageSend();
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 1),
          child: Column(
            children: [
              customAppBar(
                  showHomeMenu: false,
                  showLogout: false,
                  title: widget.groupName),
              VerticalSpacing(),
              Expanded(
                  child: Stack(
                children: [
                  _chatMessages(),
                  _messageComposer(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  void _onMessageSend() async {
    if (_messageController.text.isNotEmpty) {
      await GroupService().sendMessage(
          groupId: widget.groupId,
          chatMessageModel: ChatMessageModel(
            message: _messageController.text.trim(),
            sender: _userModel.name,
            time: DateTime.now().toString(),
          ));

      _messageController.text = "";
    }
  }

  Widget _chatMessages() {
    return StreamBuilder(
        stream: GroupService().getGroupChats(groupId: widget.groupId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null)
            return Center(child: CircularProgressIndicator());

          List<ChatMessageModel> _chatMessages = snapshot.data.docs
              .map((DocumentSnapshot doc) =>
                  ChatMessageModel.fromDataSnapshot(doc))
              .toList();

          return ListView.builder(
            itemCount: _chatMessages.length,
            itemBuilder: (context, index) {
              ChatMessageModel _chatMessage = _chatMessages[index];
              return MessageBody(
                message: _chatMessage.message,
                sender: _chatMessage.sender,
                sentByMe: _userModel.name == _chatMessage.sender,
                time: _chatMessage.time,
              );
            },
          );
        });
  }
}
