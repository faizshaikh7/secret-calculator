import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class RootProvider extends ChangeNotifier {
  String deviceMake = "";
  String deviceModel = "";
  String deviceStatus = "Active";
  bool isReset = false;
  String deviceLicenceCode = "";
  String networkStatus = "";
  String deviceId = "";

  Future<bool> checkLicenceCode() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("licenceCode", isEqualTo: deviceLicenceCode)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      log("licence code exist");
      return true;
    } else {
      log("licence code not exist");
      return false;
    }
  }

  Future<bool> addDeviceData(context) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      deviceId = androidInfo.id;
      networkStatus = await checkNetworkStatus();
      if (networkStatus == "Poor") {
        deviceStatus = "Inactive";
      }
      deviceMake = androidInfo.manufacturer;
      deviceModel = androidInfo.model;
      // add isreset too
      // add licence code too

      FirebaseFirestore.instance
          .collection('devices')
          .doc(deviceId)
          .set({
            "deviceMake": deviceMake,
            "deviceModel": deviceModel,
            "deviceStatus": deviceStatus,
            "isReset": isReset,
            "licenceCode": deviceLicenceCode,
            "networkStatus": networkStatus,
            "deviceId": deviceId,
          })
          .then((value) => print("Device Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<String> checkNetworkStatus() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        return 'Good';
      case ConnectivityResult.mobile:
        return 'Moderate';
      case ConnectivityResult.none:
        return 'Poor';
      default:
        return 'Poor';
    }
  }

  Future<void> updateDeviceData(
      context, ConnectivityResult iNetworkStatus) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      switch (iNetworkStatus) {
        case ConnectivityResult.wifi:
          networkStatus = "Good";
          log("Good");
          break;
        case ConnectivityResult.mobile:
          networkStatus = "Moderate";
          log("Moderate");
          break;

        case ConnectivityResult.none:
          networkStatus = "Poor";
          log("Poor");
          break;

        default:
          networkStatus = "Poor";
          log("Poorr");
          break;
      }

      log(networkStatus);
      var deviceUid = androidInfo.id;

      if (networkStatus == "Poor") {
        deviceStatus = "Inactive";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No Internet Connection"),
          ),
        );
      } else {
        deviceStatus = "Active";
        var updateData = await FirebaseFirestore.instance
            .collection('devices')
            .doc(deviceUid)
            .update({
              'deviceStatus': deviceStatus,
              'networkStatus': networkStatus,
            })
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      }

      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
