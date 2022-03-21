import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoutout24/model/groupModel.dart';

class UserModel {
  final String id;
  final String name;
  final String mobileNo;
  final String email;
  final String address;
  final List<Group> group;

  UserModel(
      {this.id,
      this.name,
      this.mobileNo,
      this.email,
      this.address,
      this.group});

  factory UserModel.fromDataSnapshot(DocumentSnapshot doc) {
    Map data = doc.data();
    return UserModel(
        id: doc.id,
        name: data['name'],
        mobileNo: data['mobile_number'],
        email: data['email'],
        group: List<Group>.from(data['groups'].map((item) {
          return Group(
              groupName: item['name'],
              description: item['description'],
              id: item['id']);
        })),
        address: data['address'] ?? null);
  }
}
