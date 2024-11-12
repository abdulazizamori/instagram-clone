import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';

import '../../../data/models/user-model.dart';

class CustomCircleAvatarRow extends StatefulWidget {
  const CustomCircleAvatarRow({super.key});

  @override
  State<CustomCircleAvatarRow> createState() => _CustomCircleAvatarRowState();
}

class _CustomCircleAvatarRowState extends State<CustomCircleAvatarRow> {
  UserModel? _lastUserInfo; // To hold the last successful user info

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        final userCubit = context.read<AuthCubit>();

        if (state is UserInfoLoaded) {
          _lastUserInfo = state.userInfo; // Update with the new user info when loaded
        }

        // Continue displaying the previous user info if loading or during an upload
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
                    userCubit.pickImage(); // Trigger image selection
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: _lastUserInfo != null && _lastUserInfo!.profilePicture!.isNotEmpty
                        ? Image.network(
                      _lastUserInfo!.profilePicture.toString(),
                      fit: BoxFit.fill,
                    )
                        : const SizedBox(),
                  ),
                ),
              ),
            ),
            Spacer(),
            if (_lastUserInfo != null) ...[
              Column(
                children: [
                  Text('${_lastUserInfo!.postsCount}'),
                  Text('Posts'),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text('${_lastUserInfo!.followers!.length}'),
                  Text('Followers'),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text('${_lastUserInfo!.following!.length}'),
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
