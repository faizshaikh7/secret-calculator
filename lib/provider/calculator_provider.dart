import 'dart:developer';

import 'package:calculator/provider/user_provider.dart';
import 'package:calculator/screens/add_url_screen.dart';
import 'package:calculator/screens/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator/model/historyitem.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:calculator/imports.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorProvider with ChangeNotifier {
  String equation = '';
  String result = '';

  // getPasscode(context, UserProvider userProv) async {
  //   var prefs = await SharedPreferences.getInstance();
  //   var prefCode = prefs.getString("passCode");
  //   log(prefCode!);
  //   userProv.passCode = prefCode;
  // }

  void addToEquation(String sign, bool canFirst, BuildContext context) async {
    if (equation == '') {
      if (sign == '.') {
        equation = '0.';
      } else if (canFirst) {
        equation = sign;
      }
    } else {
      if (sign == "AC") {
        equation = '';
        result = '';
      } else if (sign == "⌫") {
        if (equation.endsWith(' ')) {
          equation = '${equation.substring(0, equation.length - 3)}';
        } else {
          equation = '${equation.substring(0, equation.length - 1)}';
        }
      } else if (equation.endsWith('.') && sign == '.') {
        return;
      } else if (equation.endsWith(' ') && sign == '.') {
        equation = equation + '0.';
      } else if (equation.endsWith(' ') && canFirst == false) {
        equation = '${equation.substring(0, equation.length - 3) + sign}';
      } else if (sign == '=') {
        log("this is equation: $equation");
        var userProv = Provider.of<UserProvider>(context, listen: false);
        log("this is result: $result");
        final historyItem = HistoryItem()
          ..title = result
          ..subtitle = equation;
        Hive.box<HistoryItem>('history').add(historyItem);
        showToast(context, 'Saved');

        // getPasscode(context, userProv);
        var prefs = await SharedPreferences.getInstance();
        var prefCode = prefs.getString("passCode");
        log(prefCode!);
        userProv.passCode = prefCode;

        if (userProv.passCode == result || userProv.passCode == equation) {
          if (prefs.getBool("isUrlAdded") == true) {
            log("web view screen");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewScreen(),
              ),
            );
          } else {
            log("url Screen");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddUrlScreen(),
              ),
            );
          }
        }
      } else {
        equation = equation + sign;
      }
    }
    if (equation == '0') {
      equation = '';
    }
    try {
      var privateResult = equation.replaceAll('÷', '/').replaceAll('×', '*');
      Parser p = Parser();
      Expression exp = p.parse(privateResult);
      ContextModel cm = ContextModel();
      result = '${exp.evaluate(EvaluationType.REAL, cm)}';
      if (result.endsWith('.0')) {
        result = result.substring(0, result.length - 2);
      }
    } catch (e) {
      result = '';
    }
    notifyListeners();
  }
}
