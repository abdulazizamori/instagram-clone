import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

class CustomEditProfileButton extends StatelessWidget {
  const CustomEditProfileButton({super.key, required this.onpressed, this.text, required this.addFriend});
  final void Function() onpressed;
  final void Function() addFriend;

  final String? text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      Flexible(
        child: GestureDetector(
        onTap: onpressed,
        child: Container(
            width: 328.w,
            height: 30.h,
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light? AppColors.grey.withOpacity(0.5): Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(3)),
            child: Center(
                child: Text(
                  'Edit profile',
                ))),
            ),
      ),
      SizedBox(width: 4,),


      GestureDetector(
            onTap: onpressed,
            child: Container(
                width: 32.w,
                height: 30.h,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light? AppColors.grey.withOpacity(0.5): Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3)),
                child: Center(
                    child: Image.asset('assets/icons/add-friend.png'),
                    )),
          ),

      ],
    );
  }
}
