import 'package:cloud_firestore/cloud_firestore.dart';

class GroupDetails {
  final String admin;
  final String groupName;
  final String description;
  final String dateCreated;
  final List<String> members;
  final String groupId;

  GroupDetails(
      {this.admin,
      this.description,
      this.dateCreated,
      this.members,
      this.groupName,
      this.groupId});

  factory GroupDetails.fromDataSnapshot(DocumentSnapshot doc) {
    Map data = doc.data();
    return GroupDetails(
        groupId: doc.id,
        admin: data['admin'],
        dateCreated: data['timestamp'],
        groupName: data['groupName'],
        description: data['description'],
        members: List<String>.from(data['members'])
            .map((memberId) => memberId)
            .toList());
  }
}
