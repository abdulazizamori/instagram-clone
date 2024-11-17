import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

class CustomGreyButton extends StatelessWidget {
  final String title;
  final Function? onTap;

  const CustomGreyButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap!();
      },
      child: Container(
        width: 92.w,
        height: 30.h,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light? AppColors.grey.withOpacity(0.2): Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
        )),
      ),
    );
  }
}
