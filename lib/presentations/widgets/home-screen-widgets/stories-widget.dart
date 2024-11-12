import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/presentations/widgets/home-screen-widgets/story-detailed-view-screen.dart';
import '../../../logic/storyCubit/story_cubit.dart';
import '../../screens/home-screen/add-story-screen.dart';

class StoriesWidget extends StatefulWidget {
  const StoriesWidget({super.key});

  @override
  State<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch all stories and user info when the widget initializes
    context.read<StoryCubit>().fetchAllStories();
    context.read<AuthCubit>().fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoryCubit, StoryState>(
      listener: (context, state) {
        if (state is StoryError) {
          // Show a snackbar or some form of feedback for the error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is StoryLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is StoriesLoaded) {
          final stories = state.stories;

          return SizedBox(
            height: 90.h,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length + 1, // +1 for the user's own story
              itemBuilder: (context, index) {
                if (index == 0) {
                  // First item is the user's own story
                  return GestureDetector(
                    onTap: () {
                      // Navigate to add story screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddStoryScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              // User's profile picture as the background
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle
                                  ),
                                  child: BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, state) {
                                      // Get the user's profile picture from the AuthCubit
                                      String profilePictureUrl = '';
                                      if (state is UserInfoLoaded) {
                                        profilePictureUrl = state.userInfo.profilePicture ?? 'assets/images/user_profile.png';
                                      }
                                      return Image.network(
                                        profilePictureUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          // Fallback image if the network image fails to load
                                          return Image.asset('assets/images/user_profile.png', fit: BoxFit.cover);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                right: 1,
                                child: Container(
                                  width: 20.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue, // Blue color for the add button
                                  ),
                                  child: Icon(Icons.add, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Your Story',
                            style: TextStyle(fontSize: 10.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // For followed users' stories
                  final story = stories[index - 1]; // Adjust index for user stories
                  return GestureDetector(
                    onTap: () {
                      // Fetch the stories for the tapped user
                      final userStories =
                      stories.where((s) => s.uid == story.uid).toList();

                      // Navigate to the detailed story view for this user
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryViewScreen(
                            stories: userStories, // Pass the filtered user stories
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              // User's profile picture as the background
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                ),
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(shape: BoxShape.circle),
                                  child: Image.network(
                                    story.userProfilePicture ?? 'default_profile_picture_url',
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback image if the network image fails to load
                                      return Image.asset('assets/images/user_profile.png', fit: BoxFit.fill);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            story.userName ?? 'User', // Display user name
                            style: TextStyle(fontSize: 12.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          );
        } else {
          context.read<StoryCubit>().fetchAllStories();
          return Center(child: Text('No stories to show'));
        }
      },
    );
  }
}
