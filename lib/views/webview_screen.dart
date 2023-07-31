// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:factory_reset/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  geturl() async {
    var prefs = await SharedPreferences.getInstance();
    var prefUrl = prefs.getString("webUrl");
    log(prefUrl!);
    setState(() {
      Provider.of<UserProvider>(context, listen: false).webUrl = prefUrl;
    });
  }

  requestPermission() async {
    final PermissionStatus picturesPermission =
        await Permission.photos.request();

    final PermissionStatus perPermission =
        await Permission.mediaLibrary.request();

    final PermissionStatus cameraPermission = await Permission.camera.request();
    if (cameraPermission != PermissionStatus.granted) {
      log("Permission Deny");
      throw ("Permission Denied");
    } else {
      log("contact permission granted");
    }

    final PermissionStatus microphonePermission =
        await Permission.microphone.request();
    if (microphonePermission != PermissionStatus.granted) {
      log("Permission Deny");
      throw ("Permission Denied");
    } else {
      log("permission granted");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    geturl();
    requestPermission();
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    final webUrl = Provider.of<UserProvider>(context).webUrl;

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: (webUrl != null)
            ? InAppWebView(
                onConsoleMessage: (controller, consoleMessage) {
                  log(consoleMessage.message);
                },
                initialUrlRequest: URLRequest(
                  url: Uri.parse(webUrl),
                ),
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      mediaPlaybackRequiresUserGesture: false,
                      // javaScriptEnabled: true,
                      // allowFileAccessFromFileURLs: true,
                      // debuggingEnabled: true,
                      // cacheEnabled: true,
                    ),
                    android: AndroidInAppWebViewOptions(
                        thirdPartyCookiesEnabled: true)),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                androidOnPermissionRequest: (InAppWebViewController controller,
                    String origin, List<String> resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    var iProgress = progress / 100;
                    log(iProgress.toString());
                  });
                },
              )
            : const CircularProgressIndicator(),
      ),
    ));
  }
}
