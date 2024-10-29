import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/authCubit/auth_cubit.dart';
import '../../../logic/storyCubit/story_cubit.dart';
import '../../../data/models/story-model.dart'; // Ensure you import your StoryModel

class AddStoryScreen extends StatefulWidget {
  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoryCubit, StoryState>(
      listener: (context, state) {
        if (state is StoryCreatedSuccess) {
          // If the story was added successfully, navigate back
          Navigator.pop(context);
        } else if (state is StoryError) {
          // Handle errors if the story addition failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Add Story')),
        body: BlocBuilder<StoryCubit, StoryState>(
          builder: (context, state) {
            if (state is StoryLoading) {
              // Show a progress indicator while uploading
              return Center(child: CircularProgressIndicator());
            }

            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Pick images or videos
                  final List<XFile>? mediaFiles =
                      await _picker.pickMultiImage();
                  if (mediaFiles != null && mediaFiles.isNotEmpty) {
                    // Fetch user info from UserCubit
                    final userInfoState = context.read<AuthCubit>().state;

                    if (userInfoState is UserInfoLoaded) {
                      // Get the current user's ID
                      final currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;

                      // Check if a story already exists for the current user
                      final existingStory =
                          context.read<StoryCubit>().stories.firstWhere(
                                (story) => story.uid == currentUserId,
                                orElse: () => StoryModel(
                                  storyId: '',
                                  uid: currentUserId,
                                  userProfilePicture:
                                      userInfoState.userInfo.profilePicture,
                                  userName: userInfoState.userInfo.userName,
                                  mediaUrls: [],
                                  createdAt: DateTime.now(),
                                  isVideo: false,
                                  viewers: [],
                                ),
                              );

                      if (existingStory.storyId!.isNotEmpty) {
                        // If a story exists, add images to the existing story
                        context.read<StoryCubit>().addImagesToStory(
                              existingStory.storyId.toString(),
                              mediaFiles.map((file) => file.path).toList(),
                            );
                      } else {
                        // Create a new story
                        context.read<StoryCubit>().createStory(
                              uid: currentUserId,
                              userProfilePicture: userInfoState
                                  .userInfo.profilePicture
                                  .toString(),
                              userName:
                                  userInfoState.userInfo.userName.toString(),
                              mediaFiles: mediaFiles,
                            );
                      }
                    } else if (userInfoState is UserInfoLoadError) {
                      // Handle errors if needed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(userInfoState.message)),
                      );
                    }
                  }
                },
                child: Text('Select Media'),
              ),
            );
          },
        ),
      ),
    );
  }
}
