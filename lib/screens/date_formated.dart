import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDateUtils {
  static String getFormatTime(BuildContext context, String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return TimeOfDay.fromDateTime(date).format(context);
  }
}
