import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/data/models/user-model.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/main.dart';

class ChatAppBarWidget extends StatefulWidget {
  final String friendid;

  const ChatAppBarWidget({super.key, required this.friendid});

  @override
  State<ChatAppBarWidget> createState() => _ChatAppBarWidgetState();
}

class _ChatAppBarWidgetState extends State<ChatAppBarWidget> {
  String? username;
  String? photo;

  @override
  void initState() {
    super.initState();
    // Fetch current user's information
    context.read<AuthCubit>().fetchUser(widget.friendid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is FetchUserSuccess) {
          username = state.user.userName;
          photo = state.user.profilePicture;
        }

        if (state is UserInfoLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 10, right: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'mainScreen');
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 22,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                  width: 35.w,
                  height: 35.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: photo!.isNotEmpty?Image.network(
                    photo.toString(),
                    fit: BoxFit.fill,
                  ):Icon(Icons.person_outline,size: 28,)),
              SizedBox(
                width: 5.w,
              ),
              Text(
                username ?? 'Loading...',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 3.w),
              Spacer(),
              Icon(Icons.phone_outlined, size: 24),
              SizedBox(
                width: 10.w,
              ),
              Icon(Icons.video_call, size: 24),
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
