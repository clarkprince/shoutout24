import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String groupName;
  final String id;
  final String description;

  Group({this.groupName, this.id, this.description});

  factory Group.fromDataSnapshot(DocumentSnapshot doc) {
    Map data = doc.data();
    return Group(
        id: doc.id,
        groupName: data['groupName'],
        description: data['description']);
  }
}
