import 'dart:developer';
import 'package:factory_reset/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../imports.dart';
import 'webview_screen.dart';

class AddUrlScreen extends StatefulWidget {
  const AddUrlScreen({super.key});

  @override
  State<AddUrlScreen> createState() => _AddUrlScreenState();
}

class _AddUrlScreenState extends State<AddUrlScreen> {
  final TextEditingController urlController = TextEditingController();

  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: yellowColor, width: 2.0),
  );

  @override
  Widget build(BuildContext context) {
    var userProv = Provider.of<UserProvider>(context);
    return Scaffold(
        body: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Add URL to Continue",
            style: TextStyle(
              fontSize: 17,
              color: yellowColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: urlController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Web URL",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: "https://www.example.com/",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: inputBorder,
              focusedBorder: inputBorder,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade900,
                // backgroundColor: Color.fromARGB(255, 8, 29, 90),
                minimumSize: const Size(double.infinity, 50)),
            onPressed: () {
              log(urlController.text);
              userProv.updateUrl(urlController.text);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewScreen(),
                  ));
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    ));
  }
}
