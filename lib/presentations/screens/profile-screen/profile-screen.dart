import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/logic/user-detailsCubit/user_details_cubit.dart';
import '../../widgets/user-profile-widgets/circle-avatar-row-widget.dart';
import '../../widgets/user-profile-widgets/column-of-texts-widget.dart';
import '../../widgets/user-profile-widgets/custom-app-bar-widget.dart';
import '../../widgets/user-profile-widgets/edit-profile-button-widget.dart';
import '../../widgets/user-profile-widgets/listview-highlights.dart';
import '../../widgets/user-profile-widgets/tabbar-widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDetailsCubit, UserDetailsState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDetailsAppBar(),
                        SizedBox(height: 10),
                        CustomCircleAvatarRow(),
                        SizedBox(height: 10),
                        CustomColumnOfText(),
                        SizedBox(height: 10),
                        CustomEditProfileButton(
                          onpressed: () {
                            Navigator.pushNamed(context, 'editProfileScreen');
                          },
                          addFriend: () {},
                        ),
                        SizedBox(height: 10),
                        CustomListViewHighLights(),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // Make the TabBar and its content flexible
                  Container(
                    width: MediaQuery.of(context).size.width.w,
                    height: 400.h, // This can be adjusted based on your layout
                    child: const CustomTabBar(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
      },
    );
  }
}
