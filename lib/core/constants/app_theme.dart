import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: AppColors.lightColorScheme,
    fontFamily: 'Roboto',
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: AppColors.darkColorScheme,
    fontFamily: 'Roboto',
    useMaterial3: true,
  );
}
