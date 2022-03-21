import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  final String id;
  final String name;
  final String mobileNo;

  ContactModel({this.id, this.name, this.mobileNo});

  factory ContactModel.fromDataSnapshot(DocumentSnapshot doc) {
    Map data = doc.data();
    return ContactModel(
        id: doc.id, name: data['name'], mobileNo: data['mobile_number']);
  }
}
