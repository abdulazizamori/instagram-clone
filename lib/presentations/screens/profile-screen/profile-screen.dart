import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/logic/storyCubit/story_cubit.dart';
import '../../../data/models/story-model.dart';
import '../../widgets/profile-screen-widgets/circle-avatar-row-widget.dart';
import '../../widgets/profile-screen-widgets/column-of-texts-widget.dart';
import '../../widgets/profile-screen-widgets/custom-app-bar-widget.dart';
import '../../widgets/profile-screen-widgets/edit-profile-button-widget.dart';
import '../../widgets/profile-screen-widgets/listview-highlights.dart';
import '../../widgets/profile-screen-widgets/tabbar-widget.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                    // Wrap only the highlights list with BlocConsumer
                    BlocBuilder<StoryCubit, StoryState>(
                      builder: (context, state) {
                        if (state is StoryLoading) {
                          return Center(child: CircularProgressIndicator()); // Show loading indicator
                        } else if (state is StoriesLoaded) {
                          // Access current user using context.read<AuthCubit>()
                          final currentUser = FirebaseAuth.instance.currentUser!.uid; // Corrected access method
                          if (currentUser != null) {
                            // Filter only the current user's stories
                            List<StoryModel> currentUserStories = state.stories
                                .where((story) => story.uid == currentUser) // Ensure 'uid' is the correct field in StoryModel
                                .toList();

                            return CustomListViewHighLights(userStories: currentUserStories); // Pass the current user's stories
                          } else {
                            return Text('Current user not found.'); // Handle case where current user is null
                          }
                        } else {
                          return Text('Error loading stories'); // Handle other states
                        }
                      },
                    ),
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
  }
}
