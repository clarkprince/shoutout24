import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoutout24/model/contactModel.dart';

class MessageModel {
  String message;
  String id;
  List<ContactModel> recipients;
  dynamic timeStamp;

  MessageModel({this.id, this.message, this.recipients, this.timeStamp});

  Map<String, dynamic> toMap() =>
      {'message': message, 'recipients': recipients, 'timestamp': timeStamp};

  factory MessageModel.fromDataSnapshot(DocumentSnapshot doc) {
    Map data = doc.data();
    return MessageModel(
        id: doc.id,
        message: data['message'],
        timeStamp: data['timestamp'] ?? null);
  }
}
