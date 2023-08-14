import 'package:factory_reset/imports.dart';
import 'package:factory_reset/provider/root_provider.dart';
import 'package:factory_reset/views/license_code.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/historyitem.dart';
import 'provider/calculator_provider.dart';
import 'provider/user_provider.dart';
import 'views/add_pin_screen.dart';
import 'views/calculator.dart';
import 'views/history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryItemAdapter());
  await Hive.openBox<HistoryItem>('history');

  var prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatefulWidget {
  SharedPreferences prefs;
  MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.prefs.getBool("isLogin") == true) {
      setState(() {
        isLogedIn = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CalculatorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RootProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calculator App',
        theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: AppBarTheme(
            color: backgroundColor,
            elevation: 0.0,
          ),
          textTheme: TextTheme(
            headline3: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            caption: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              fontSize: 18.0,
            ),
          ),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: yellowColor),
        ),
        initialRoute: (isLogedIn) ? "/calculator" : "/addPasscode",
        routes: {
          '/calculator': (context) => Calculator(),
          '/history': (context) => History(),
          '/addPasscode': (context) => AddPinScreen(),
          '/licenceCode': (context) => LicenceCodeScreen(),
        },
      ),
    );
  }
}
