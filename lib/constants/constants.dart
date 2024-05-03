import 'package:flutter/material.dart';

abstract class AppColors {
  static Color mainDark = const Color(0xFF252525);
  static Color secondaryDark = const Color(0xFF323232);
  static Color thirdDark = const Color(0xFF7C7C7C);
  static Color fourthDark = const Color(0xFF484848);

  static Color mainGreen = const Color(0xFF3DD178);
  static Color mainGreenDark = const Color(0xFF066736);
  static Color mainRed = const Color(0xFFE32C2C);

  static Color mainBlue = const Color(0xFF2C7EE3);

  static Color mainTextDark = Colors.white;
  static Color secondaryTextDark = const Color(0xFF939393);
  static Color thirdTextDark = const Color(0xFFC9C9C9);

  static Color splashGreen = const Color.fromARGB(255, 9, 143, 76);
  static Color splashGray = const Color.fromARGB(255, 88, 88, 88);
  static Color splashLightGray = const Color.fromARGB(255, 119, 119, 119);
  static Color splashSuperLightGray = const Color.fromARGB(255, 159, 159, 159);
}

abstract class AppMeasures {
  static double padding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.035;
  }

  static double picturesPadding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.15;
  }
}

abstract class LocalesKeys {
  static const english = 'en';
  static const russian = 'ru';
}

abstract class SharedPreferencesKeys {
  static const locale = 'locale';
}

abstract class HiveKeys {
  static const todayTasksBox = 'today_tasks_box';
  static const otherTasksBox = 'other_tasks_box';
  static const doneTasksBox = 'done_tasks_box';
}
