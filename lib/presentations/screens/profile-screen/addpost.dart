import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../logic/posts-cubit/posts_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? mediaFiles = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width.w,
                height: 300.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final selectedImages = await _picker.pickMultiImage(); // Select multiple images
                        if (selectedImages != null) {
                          setState(() {
                            mediaFiles!.addAll(selectedImages);
                          });
                        }
                      },
                      icon: Icon(Icons.photo),
                      label: Text('Add Images'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final selectedVideo = await _picker.pickVideo(
                          source: ImageSource.gallery,
                        ); // Select a video
                        if (selectedVideo != null) {
                          setState(() {
                            mediaFiles!.add(selectedVideo);
                          });
                        }
                      },
                      icon: Icon(Icons.videocam),
                      label: Text('Add Video'),
                    ),
                  ],
                ),
              ),
              // Display selected media
              mediaFiles!.isNotEmpty
                  ? GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: mediaFiles!.length,
                itemBuilder: (context, index) {
                  if (mediaFiles![index].path.endsWith('.mp4') ||
                      mediaFiles![index].path.endsWith('.mov') ||
                      mediaFiles![index].path.endsWith('.avi')) {
                    // Display video thumbnail using VideoPlayer widget
                    return FutureBuilder(
                      future: _initializeVideoPlayer(mediaFiles![index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: VideoPlayer(snapshot.data as VideoPlayerController),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  } else {
                    // Display image thumbnail
                    return Image.file(
                      File(mediaFiles![index].path),
                      fit: BoxFit.cover,
                    );
                  }
                },
              )
                  : Container(), // Empty container if no media selected

              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              // Submit button to create post
              ElevatedButton(
                onPressed: () async {
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  String description = descriptionController.text;
                  bool isVideo = mediaFiles!.any((file) =>
                  file.path.endsWith('.mp4') ||
                      file.path.endsWith('.mov') ||
                      file.path.endsWith('.avi')); // Check if any file is a video

                  // Fetch the user's username
                  DocumentSnapshot userSnapshot =
                  await _firestore.collection('users').doc(uid).get();
                  String? username = userSnapshot['userName'];
                  String? userImage = userSnapshot['profilePicture'];

                  // Call the createPost function
                  context.read<PostsCubit>().createPost(
                    uid: uid,
                    description: description,
                    isVideo: isVideo,
                    mediaFiles: mediaFiles,
                    userName: username!,
                    userImage: userImage!,
                  );
                },
                child: Text('Create Post'),
              ),
              BlocConsumer<PostsCubit, PostsState>(
                listener: (context, state) {
                  if (state is PostCreatedSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Post created successfully')),
                    );
                    context.read<PostsCubit>().fetchUserPosts(FirebaseAuth.instance.currentUser!.uid);
                  } else if (state is PostsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PostsLoading) {
                    return CircularProgressIndicator(); // Show loading indicator
                  }
                  return SizedBox.shrink(); // No additional UI if there's no error/loading
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<VideoPlayerController> _initializeVideoPlayer(XFile videoFile) async {
    VideoPlayerController controller = VideoPlayerController.file(File(videoFile.path));
    await controller.initialize();
    return controller;
  }
}
