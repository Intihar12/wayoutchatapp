import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:wayoutchatapp/provider/provider.dart';
import 'package:wayoutchatapp/screens/notification_services.dart';

import 'package:wayoutchatapp/screens/splash_screen.dart';
import 'package:wayoutchatapp/voice_chat/voice_chat.dart';

import 'barrel.dart';

late Size mq;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  NotificationServices.handleMessage(message);
  print('onBackgroundMessage received: $message');
}

Future<void> main() async {
  await GetStorage.init();
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
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
        child: Builder(builder: (context) {
          final themeChanger = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'Flutter Demo',
            builder: BotToastInit(),
            debugShowCheckedModeBanner: false,
            themeMode: themeChanger.themeMode,
            darkTheme: ThemeData(brightness: Brightness.dark),
            theme: ThemeData(
              brightness: Brightness.light,
              appBarTheme: AppBarTheme(
                  centerTitle: true,
                  iconTheme: IconThemeData(color: Colors.black),
                  backgroundColor: Colors.white,
                  elevation: 1,
                  titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19)),
            ),
            home: const SplashScreen(),
          );
        }));
  }
}
