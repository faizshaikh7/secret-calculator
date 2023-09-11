import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final CustomWidgets customWidgets = CustomWidgets();

class CustomWidgets {
  showToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      webShowClose: true,
      webPosition: 'centre',
      webBgColor: "#7e55bb",
      backgroundColor: Colors.white,
      textColor: Colors.white,
      fontSize: 16.0);
}
