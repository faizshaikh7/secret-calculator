// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:factory_reset/provider/root_provider.dart';
import 'package:factory_reset/views/calculator.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../imports.dart';

class LicenceCodeScreen extends StatefulWidget {
  const LicenceCodeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LicenceCodeScreenState createState() => _LicenceCodeScreenState();
}

class _LicenceCodeScreenState extends State<LicenceCodeScreen> {
  final TextEditingController _licenceController = TextEditingController();
  final _pinShadow = const BoxShadow(color: Colors.white);

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   var prov = Provider.of<RootProvider>(context, listen: false);
  //   super.initState();
  //   // prov.getDeviceInfo();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Enter Licence Number",
            style: TextStyle(
              fontSize: 17,
              color: yellowColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
            ),
            child: PinCodeTextField(
              controller: _licenceController,
              pinTheme: PinTheme.defaults(
                fieldHeight: 45,
                fieldWidth: 45,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                inactiveColor: Colors.white,
                activeColor: Colors.white,
                selectedColor: Colors.white,
              ),
              boxShadows: [
                _pinShadow,
                _pinShadow,
                _pinShadow,
                _pinShadow,
              ],
              length: 4,
              keyboardType: TextInputType.number,
              appContext: context,
              onSubmitted: (_) {},
              onCompleted: (_) {},
              onChanged: (_) {},
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
            onPressed: () async {
              // var deviceInfo = getDeviceInfo();
              log(_licenceController.text);
              var prov = Provider.of<RootProvider>(context, listen: false);
              prov.deviceLicenceCode = _licenceController.text;
              var res = await prov.checkLicenceCode();
              prov.addDeviceData(context);

              // get device data here

              if (res) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Calculator(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("licence code not exist"),
                  ),
                );
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    ));
  }
}
