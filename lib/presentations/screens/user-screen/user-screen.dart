import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/data/models/user-model.dart';
import 'package:instaclone/main.dart';

import '../../../data/models/story-model.dart';
import '../../../logic/authCubit/auth_cubit.dart';
import '../../../logic/storyCubit/story_cubit.dart';
import '../../widgets/profile-screen-widgets/listview-highlights.dart';
import '../../widgets/users-screen-widgets/app-bar-widget.dart';
import '../../widgets/users-screen-widgets/circle-avatar-row-widget.dart';
import '../../widgets/users-screen-widgets/follow-button-widget.dart';
import '../../widgets/users-screen-widgets/grey-button-widget.dart';
import '../../widgets/users-screen-widgets/name-bio-widget.dart';
import '../../widgets/users-screen-widgets/tab-bar-widget.dart';
import '../chat-screens/chat-screen.dart';

class UserScreen extends StatefulWidget {
  final UserModel userModel;
  final String userId;

  const UserScreen({super.key, required this.userModel, required this.userId});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isFollowing = false; // Local state for following status
  final currentUser = FirebaseAuth.instance.currentUser!.uid;


  @override
  void initState() {
    super.initState();
    final cubit = context.read<AuthCubit>().fetchUserInfo();
    // Check if the current user is following the target user
  }

  void updateFollowState() {
    setState(() {
      isFollowing = !isFollowing; // Toggle the following state
      if (isFollowing) {
        widget.userModel.followersCount++; // Increment followers count locally
      } else {
        widget.userModel.followersCount--; // Decrement followers count locally
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UserInfoLoaded) {
          final currentUser = state.userInfo;
          isFollowing = currentUser.following?.contains(widget.userId) ?? false;
        }
      },
      builder: (context, state) {
        final currentUser = FirebaseAuth.instance.currentUser!.uid;
        final cubit = context.read<AuthCubit>();
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomUserAppBarWidget(
                    uerId: widget.userId,
                    userModel: widget.userModel,
                  ),
                  SizedBox(height: 5.h),
                  CustomUserCircleAvatarRowWidget(
                    userModel: widget.userModel,
                  ),
                  SizedBox(height: 5.h),
                  CustomColumnInfo(
                    userModel: widget.userModel,
                  ),
                  SizedBox(height: 20.h),
                  FollowButtonWidget(
                    targetUserId: widget.userId,
                    isFollowing: isFollowing, // Use local state
                    onFollow: () async {
                      await cubit.followUser(
                          widget.userId); // Call the follow function
                      updateFollowState(); // Update local state
                    },
                    onUnfollow: () async {
                      await cubit.unfollowUser(
                          widget.userId); // Call the unfollow function
                      updateFollowState(); // Update local state
                    },
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomGreyButton(
                          title: 'Message',
                          onTap: () {
                            // Example of navigating to ChatScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(senderId: currentUser, receiverId: widget.userId,
                                   // The recipient's user ID
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10,),
                        CustomGreyButton(title: 'Subscribe'),
                        SizedBox(width: 10,),
                        CustomGreyButton(title: 'Contact'),

                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  BlocBuilder<StoryCubit, StoryState>(
                    builder: (context, state) {
                      if (state is StoryLoading) {
                        return Center(
                            child:
                                CircularProgressIndicator()); // Show loading indicator
                      } else if (state is StoriesLoaded) {
                        // Access current user using context.read<AuthCubit>()
                        if (widget.userId != null) {
                          // Filter only the current user's stories
                          List<StoryModel> currentUserStories = state.stories
                              .where((story) =>
                                  story.uid ==
                                  widget
                                      .userId) // Ensure 'uid' is the correct field in StoryModel
                              .toList();

                          return CustomListViewHighLights(
                              userStories:
                                  currentUserStories); // Pass the current user's stories
                        } else {
                          return Text(
                              'Current user not found.'); // Handle case where current user is null
                        }
                      } else {
                        return Text(
                            'Error loading stories'); // Handle other states
                      }
                    },
                  ),
                  Expanded(
                      child: CustomUserTabBarWidget(
                    userId: widget.userId,
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
