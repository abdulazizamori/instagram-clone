import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/logic/chat-cubit/chat_cubit.dart';
import 'package:instaclone/logic/posts-cubit/posts_cubit.dart';
import 'package:instaclone/logic/storyCubit/story_cubit.dart';
import 'package:instaclone/logic/themeCubit/theme-cubit.dart';
import 'package:instaclone/main-screen.dart';
import 'package:instaclone/presentations/screens/auth-screens/login-screen.dart';
import 'package:instaclone/presentations/screens/chat-screens/direct-screen.dart';
import 'package:instaclone/presentations/screens/explorer-screen/explorer-screen.dart';
import 'package:instaclone/presentations/screens/explorer-screen/search-users-screen.dart';
import 'package:instaclone/presentations/screens/profile-screen/addpost.dart';
import 'package:instaclone/presentations/screens/profile-screen/edit-profile-screen.dart';
import 'package:instaclone/presentations/screens/profile-screen/profile-screen.dart';
import 'package:instaclone/presentations/screens/splash-screen/splash-screen.dart';
import 'package:instaclone/presentations/screens/theme-mode.dart';
import 'package:instaclone/presentations/widgets/home-screen-widgets/app-bar-widget.dart';
import 'package:path_provider/path_provider.dart';
import 'core/theme/app_theme.dart';
import 'data/sharedprefrence/cache.dart';
import 'firebase_options.dart';
import 'presentations/screens/auth-screens/register-screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences
  await CacheHelper.cachIntialization();

  // Initialize Firebase
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
// Listen for messages in the background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Check for messages that opened the app from a terminated state
  final RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print('Notification caused app to open: ${initialMessage.notification?.title}');
  }

  // Listen for messages in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message received in foreground: ${message.notification?.title}');
    // Optionally show a local notification here
  });
  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.debug,
  );

  // Set up FCM token if user is authenticated
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await saveFcmToken(user.uid);
  }

  // Initialize Firebase Messaging AutoInit
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // Initialize Hydrated Storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  print('Message received in background: ${message.notification?.title}');
}

/// Saves the FCM token for the current user in Firestore
Future<void> saveFcmToken(String userId) async {
  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");
    if (fcmToken != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': fcmToken,
      });
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error saving FCM token: $e');
    }
  }
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
            BlocProvider(create: (context) => PostsCubit()),
            BlocProvider(create: (context) => StoryCubit()),
            BlocProvider(create: (context) => ChatCubit()),
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
                'createPost': (context) => CreatePostScreen(),
                'editProfileScreen': (context) => EditProfileScreen(),
                'homeScreen': (context) => CustomHomeScreenAppBar(),
                'mainScreen': (context) => MainScreen(),
                'explorerScreen': (context) => ExplorerScreen(),
                'searchUserScreen': (context) => SearchUsersScreen(),
                'directScreen': (context) => DirectScreen(),
              },
            ),
          ),
        );
      },
    );
  }
}
