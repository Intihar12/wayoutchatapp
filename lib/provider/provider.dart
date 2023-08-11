import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeProvider with ChangeNotifier {
  // ThemeMode _themeMode = ThemeMode.light;
  ThemeMode? _themeMode;

  ThemeMode? get themeMode => _themeMode;
  final box = GetStorage();

  getTheme() {
    String tempTheme = box.read('themeMode');

    _themeMode = tempTheme.contains('dark') ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    box.write('themeMode', '$_themeMode');
    notifyListeners();
  }
}
