import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/main.dart';

import '../../../data/models/user-model.dart';

class CustomColumnInfo extends StatelessWidget {
  final UserModel userModel;
  const CustomColumnInfo({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userModel.userName!.isNotEmpty?Text(userModel.userName.toString(),style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w700),):SizedBox(),
          userModel.name!.isNotEmpty?Text(userModel.name.toString(),style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w400),):SizedBox(),
          userModel.bio!.isNotEmpty?Text(userModel.bio.toString(),style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w400)):SizedBox(),
        ],
      ),
    );
  }
}
