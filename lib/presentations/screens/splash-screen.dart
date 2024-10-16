import 'package:flutter/material.dart';
import 'package:instaclone/presentations/screens/theme-mode.dart';
import 'package:instaclone/shared/widgets/logo-widget.dart';

import '../../logic/themeCubit/theme-cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Use BlocBuilder to listen for theme changes
        child: LogoWidget()
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ThemeModeScreen()),
    );
  }
}
