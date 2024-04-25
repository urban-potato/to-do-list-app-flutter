import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list_app/constants/constants.dart';

final darkTheme = ThemeData(
  fontFamily: GoogleFonts.inter().fontFamily,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainGreen),
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.mainDark,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: const CircleBorder(),
    backgroundColor: AppColors.mainGreen,
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: AppColors.mainDark,
    titleTextStyle: TextStyle(
      color: AppColors.mainTextDark,
      fontWeight: FontWeight.w700,
      fontSize: 28,
    ),
    iconTheme: IconThemeData(color: AppColors.secondaryTextDark),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: AppColors.secondaryTextDark,
  ),
  iconTheme: IconThemeData(
    color: AppColors.secondaryTextDark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.fourthDark,
    elevation: 0,
    // labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
    //   (Set<MaterialState> state) => state.contains(MaterialState.selected)
    //       ? TextStyle(color: AppColors.mainGreen)
    //       : TextStyle(color: AppColors.fourthDark),
    // ),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
  ),
  textTheme: GoogleFonts.interTextTheme(
    TextTheme(
      titleLarge: TextStyle(
        color: AppColors.mainTextDark,
        fontWeight: FontWeight.w500,
        fontSize: 28,
      ),
      titleMedium: TextStyle(
        color: AppColors.mainTextDark,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      titleSmall: TextStyle(
        color: AppColors.secondaryTextDark,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(
        fontFamily: GoogleFonts.inter().fontFamily,
        color: AppColors.mainTextDark,
        fontWeight: FontWeight.w700,
        fontSize: 32,
      ),
      bodyMedium: TextStyle(
        color: AppColors.thirdTextDark,
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
    ),
  ),
);
