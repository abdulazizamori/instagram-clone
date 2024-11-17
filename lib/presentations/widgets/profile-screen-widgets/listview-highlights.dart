import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/main.dart';
import 'package:instaclone/data/models/story-model.dart';

import '../home-screen-widgets/story-detailed-view-screen.dart';


class CustomListViewHighLights extends StatefulWidget {
  final List<StoryModel> userStories; // Assuming this is passed to the widget

  const CustomListViewHighLights({super.key, required this.userStories});

  @override
  State<CustomListViewHighLights> createState() => _CustomListViewHighLightsState();
}

class _CustomListViewHighLightsState extends State<CustomListViewHighLights> {
  @override
  Widget build(BuildContext context) {
    return widget.userStories.isNotEmpty ?SizedBox(
      height: 90.h,
      width: MediaQuery.of(context).size.width.w,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.userStories.length, // Update to reflect the number of stories
        itemBuilder: (context, index) {
          final story = widget.userStories[index]; // Get the current story

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to the StoryViewScreen with the user's stories
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryViewScreen(stories: widget.userStories),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Ensures the container is circular
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: story.userProfilePicture!.isNotEmpty?Image.network(
                          story.userProfilePicture.toString(), // Use the user's profile picture
                          fit: BoxFit.fill, // Ensures the image covers the circular container
                        ):Icon(Icons.person_outline),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h), // Add some space between the image and text
                  Text(story.userName ?? 'User'), // Display the user's name or a default text
                ],
              ),
            ),
          );
        },
      ),
    ):SizedBox();
  }
}
