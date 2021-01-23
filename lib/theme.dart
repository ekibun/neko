import 'dart:io';

import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  static Color _primaryColor = Color(0xfff09199);
  static Color _accentColor = Color(0xffec818a);

  ThemeMode themeMode = ThemeMode.system;

  static ThemeData getThemeData(Brightness brightness) {
    return ThemeData(
        brightness: brightness,
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        canvasColor: brightness == Brightness.light
            ? Colors.grey[200]
            : Colors.grey[850],
        hintColor: _primaryColor,
        backgroundColor: Colors.transparent,
        splashColor: _accentColor.withAlpha(50),
        primaryColorBrightness: Brightness.dark,
        fontFamily: Platform.isWindows ? "Microsoft Yahei UI" : null);
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static AppTheme _instance;
  static AppTheme get instance {
    if (_instance == null) _instance = AppTheme();
    return _instance;
  }
}
