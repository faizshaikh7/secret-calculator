import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? webUrl;
  String? passCode;

  updateUrl(String url) async {
    webUrl = url;
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("webUrl", webUrl!);
    prefs.setBool("isUrlAdded", true);
    // prefs.setBool("isLogin", true);

    notifyListeners();
  }

  updatePasscode(String userPassCode) async {
    passCode = userPassCode;
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("passCode", passCode!);
    prefs.setBool("isLogin", true);

    notifyListeners();
  }
}
