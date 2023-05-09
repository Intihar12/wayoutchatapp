import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:wayoutchatapp/screens/splash_screen.dart';

late Size mq;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 1,
            titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19)),
      ),
      home: const SplashScreen(),
    );
  }
}
