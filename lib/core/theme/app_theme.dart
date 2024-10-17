import 'package:flutter/material.dart';
import 'package:instaclone/core/theme/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: AppColors.lightBackground,
      brightness: Brightness.light,
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //   backgroundColor: AppColors.buttonBlue,
      //   textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(16)
      //       )
      //
      // ))
  );


  static final DarkTheme = ThemeData(
      primaryColor: Colors.white,
      scaffoldBackgroundColor: AppColors.darkBackground,
      brightness: Brightness.dark,
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //         backgroundColor: AppColors.buttonBlue,
      //         textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(16)
      //         )
      //
      //     ))
  );
}
