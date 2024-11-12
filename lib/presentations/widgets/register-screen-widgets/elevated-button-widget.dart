import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/core/theme/app_colors.dart';
import 'package:instaclone/main.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function() onpressed;
  final String? text;

  const CustomElevatedButton(
      {super.key, required this.onpressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
          width: 400.w,
          height: 50.h,
          decoration: BoxDecoration(
              color: AppColors.buttonBlue,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            '$text',
            style: TextStyle(color: Colors.white),
          ))),
    );
  }
}
