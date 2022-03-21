import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String message;
  final String sender;
  final String time;
  final String id;

  ChatMessageModel({this.id, this.message, this.sender, this.time});

  factory ChatMessageModel.fromDataSnapshot(DocumentSnapshot doc) {
    Map data = doc.data();
    return ChatMessageModel(
        id: doc.id,
        message: data['message'],
        sender: data['sender'],
        time: data['time']);
  }
}
