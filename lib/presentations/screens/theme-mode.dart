import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instaclone/logic/themeCubit/theme-cubit.dart';
import 'package:instaclone/logic/themeCubit/theme-cubit.dart';

class ThemeModeScreen extends StatefulWidget {
  const ThemeModeScreen({super.key});

  @override
  State<ThemeModeScreen> createState() => _ThemeModeScreenState();
}

class _ThemeModeScreenState extends State<ThemeModeScreen> {
  bool lightMode = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeCubit, ThemeMode>(
      listener: (context, state) {
      },
      builder: (context, mode) {
        final theme = context.read<ThemeCubit>();
        return Scaffold(
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if(lightMode == true){
                      theme.updateTheme(ThemeMode.dark);
                      lightMode = false;
                    }else{
                      theme.updateTheme(ThemeMode.light);
                      lightMode = true;
                    }
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
