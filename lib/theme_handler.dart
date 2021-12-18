import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeHandler extends ChangeNotifier {
  final _darkTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Color(0xff2e2e2e),
      brightness: Brightness.dark,
      shadowColor: Colors.grey,
      backgroundColor: const Color(0xFF212121),
      secondaryHeaderColor: Color(0xff404040),
      accentColor: Colors.white,
      accentIconTheme: IconThemeData(color: Colors.black),
      dividerColor: Colors.black12,
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.white),
      ));
  final _lightTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.white,
      brightness: Brightness.light,
      shadowColor: Color(0xffcbcfd5),
      backgroundColor: const Color(0xFFE5E5E5),
      secondaryHeaderColor: Colors.white,
      accentColor: Colors.black,
      accentIconTheme: IconThemeData(color: Colors.white),
      dividerColor: Colors.white54,
      textTheme: TextTheme(headline1: TextStyle(color: Colors.black87)));
  bool enableDarkTheme = false;
  ThemeData? _themeData;
  ThemeHandler() {
    _themeData = _lightTheme;
  }
  ThemeData? getTheme() => _themeData;
  bool? isEnabled() => enableDarkTheme;
  void changeTheme() {
    enableDarkTheme = !enableDarkTheme;
    _themeData = enableDarkTheme ? _darkTheme : _lightTheme;
    notifyListeners();
  }
}
