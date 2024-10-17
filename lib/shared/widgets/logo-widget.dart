import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/themeCubit/theme-cubit.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        // Get the current brightness of the theme
        bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

        // Determine the logo color based on the theme brightness
        Color logoColor = isDarkMode ? Colors.white : Colors.black;

        return ColorFiltered(
          colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
          child: Image.asset(
            'assets/images/instalogo.png', // Your logo path here
            height: 50, // Adjust size as necessary
          ),
        );
      },
    );
  }
}
