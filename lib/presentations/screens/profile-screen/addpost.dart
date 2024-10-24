import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../logic/posts-cubit/posts_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? mediaFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width.w,
              height: 300.h,
              child: IconButton(
                onPressed: () async {
                  final selectedFiles = await _picker.pickMultiImage(); // Select multiple images
                  if (selectedFiles != null) {
                    setState(() {
                      mediaFiles!.addAll(selectedFiles); // Add new files to the existing list
                    });
                  }
                },
                icon: Icon(Icons.add_a_photo),
              ),
            ),
            // Display selected images
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
                return Image.file(
                  File(mediaFiles![index].path),
                  fit: BoxFit.cover,
                );
              },
            )
                : Container(), // Empty container if no images selected

            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            // Submit button to create post
            ElevatedButton(
              onPressed: () {
                String uid = FirebaseAuth.instance.currentUser!.uid;
                String description = descriptionController.text;
                bool isVideo = false; // Set this based on user selection if needed

                // Call the createPost function
                context.read<PostsCubit>().createPost(
                  uid: uid,
                  description: description,
                  isVideo: isVideo,
                  mediaFiles: mediaFiles,
                );
              },
              child: Text('Create Post'),
            ),
            BlocConsumer<PostsCubit, PostsState>(
              listener: (context, state) {
                if (state is PostCreatedSuccess) {
                  Navigator.pushReplacementNamed(context, 'profileScreen'); // Change '/profile' to your profile route
                } else if (state is PostsError) {
                  // Handle error state
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
    );
  }
}
