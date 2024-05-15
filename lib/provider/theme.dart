import 'package:flutter/material.dart';
import 'package:nursery/utils/styles.dart';

const Themes _defaultTheme = Themes.system;

enum Themes { light, dark, system }

/// Saves and loads information regarding the theme setting.
class ThemeProvider with ChangeNotifier {
  static Themes _theme = _defaultTheme;

  ThemeProvider() {
    init();
  }

  Themes get theme => _theme;

  set theme(Themes theme) {
    _theme = theme;
    notifyListeners();
  }

  /// Returns appropriate theme mode.
  ThemeMode get themeMode {
    switch (_theme) {
      case Themes.light:
        return ThemeMode.light;
      case Themes.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Default light theme
  ThemeData lightTheme(context) => Style.defaultTheme(context);

  ThemeData darkTheme(context) => Style.defaultTheme(context);

  /// Load theme information from local storage
  Future<void> init() async {}
}