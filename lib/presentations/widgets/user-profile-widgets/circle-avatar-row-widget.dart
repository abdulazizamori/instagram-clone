import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';

import '../../../data/models/user-model.dart';

class CustomCircleAvatarRow extends StatefulWidget {
  const CustomCircleAvatarRow({super.key});

  @override
  State<CustomCircleAvatarRow> createState() => _CustomCircleAvatarRowState();
}

class _CustomCircleAvatarRowState extends State<CustomCircleAvatarRow> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = context.read<AuthCubit>();
        UserModel? userinfo;

        if (state is UserInfoLoaded) {
          userinfo = state.userInfo; // Get the user info when loaded
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 90.w,
              height: 90.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onLongPress: () {
                    user.pickImage();
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: userinfo != null && userinfo.profilePicture!.isNotEmpty
                        ? Image.network(
                      userinfo.profilePicture.toString(),
                      fit: BoxFit.fill,
                    )
                        : const SizedBox(),
                  ),
                ),
              ),
            ),
            Spacer(),
            if (userinfo != null) ...[
              Column(
                children: [
                  Text('${userinfo.postsCount}'),
                  Text('Posts'),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text('${userinfo.followers!.length}'),
                  Text('Followers'),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text('${userinfo.following!.length}'),
                  Text('Following'),
                ],
              ),
            ],
            Spacer(),



          ],
        );
      },
      listener: (context, state) {
        if (state is UploadSuccess) {
          context.read<AuthCubit>().fetchUserInfo(); // Fetch updated user info after upload
        }
        if (state is SignOut) {
          Navigator.pushReplacementNamed(context, 'login');
        }
      },
    );
  }
}
