import 'package:factory_reset/controller/method_channel_controller.dart';
import 'package:factory_reset/imports.dart';
import 'package:factory_reset/views/calculator.dart';
import 'package:flutter/material.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  double _maxRetries = 0.0;
  bool _isDeviceSecured = true;
  bool isEnable = false;

  final _methodChannel = CustomMethodChannelController();

  @override
  void initState() {
    super.initState();
    fetchMaxPasswordRetries();
    fetchDeviceStatus();
  }

  void fetchDeviceStatus() async {
    final deviceStatus =
        await _methodChannel.invokeMethod(AndroidMethodsMain.isDeviceSecured);

    debugPrint("Device Security Status: $deviceStatus");

    if (mounted && deviceStatus != null && deviceStatus is bool) {
      setState(() => _isDeviceSecured = deviceStatus);
    }
  }

  void fetchMaxPasswordRetries() async {
    final currentMaxReties = await _methodChannel
        .invokeMethod(AndroidMethodsMain.getMaxPasswordRetries);

    debugPrint("Current Max Retries: $currentMaxReties");
    final parsedValue = double.tryParse(currentMaxReties.toString());
    if (mounted && parsedValue != null && parsedValue > 0.0) {
      setState(() => _maxRetries = parsedValue);
    }
  }

  void setMaxPasswordRetries() async {
    setState(() {
      isEnable = !isEnable;
    });

    if (isEnable) {
      final success = await _methodChannel.invokeMethod(
          AndroidMethodsMain.setMaxPasswordRetries,
          args: {'maxRetries': _maxRetries.toInt()});
      if (success ?? false) {
        debugPrint("Max Password Retries has been set: $_maxRetries ");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("System Settings"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              if (!_isDeviceSecured)
                const MaterialBanner(
                  backgroundColor: yellowColor,
                  content: Text(
                    "Your device is not protected by a screen lock.",
                    style: TextStyle(),
                  ),
                  actions: [
                    Icon(
                      Icons.warning,
                      size: 32.0,
                      color: Colors.red,
                    )
                  ],
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // ElevatedButton.icon(
                    //   style:
                    //       ElevatedButton.styleFrom(backgroundColor: yellowColor),
                    //   onPressed: () async {
                    //     final success = await _methodChannel
                    //         .invokeMethod(AndroidMethodsMain.enablePermission);
                    //     debugPrint("Admin Permission Status: $success");
                    //   },
                    //   icon: const Icon(Icons.lock_reset, color: backgroundColor),
                    //   label: const Text(
                    //     "Enable Permission",
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    // ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                "Unlock Attempts",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Slider(
                                          inactiveColor: Colors.white12,
                                          activeColor: yellowColor,
                                          value: _maxRetries,
                                          min: 0,
                                          max: 10,
                                          divisions: 10,
                                          onChanged: (val) => setState(() =>
                                              _maxRetries = val.round() * 1.0),
                                        ),
                                      ),
                                      Text(
                                        "$_maxRetries",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: yellowColor,
                                    minimumSize: Size(
                                      200,
                                      40,
                                    ),
                                  ),
                                  onPressed: setMaxPasswordRetries,
                                  icon: const Icon(Icons.restore_page,
                                      color: backgroundColor),
                                  label: (isEnable)
                                      ? Text(
                                          "Disable",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      : Text(
                                          "Enable",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: yellowColor),
                      onPressed: () async {
                        await _methodChannel
                            .invokeMethod(AndroidMethodsMain.reset);
                      },
                      icon:
                          const Icon(Icons.lock_reset, color: backgroundColor),
                      label: const Text(
                        "Factory Reset Now",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
