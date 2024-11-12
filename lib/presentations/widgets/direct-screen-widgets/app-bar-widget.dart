import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/main.dart';

class DirectAppBarWidget extends StatefulWidget {
  const DirectAppBarWidget({super.key});

  @override
  State<DirectAppBarWidget> createState() => _DirectAppBarWidgetState();
}

class _DirectAppBarWidgetState extends State<DirectAppBarWidget> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  String? username;

  @override
  void initState() {
    super.initState();
    // Fetch current user's information
    context.read<AuthCubit>().fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is UserInfoLoaded) {
          username = state.userInfo.userName;
        }

        if (state is UserInfoLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, 'mainScreen');
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 28,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              username ?? 'Loading...',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 3.w),
            Icon(Icons.keyboard_arrow_down_rounded),
            Spacer(),
            Icon(Icons.edit_outlined, size: 28),
          ],
        );
      },
      listener: (context, state) {
        // No listener needed for now
      },
    );
  }
}
