import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/core/theme/app_colors.dart';
import 'package:instaclone/main.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const CustomTextField({super.key, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      height: 56.h,

      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light? AppColors.grey.withOpacity(0.5): Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.light? Colors.black:Colors.white
              )
            ),
          ),
        ),
      ),

    );
  }
}
