import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/logic/themeCubit/theme-cubit.dart';
import 'package:instaclone/presentations/screens/splash-screen.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentations/screens/auth-screens/register-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ThemeCubit()),
              BlocProvider(create: (context) => AuthCubit())
            ],
            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Instagram',
                themeMode: mode,
                darkTheme: AppTheme.DarkTheme,
                theme: AppTheme.lightTheme,
                home: RegisterScreen(),
              ),
            ),
          );
        });
  }
}
