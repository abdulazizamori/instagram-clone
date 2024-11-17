import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/data/models/user-model.dart';
import 'package:instaclone/main.dart';

class CustomUserAppBarWidget extends StatefulWidget {
  final UserModel userModel;
  final String uerId;

  const CustomUserAppBarWidget(
      {super.key, required this.userModel, required this.uerId});

  @override
  State<CustomUserAppBarWidget> createState() => _CustomUserAppBarWidgetState();
}

class _CustomUserAppBarWidgetState extends State<CustomUserAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_rounded)),
          Spacer(),
          Text(
            widget.userModel.userName.toString(),
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
          ),
          Spacer(),
          Image.asset('assets/icons/bell.png'),
          SizedBox(
            width: 10.w,
          ),
          Icon(Icons.more_horiz)
        ],
      ),
    );
  }
}
