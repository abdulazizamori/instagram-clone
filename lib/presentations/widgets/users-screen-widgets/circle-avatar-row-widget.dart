import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/user-model.dart';
import '../../../logic/authCubit/auth_cubit.dart';

class CustomUserCircleAvatarRowWidget extends StatelessWidget {
  final UserModel userModel;

  const CustomUserCircleAvatarRowWidget({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Container(
                width: 90.w,
                height: 90.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)
                    ),
                    child: userModel.profilePicture!.isNotEmpty?Image.network(
                      userModel.profilePicture.toString(),
                      fit: BoxFit.fill,
                    ):Icon(Icons.person_outline,size: 28,),
                  ),
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    userModel.postsCount.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'posts',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    userModel.followersCount.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'followers',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    userModel.followingCount.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'following',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        );
  }
}
