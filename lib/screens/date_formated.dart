import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateUtils {
  static String getFormatTime(BuildContext context, DateTime? time) {
    // final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    String formattedTime = DateFormat('kk:mm:a').format(time!);
    //return TimeOfDay.fromDateTime(date).format(context);
    return formattedTime;
  }

  static String getMessageTime({required BuildContext context, required DateTime? lastTime}) {
    //final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(lastTime.toString()));
    final DateTime sent = lastTime!;
    final formatTime = TimeOfDay.fromDateTime(sent).format(context);
    final DateTime now = DateTime.now();
    if (now.day == sent.day && now.month == sent.month && now.year == sent.year) {
      return formatTime;
    }
    return now.year == sent.year
        ? " ${formatTime} -${sent.day} ${_getMonth(sent)} "
        : "${formatTime} -${sent.day} ${_getMonth(sent)}${sent.year}";
  }

  static String getLastMessageTime({required BuildContext context, required DateTime? lastTime, bool showYer = false}) {
    //final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(lastTime.toString()));
    final DateTime sent = lastTime!;

    final DateTime now = DateTime.now();
    if (now.day == sent.day && now.month == sent.month && now.year == sent.year) {
      return DateFormat('kk:mm:a').format(sent);
    }
    return showYer ? "${sent.day} ${_getMonth(sent)} ${sent.year}" : "${sent.day} ${_getMonth(sent)}";
  }

  static String getLastActiveTime({required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    if (i == -1) return "Last seen not avalable";

    //final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(lastTime.toString()));

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day && time.month == now.month && time.year == now.year) {
      return "Last seen today at ${formattedTime}";
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return "Last seen yesterday at ${formattedTime}";
    }
    String month = _getMonth(time);
    return "Last seen on ${time.day} ${month} on ${formattedTime}";
  }

  static String getLastActiveTimeDate({required BuildContext context, required DateTime? lastActive}) {
    print("lastActive time");
    print(lastActive);
    // final int i = int.tryParse(lastActive.toString()) ?? -1;
    // print("i time");
    // print(i);
    // if (i == -1) return "Last seen not avalable";

    //final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(lastTime.toString()));

    String formattedTime = TimeOfDay.fromDateTime(lastActive!).format(context);
    //String formattedTime = DateFormat('yyyy,MM,dd kk:mm:a').format(lastActive!);
    print("formattedTimess");

    //print(formattedTimes);
    // DateTime time = DateTime.now();
    print("fromMillisecondsSinceEpoch");
    print(formattedTime);
    DateTime now = DateTime.now();

    if (lastActive.day == now.day && lastActive.month == now.month && lastActive.year == now.year) {
      return "Last seen today at ${formattedTime}";
    }
    if ((now.difference(lastActive).inHours / 24).round() == 1) {
      return "Last seen yesterday at ${formattedTime}";
    }
    String month = _getMonth(lastActive);
    return "Last seen on ${lastActive.day} ${month} on ${formattedTime}";
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }

    return "NA";
  }
}
