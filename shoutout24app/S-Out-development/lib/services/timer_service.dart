import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/model/userLocationModel.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/services/location_service.dart';
import 'package:shoutout24/services/send_message.dart';
import 'package:shoutout24/utils/constants.dart';

class CustomTimerService extends ChangeNotifier {
  bool isSharing = false;
  Timer timer;

  handleSendingLocationDetails(
      {UserModel user,
      List<ContactModel> contacts,
      bool emergency = true}) async {
    String message =
        "Shoutout24: ${user.name} has shared their location with you. You can track ${user.name} on $webUrl/${user.id}";
    String emergencyMessage =
        "Shoutout24: ${user.name} has an emergency and would like your assistance. You can track ${user.name} on $webUrl/${user.id}";
    UserLocationModel _userLocationModel =
        await LocationService().getCurrentLocation();
    try {
      SendMessageService.sendMessage(
          message: emergency ? emergencyMessage : message, contacts: contacts);
      await DatabaseService().sendMessage(
          message: emergency ? emergencyMessage : message, contacts: contacts);
      DatabaseService().logUserLocation(
          userLocationModel: _userLocationModel, userModel: user);
    } catch (error) {
      print(error);
    }

    timer = Timer.periodic(new Duration(seconds: 30), (Timer timer) async {
      DatabaseService().logUserLocation(
          userLocationModel: _userLocationModel, userModel: user);
      print("Ticker::" + timer.tick.toString());
    });
    isSharing = true;
    notifyListeners();
  }

  stopSharingLocation() {
    isSharing = false;
    DatabaseService().stopLiveLocation();
    timer.cancel();
    notifyListeners();
  }
}
