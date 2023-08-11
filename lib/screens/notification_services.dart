import 'package:wayoutchatapp/barrel.dart';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting =
        InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      handleMessage(message);
    });
  }

  void firebaseInit(BuildContext context) {
    print("listen");
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      print("android!.channelId.toString()");

      print(android!.channelId.toString());
      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");

        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        print("showNotification klkl");
        initLocalNotifications(context, message);
        showNotification(message);
        print("showNotification");
      }
    });
    print("litrmmmm");
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(), message.notification!.android!.channelId.toString(),
        importance: Importance.max,
        showBadge: true,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'));
    print("message.notification!.android!.channelId.toString()");
    print(channel);
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(), channel.name.toString(),
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        ticker: 'ticker',
        sound: channel.sound
        //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
        //  icon: largeIconPath

        );
    print(" channel.id.toString()");
    print(channel.id.toString());

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        int.parse(channel.id.toString()),
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);
    });
  }

  static handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'msj') {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => MessageScreen(
      //       id: message.data['id'] ,
      //     )
      //     ));
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // todo shedule notifications

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initialize notification
  initializeNotification() async {
    //_configureLocalTimeZone();
    //const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("ic_launcher");

    const InitializationSettings initializationSettings = InitializationSettings(
      //iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Set right date and time for notifications

  tz.TZDateTime _convertTime(
      {required int hour, required int minutes, required int month, required int year, required int day}) {
    tz.initializeTimeZones();

    final now = tz.TZDateTime.now(locations);
    //final now = tz.TZDateTime.now(locations);
    final formattedDateTime = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    final formattedDateTimeWithOffset = formattedDateTime.replaceFirst('Z', '+0500');

    final formattedTime = tz.TZDateTime.parse(locations, formattedDateTimeWithOffset);
    // final dateTime = DateTime.parse(formattedTime);
    DateTime date = DateTime.now();
    print("TZDateTime now");
    print(now);
    print("formattedTime");
    print(formattedTime);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      locations,
      year,
      month,
      day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(formattedTime)) {
      scheduleDate = scheduleDate.add(const Duration(
        minutes: 2,
      ));

      print("scheduleDate");
      print(scheduleDate);
    } else {
      print("else sheduel time");
      print(scheduleDate);
    }

    return scheduleDate;
  }

  // configureLocalTimeZone() async {
  //   tz.initializeTimeZones();
  //   DateTime dateTime = DateTime.now();
  //   print("date olp" + dateTime.timeZoneName);
  //   print("date olp" + dateTime.timeZoneOffset.toString());
  //   final timeZone = await FlutterNativeTimezone.getLocalTimezone();
  //   final ali = tz.setLocalLocation(tz.getLocation(timeZone));
  //   //tz.TZDateTime now = tz.TZDateTime.now(ali);
  //   print("timecccccc");
  //   print(timeZone);
  //
  //   return timeZone;
  //   // tz.setLocalLocation(tz.getLocation(timeZone));
  // }

  // Future getCurrentTimeZone() async {
  //   tz.initializeTimeZones();
  //   final timeZone = await FlutterNativeTimezone.getLocalTimezone();
  //   final location = tz.getLocation(timeZone);
  //
  //   //final now = tz.TZDateTime.now(location);
  //   //  final intuu = now.timeZoneOffset.toString();
  //
  //   return location;
  // }

  /// Scheduled Notification
  scheduledNotification(
      {required int hour,
      required int minutes,
      required int id,
      required int month,
      required String title,
      required String description,
      required int year,
      required int day
      // required String sound,
      }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      description,
      _convertTime(hour: hour, minutes: minutes, month: month, year: year, day: day),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id ',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          // sound: RawResourceAndroidNotificationSound(),
        ),
        //iOS: IOSNotificationDetails(sound: '$sound.mp3'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'It could be anything you pass',
    );
  }

  /// Request IOS permissions
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  var locations;

  // void sheduleFunction(List<NotificationServiceModal> list) async {
  //   final location = await getCurrentTimeZone();
  //   locations = location;
  //   for (int i = 0; i < list.length; i++) {
  //     String text = list[i].time!;
  //
  //     List<String> substrings = text.split(RegExp(r':'));
  //
  //     int hour = int.parse(substrings[0]);
  //     int mints = int.parse(substrings[1]);
  //     int month = int.parse(DateFormat('M').format(list[i].date!));
  //     // int mon = int.parse(month);
  //
  //     int date = int.parse(DateFormat('dd').format(list[i].date!));
  //     int year = int.parse(DateFormat('yyyy').format(list[i].date!));
  //
  //     scheduledNotification(
  //         hour: hour,
  //         minutes: mints,
  //         id: list[i].id,
  //         // sound: 'sound0',
  //         month: month,
  //         title: list[i].title.toString(),
  //         description: list[i].description.toString(),
  //         day: date,
  //         year: year);
  //   }
  // }

  cancelAll() async => await flutterLocalNotificationsPlugin.cancelAll();

  cancel(id) async => await flutterLocalNotificationsPlugin.cancel(id);
}

// List<Country> countryFromJson(String str) => List<Country>.from(json.decode(str).map((x) => Country.fromJson(x)));
//
// String countryToJson(List<Country> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Country {
  int? hours;
  int? mints;
  int? id;
  int? month;

  Country({this.hours, this.mints, this.id, this.month});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        hours: json["hours"],
        mints: json["mints"],
        id: json["id"],
        month: json["month"],
      );

  Map<String, dynamic> toJson() => {
        "hours": hours,
        "mints": mints,
        "id": id,
        "month": month,
      };
}

// todo she
// @override
// void initState() {
//   // TODO: implement initState
//   super.initState();
//   notificationServices.requestNotificationPermission();
//   notificationServices.forgroundMessage();
//   notificationServices.firebaseInit(context);
//   notificationServices.setupInteractMessage(context);
//   notificationServices.isTokenRefresh();
//
//   notificationServices.getDeviceToken().then((value){
//     if (kDebugMode) {
//       print('device token');
//       print(value);
//     }
//   });
// }

// todo

// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService {
//   //instance of FlutterLocalNotificationsPlugin
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//     //Initialization Settings for Android
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     //Initialization Settings for iOS
//     // const IOSInitializationSettings initializationSettingsIOS =
//     // IOSInitializationSettings(
//     //   requestSoundPermission: false,
//     //   requestBadgePermission: false,
//     //   requestAlertPermission: false,
//     // );
//
//     //Initializing settings for both platforms (Android & iOS)
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       // iOS: initializationSettingsIOS
//     );
//
//     tz.initializeTimeZones();
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (payload) {
//       // handle interaction when app is active for android
//       // handleMessage(context, message);
//     });
//   }
//
//   onSelectNotification(String? payload) async {
//     //Navigate to wherever you want
//   }
//
//   requestIOSPermissions() {
//     flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   Future<void> showNotifications({id, title, body, payload}) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('your channel id', 'your channel name',
//         channelDescription: 'your channel description', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics, payload: payload);
//   }
//
//   Future<void> scheduleNotifications({id, title, body, time}) async {
//     try {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//           id,
//           title,
//           body,
//           tz.TZDateTime.from(time, tz.local),
//           const NotificationDetails(
//               android: AndroidNotificationDetails('your channel id', 'your channel name', channelDescription: 'your channel description')),
//           androidAllowWhileIdle: true,
//           uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
//     } catch (e) {
//       print(e);
//     }
//   }
// }
