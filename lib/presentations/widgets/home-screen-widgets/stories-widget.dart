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
  String? currentUserId;

  @override
  void initState() {
    super.initState();

    // Fetch user info to retrieve the current user's ID
    context.read<AuthCubit>().fetchUserInfo();

    // After fetching user info, listen to updates to get the user ID
    context.read<AuthCubit>().stream.listen((authState) {
      if (authState is UserInfoLoaded) {
        setState(() {
          currentUserId = authState.userInfo.uid;
        });
        // Fetch stories only after user info is loaded and currentUserId is set
        if (currentUserId != null) {
          context.read<StoryCubit>().fetchAllStories(currentUserId!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only fetch stories if currentUserId is set
    if (currentUserId == null) {
      return Center(child: CircularProgressIndicator());
    }

    return BlocConsumer<StoryCubit, StoryState>(
      listener: (context, state) {
        if (state is StoryError) {
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
          final userHasStory = state.userHasStory;

          return SizedBox(
            height: 90.h,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userHasStory?stories.length+1:stories.length+1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Show the current user's story with blue "Add Story" icon or long-press option
                  return GestureDetector(
                    onTap: () {
                      if (userHasStory) {
                        // Navigate to view the user's existing story
                        final userStories = stories
                            .where((s) => s.uid == currentUserId)
                            .toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StoryViewScreen(stories: userStories),
                          ),
                        );
                      } else {
                        // Navigate to add a new story
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddStoryScreen(),
                          ),
                        );
                      }
                    },
                    onLongPress: () {
                      // Allow long press to add a new story for the current user
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddStoryScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 70,
                            child: Stack(
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, authState) {
                                      String profilePictureUrl = '';
                                      if (authState is UserInfoLoaded) {
                                        profilePictureUrl =
                                            authState.userInfo.profilePicture ??
                                                '';
                                      }
                                      return Image.network(
                                        profilePictureUrl,
                                        fit: BoxFit.fill,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light
                                                          ? Colors.grey
                                                              .withOpacity(0.2)
                                                          : Colors.grey
                                                              .withOpacity(
                                                                  0.5))),
                                              child:
                                                  Icon(Icons.person_outline));
                                        },
                                      );
                                    },
                                  ),
                                ),
                                if (!userHasStory)
                                  Positioned(
                                    bottom: 0,
                                    right: 6,
                                    child: Container(
                                      width: 22.w,
                                      height: 22.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      child: Icon(Icons.add,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Your Story',
                            style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // For followed users' stories, do not show "Add Story" button
                  final story = stories[index - 1];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to view the selected user's story
                      final userStories =
                          stories.where((s) => s.uid == story.uid).toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StoryViewScreen(stories: userStories),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  story.userProfilePicture ?? '',
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .brightness ==
                                                    Brightness.light
                                                    ? Colors.grey
                                                    .withOpacity(0.2)
                                                    : Colors.grey
                                                    .withOpacity(
                                                    0.5))),
                                        child:
                                        Icon(Icons.person_outline));
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            story.userName.toString(),
                            style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold),
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
          return Center(child: Text('No stories to show'));
        }
      },
    );
  }
}
