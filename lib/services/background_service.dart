// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:factory_reset/controller/method_channel_controller.dart';
import 'package:factory_reset/firebase_options.dart';
import 'package:factory_reset/widget/custom_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundService {
  static final service = FlutterBackgroundService();
  static Future<void> initializeService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStartOnBoot: true,
        isForegroundMode: true,
        initialNotificationTitle: "Flutter Background Service",
        initialNotificationContent: "Configuring service...",
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        onBackground: (_) async {
          return true;
        },
      ),
    );
    await service.startService();
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  var db = FirebaseFirestore.instance;
  final methodChannel = CustomMethodChannelController();

  final docRef = db.collection("devices").doc(androidInfo.id);
  docRef.snapshots().listen(
    (event) async {
      // print("current data: ${event.data()}");
      print("IsReset: ${event.data()!["isReset"]}");
      if (event.data()!["isReset"]) {
        print(event.data());
        customWidgets.showToast("Background is working");
        // await methodChannel.invokeMethod(AndroidMethodsMain.reset);
        print("device reseted in background...");
      }
    },
    onError: (error) => log("Listen failed: $error"),
  );
}
