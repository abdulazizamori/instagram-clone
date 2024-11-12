import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/main.dart';

class CustomEditProfileAppBar extends StatelessWidget {
  final void Function()? onTap;
  const CustomEditProfileAppBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(onTap: () {
          Navigator.pop(context);
        }, child: Text('Cancel',style: TextStyle(fontSize: 13.sp),)),
        Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
        GestureDetector(
            onTap: onTap,
            child: Text(
              'Done',
              style: TextStyle(color: Colors.blue,fontSize: 13.sp),
            )),
      ],
    );
  }
}
