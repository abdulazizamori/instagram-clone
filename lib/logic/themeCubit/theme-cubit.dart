import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  // Takes the theme mode that we passed to it and changes the theme to light or dark mode
  void updateTheme(ThemeMode themeMode) => emit(themeMode);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    // Deserialize the theme mode from JSON
    final themeString = json['theme'] as String?;
    if (themeString == null) {
      return ThemeMode.system; // Default if no theme is found
    }
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // Serialize the current theme mode to JSON
    return {
      'theme': state.toString(), // Convert the ThemeMode to a string
    };
  }
}
