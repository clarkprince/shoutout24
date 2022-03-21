import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/model/messageMode.dart';
import 'package:shoutout24/model/userLocationModel.dart';
import 'package:shoutout24/model/userModel.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static storeUser(
      {String email,
      String name,
      String mobileNo,
      @required String uid}) async {
    CollectionReference users = _db.collection("users");
    return users.doc(uid).set({
      "email": email,
      "name": name,
      "mobile_number": mobileNo,
      "groups": [],
      "timestamp": new DateTime.now().toString()
    });
  }

  Stream<UserModel> getUserDetails() {
    return _db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) =>
            UserModel.fromDataSnapshot(documentSnapshot));
  }

  Future<void> updateUserDetail({UserModel userModel}) async {
    return _db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      "name": userModel.name,
      "email": userModel.email,
      "mobile_number": userModel.mobileNo,
      "address": userModel.address,
    });
  }

  Future<DocumentReference> createContact({ContactModel contactModel}) async {
    return _db
        .collection("contacts")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userContacts")
        .add({
      "name": contactModel.name,
      "mobile_number": contactModel.mobileNo,
      "timestamp": new DateTime.now()
    });
  }

  Stream<List<ContactModel>> getUserContact() {
    return _db
        .collection("contacts")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userContacts")
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot doc) => ContactModel.fromDataSnapshot(doc))
            .toList());
  }

  Future<void> updateContact(
      {ContactModel contactModel, String contactId}) async {
    return _db
        .collection("contacts")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userContacts")
        .doc(contactId)
        .update({
      "name": contactModel.name,
      "mobile_number": contactModel.mobileNo,
      "timestamp": new DateTime.now()
    });
  }

  Future<void> deleteContacts(String contactId) {
    return _db
        .collection("contacts")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userContacts")
        .doc(contactId)
        .delete();
  }

  Future<DocumentReference> sendMessage(
      {String message, List<ContactModel> contacts}) async {
    print(contacts);
    return _db
        .collection("messages")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userMessages")
        .add({
      "message": message,
      "timestamp": new DateTime.now().toString(),
      "recipients":
          contacts.map((e) => {"number": e.mobileNo, "name": e.name}).toList()
    });
  }

  Future<DocumentReference> logUserLocation(
      {UserLocationModel userLocationModel, UserModel userModel}) async {
    print("log location called");
    // check if live location exist
    DocumentSnapshot liveLocationRef = await _db
        .collection('liveLocation')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (!liveLocationRef.exists) {
      liveLocationRef.reference.set({
        "userName": userModel.name,
        "userMobile": userModel.mobileNo,
        "timestamp": userLocationModel.time,
        "location": FieldValue.arrayUnion([
          {
            "latitude": userLocationModel.latitude,
            "longitude": userLocationModel.longitude,
            "time": new DateTime.now().toString()
          }
        ])
      });
    } else {
      // if user already exists in live location update his/her location
      await liveLocationRef.reference.update({
        "location": FieldValue.arrayUnion([
          {
            "latitude": userLocationModel.latitude,
            "longitude": userLocationModel.longitude,
            "time": new DateTime.now().toString()
          }
        ])
      });
    }

    DocumentSnapshot _doc = await _db
        .collection("locationLogs")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (_doc.exists) {
      print("${_doc.reference}  exists");
      await _doc.reference.delete();

      return _doc.reference.collection("userLocation").add({
        "latitude": userLocationModel.latitude,
        "longitude": userLocationModel.longitude,
        "time": userLocationModel.time
      });
    } else {
      print("${_doc.reference} doesn't exists");
      await _doc.reference.delete();
      return _doc.reference.collection("userLocation").add({
        "latitude": userLocationModel.latitude,
        "longitude": userLocationModel.longitude,
        "time": userLocationModel.time
      });
    }
  }

  Future<void> stopLiveLocation() async {
    return await _db
        .collection('liveLocation')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .delete();
  }

  Stream<List<MessageModel>> getUserMessages() {
    return _db
        .collection("messages")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userMessages")
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot doc) => MessageModel.fromDataSnapshot(doc))
            .toList());
  }
}
