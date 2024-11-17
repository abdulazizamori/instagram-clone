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
          size: 24,
        ),
        Spacer(),
        Icon(
          Icons.favorite_border_sharp,
          size: 24,
        ),
        SizedBox(width: 15.w,),
         GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, 'directScreen');
            },
            child: Image.asset('assets/icons/direct.png',color:Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fit: BoxFit.fill,),
          ),
        SizedBox(width: 15.w,),

      ],
    );
  }
}
