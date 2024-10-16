import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/themeCubit/theme-cubit.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        // Determine the logo color based on the current theme
        Color logoColor = (themeMode == ThemeMode.dark) ? Colors.white : Colors.black;

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
