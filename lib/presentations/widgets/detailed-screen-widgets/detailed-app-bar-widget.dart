import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/authCubit/auth_cubit.dart';

class CustomDetailedAppBar extends StatefulWidget {
  final String title;

  CustomDetailedAppBar({super.key, required this.title});

  @override
  State<CustomDetailedAppBar> createState() => _CustomDetailedAppBarState();
}

class _CustomDetailedAppBarState extends State<CustomDetailedAppBar> {
  @override
  void initState() {
    super.initState();
    // Fetch user info when the screen loads
    context.read<AuthCubit>().fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        String? username = '';
        if (state is UserInfoLoaded) {
          final userInfo = state.userInfo;
          username = userInfo.userName.toString();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).brightness==Brightness.light?Colors.white:Colors.black, // Set a fixed color for app bar
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_rounded),
            ),
            title: Column(
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
