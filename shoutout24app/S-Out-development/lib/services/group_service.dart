import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoutout24/model/chat_message_model.dart';
import 'package:shoutout24/model/groupModel.dart';
import 'package:shoutout24/model/group_details_model.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/view/tabpages/groupList.dart';

class GroupService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<String> createGroup({Group group, UserModel userModel}) async {
    DocumentReference groupRef = await _db.collection('groups').add({
      "groupName": group.groupName,
      "description": group.description,
      "timestamp": DateTime.now().toString(),
      "members": [],
      "groupId": '',
      "admin": userModel.name,
      "recentMessage": '',
      "recentMessageSender": ''
    });

    // update members list
    await groupRef.update({
      "members": FieldValue.arrayUnion([userModel.id]),
      "groupId": groupRef.id
    });
    // add groupId to user document
    await _db.collection("users").doc(userModel.id).update({
      "groups": FieldValue.arrayUnion([
        {
          "id": groupRef.id,
          "name": group.groupName,
          "description": group.description,
        }
      ])
    });
    return groupRef.id;
  }

  // gets user groups
  getUserGroups() async {
    return _db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots();
  }

// sends message to group and update the recent message
  sendMessage({String groupId, ChatMessageModel chatMessageModel}) async {
    await _db.collection('groups').doc(groupId).collection('messages').add({
      "message": chatMessageModel.message,
      "sender": chatMessageModel.sender,
      "time": chatMessageModel.time
    });

    await _db.collection('groups').doc(groupId).update({
      'recentMessage': chatMessageModel.message,
      'recentMessageSender': chatMessageModel.sender,
      'recentMessageTime': chatMessageModel.time
    });
  }

  // gets group chats
  Stream<QuerySnapshot> getGroupChats({String groupId}) {
    return _db
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  //search group
  Future<QuerySnapshot> searchGroupByName({String groupName}) async {
    return _db
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .get();
  }

  // get all groups
  Stream<List<GroupDetails>> getAllGroups() {
    return _db.collection("groups").snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot doc) => GroupDetails.fromDataSnapshot(doc))
            .where((GroupDetails details) => details.members
                .where((e) => e == FirebaseAuth.instance.currentUser.uid)
                .isEmpty)
            .toList());
  }

  joinGroup({GroupDetails groupDetails}) async {
    DocumentReference groupRef =
        _db.collection('groups').doc(groupDetails.groupId);
    // update members list
    await groupRef.update({
      "members": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid]),
      "groupId": groupRef.id
    });
    // add groupId to user document
    return await _db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      "groups": FieldValue.arrayUnion([
        {
          "id": groupRef.id,
          "name": groupDetails.groupName,
          "description": groupDetails.description,
        }
      ])
    });
  }

  // toggling the user group join
  Future togglingGroupJoin({GroupDetails groupDetails}) async {
    DocumentReference userDocRef =
        _db.collection("users").doc(FirebaseAuth.instance.currentUser.uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    // DocumentReference groupDocRef = groupCollection.document(groupId);

    DocumentReference groupDocRef =
        _db.collection("groups").doc(groupDetails.groupId);

    List<Group> groups =
        List<Group>.from(userDocSnapshot['groups'].map((group) {
      return Group(
          groupName: group['name'],
          description: group['description'],
          id: group['id']);
    })).toList();

    if (groups.contains(groupDetails.groupId)) {
      print('already exixts removing');
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([
          {
            {
              "id": groupDetails.groupId,
              "name": groupDetails.groupName,
              "description": groupDetails.description,
            }
          }
        ])
      });

      await groupDocRef.update({
        'members':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser.uid])
      });
    } else {
      print('does not exist join');
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([
          {
            {
              "id": groupDetails.groupId,
              "name": groupDetails.groupName,
              "description": groupDetails.description,
            }
          }
        ])
      });

      await groupDocRef.update({
        "members":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid]),
        "groupId": groupDetails.groupId
      });
    }
  }

  // has user joined the group
  Future<bool> isUserJoined({GroupDetails groupDetails}) async {
    DocumentReference userDocRef =
        _db.collection("users").doc(FirebaseAuth.instance.currentUser.uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<Group> groups =
        List<Group>.from(userDocSnapshot['groups'].map((group) {
      return Group(
          groupName: group['name'],
          description: group['description'],
          id: group['id']);
    })).toList();
    var groupExists = groups.firstWhere(
        (group) => group.id == groupDetails.groupId,
        orElse: () => null);

    print('Here ${groupExists?.groupName}');

    if (groupExists != null) {
      print('already member');
      return true;
    } else {
      print('Not member');

      return false;
    }
  }
}
