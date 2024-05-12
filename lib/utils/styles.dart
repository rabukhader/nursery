
import 'package:flutter/material.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/fonts.dart';


/// Class that contains all the different styles of an app
class Style {
  static const _pageTransitionsTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  static const TextTheme appTextTheme = TextTheme(
    subtitle1: TextStyle(
      color: kTextColor,
      fontSize: 14,
    ),
    subtitle2: TextStyle(
      color: kTextColor,
    ),
  );

  static ThemeData defaultTheme(context) => ThemeData(
        useMaterial3: false,
        fontFamily: kDefaultFont,
        pageTransitionsTheme: _pageTransitionsTheme,
        brightness: Brightness.light,
        primaryColor: kPrimaryColor,
        colorScheme: const ColorScheme.light(
          secondary: kDarkBlueColor,
          primary: kDarkBlueColor,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: appTextTheme,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kBorderColor, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Theme.of(context).errorColor, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kBorderColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Theme.of(context).errorColor, width: 1.5),
          ),
        ),
      );
}