import 'package:flutter/material.dart';

extension ColorExt on Color {
  String toHex({
    bool leadingHashSign = true,
    bool includeAlpha = false,
  }) =>
      '${leadingHashSign ? '#' : ''}'
      '${!includeAlpha ? '' : alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  bool isLight() {
    return (red * 0.299 + green * 0.287 + blue * 0.114 > 50);
  }

  Color textColor() {
    if (isLight()) {
      return kTextColor;
    } else {
      return Colors.white;
    }
  }
}

class AppColors {
  static const primaryColor = Color(0xFF7ABA78);
  static const primaryDarkerColor = Color(0xFF0A6847);
  static const primaryDarkColor = Color(0xFFF6E9B2);
  static const accentColor = Color(0xFFBA2022);
  static const primaryTextColor = Colors.white;
  static const secondaryTextColor = Color(0xFF555555);
  static const blackTextColor = Color(0xff0C0C0C);
  static const lightGray = Color(0xFFeaeaff);
  static const blackedColor = Color(0xFF0C0C0C);
}

const kBlackedColor = AppColors.blackedColor;
const kWhiteColor = Colors.white;
const kPrimaryColor = AppColors.primaryColor;
const kPrimaryDarkerColor = AppColors.primaryDarkerColor;
const kBorderColor = Color(0xFFb8b8d2);
const kCloudyBlueColor = Color(0xFFb8b8d2);
const kGoldenYellowColor = Color(0xFFF3CA52);
const kTextColor = Color(0xFF1f1f39);
const kButtonColor = kPrimaryColor;
const kDarkBlueColor = Color(0xFF244acd);
const kBackgroundColor = Color(0xFFfcfdfe);
const kLightOrangeColor = Color(0xFFffebf0);
const kLightNavyBlueColor = Color(0xFF2b3f7c);