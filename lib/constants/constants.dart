import 'package:flutter/material.dart';

abstract class AppColors {
  static Color mainDark = const Color(0xFF252525);
  static Color secondaryDark = const Color(0xFF323232);
  static Color thirdDark = const Color(0xFF7C7C7C);
  static Color fourthDark = const Color(0xFF484848);

  static Color mainGreen = const Color(0xFF3DD178);
  static Color mainGreenDark = const Color(0xFF066736);
  static Color mainRed = const Color(0xFFE32C2C);

  static Color mainTextDark = Colors.white;
  static Color secondaryTextDark = const Color(0xFF939393);
  static Color thirdTextDark = const Color(0xFFC9C9C9);
}

abstract class AppMeasures {
  static double padding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.035;
  }
}

abstract class LocalesKeys {
  static const english = 'en';
  static const russian = 'ru';
}

abstract class SharedPreferencesKeys {
  static const locale = 'locale';
}
