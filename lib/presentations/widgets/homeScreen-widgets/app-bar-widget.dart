import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/main.dart';

class CustomHomeScreenAppBar extends StatelessWidget {
  const CustomHomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 104.w,
            height: 30.h,
            child: Image.asset(
              'assets/images/instalogo.png',
              fit: BoxFit.fill,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            )),
        SizedBox(
          width: 5.w,
        ),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 34,
        ),
        Spacer(),
        Icon(
          Icons.favorite_border_sharp,
          size: 34,
        ),
        SizedBox(width: 30,),
        Container(
          width: 30,
          height: 30,
          child: Image.asset('assets/icons/direct.png',color:Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          fit: BoxFit.fill,),
        ),
        SizedBox(width: 30,),

        Container(
          width: 30,
          height: 30,
          child: Image.asset('assets/icons/profile-add.png',color:Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
            fit: BoxFit.fill,),
        ),

      ],
    );
  }
}
