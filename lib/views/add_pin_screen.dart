import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../imports.dart';
import '../provider/user_provider.dart';
import 'calculator.dart';

class AddPinScreen extends StatefulWidget {
  const AddPinScreen({super.key});

  @override
  State<AddPinScreen> createState() => _AddPinScreenState();
}

class _AddPinScreenState extends State<AddPinScreen> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

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
            "Add 4 Digit Passcode",
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
            style: TextStyle(color: Colors.white),
            controller: pinController,
            decoration: InputDecoration(
              labelText: "Passcode",
              labelStyle: TextStyle(color: Colors.grey),
              border: inputBorder,
              focusedBorder: inputBorder,
              counterText: '',
            ),
            maxLength: 4,
            cursorColor: yellowColor,
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            style: TextStyle(color: Colors.white),
            controller: confirmPinController,
            decoration: InputDecoration(
              labelText: "Confirm Passcode",
              labelStyle: TextStyle(color: Colors.grey),
              border: inputBorder,
              focusedBorder: inputBorder,
              counterText: '',
            ),
            maxLength: 4,
            cursorColor: yellowColor,
            keyboardType: TextInputType.number,
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
              if (pinController.text == confirmPinController.text) {
                userProv.updatePasscode(pinController.text);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Calculator(),
                    ));
              } else {
                showToast(context, 'Passcode Mismatched');
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    ));
  }
}
