import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/main.dart';

import '../../../core/theme/app_colors.dart';

class CustomFriendsButtonWidget extends StatelessWidget {
  const CustomFriendsButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 30.h,
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light? AppColors.grey.withOpacity(0.5): Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12)
      ),
      child: Center(child: Icon(Icons.person_add)),

    );
  }
}
