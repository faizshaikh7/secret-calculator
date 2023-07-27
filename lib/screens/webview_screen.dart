// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:calculator/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
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

    // final PermissionStatus cameraPermission = await Permission.camera.request();
    // if (cameraPermission != PermissionStatus.granted) {
    //   log("Permission Deny");
    //   throw ("Permission Denied");
    // } else {
    //   log("contact permission granted");
    // }

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
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        });
  }

  @override
  Widget build(BuildContext context) {
    var webUrl = Provider.of<UserProvider>(context).webUrl;

    // geturl();
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: (webUrl!.isNotEmpty)
            ? WebView(
                initialUrl: webUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onProgress: (int progress) {
                  print("WebView is loading (progress : $progress%)");
                },
                javascriptChannels: <JavascriptChannel>{
                  _toasterJavascriptChannel(context),
                },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    print('blocking navigation to $request}');
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                gestureNavigationEnabled: true,
                geolocationEnabled: false, //support geolocation or not
                allowsInlineMediaPlayback: true,
              )
            : const CircularProgressIndicator(),
      ),
    ));
  }
}
