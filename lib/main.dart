import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wayoutchatapp/screens/notification_services.dart';

import 'package:wayoutchatapp/screens/splash_screen.dart';
import 'package:wayoutchatapp/voice_chat/voice_chat.dart';

late Size mq;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  NotificationServices.handleMessage(message);
  print('onBackgroundMessage received: $message');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
      debugShowCheckedModeBanner: false,
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
