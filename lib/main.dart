import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/logic/posts-cubit/posts_cubit.dart';
import 'package:instaclone/logic/storyCubit/story_cubit.dart';
import 'package:instaclone/logic/themeCubit/theme-cubit.dart';
import 'package:instaclone/logic/user-detailsCubit/user_details_cubit.dart';
import 'package:instaclone/main-screen.dart';
import 'package:instaclone/presentations/screens/auth-screens/login-screen.dart';
import 'package:instaclone/presentations/screens/profile-screen/addpost.dart';
import 'package:instaclone/presentations/screens/profile-screen/edit-profile-screen.dart';
import 'package:instaclone/presentations/screens/profile-screen/profile-screen.dart';
import 'package:instaclone/presentations/screens/splash-screen/splash-screen.dart';
import 'package:instaclone/presentations/screens/theme-mode.dart';
import 'package:instaclone/presentations/widgets/homeScreen-widgets/app-bar-widget.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme/app_theme.dart';
import 'data/sharedprefrence/cache.dart';
import 'firebase_options.dart';
import 'presentations/screens/auth-screens/register-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.cachIntialization();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
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
              BlocProvider(create: (context) => AuthCubit()),
              BlocProvider(create: (context) => UserDetailsCubit()),
              BlocProvider(create: (context) => PostsCubit()),
              BlocProvider(create: (context) => StoryCubit()),

            ],

            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Instagram',
                themeMode: mode,
                darkTheme: AppTheme.DarkTheme,
                theme: AppTheme.lightTheme,
                home: LogInScreen(),
                initialRoute: 'splash',
                routes: {
                  'login': (context) => LogInScreen(),
                  'register': (context) => RegisterScreen(),
                  'splash': (context) => SplashScreen(),
                  'themescreen': (context) => ThemeModeScreen(),
                  'profileScreen': (context) => ProfileScreen(),
                  'createPost':(context) => CreatePostScreen(),
                  'editProfileScreen': (context) => EditProfileScreen(),
                  'homeScreen': (context) => CustomHomeScreenAppBar(),
                  'mainScreen': (context) => MainScreen(),
                },
              ),
            ),
          );
        });
  }
}
