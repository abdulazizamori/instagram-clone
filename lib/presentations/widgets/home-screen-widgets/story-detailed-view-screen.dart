import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/main.dart';
import 'package:story_view/story_view.dart';
import '../../../data/models/story-model.dart';

class StoryViewScreen extends StatefulWidget {
  final List<StoryModel> stories;

  const StoryViewScreen({Key? key, required this.stories}) : super(key: key);

  @override
  _StoryViewScreenState createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  final StoryController controller = StoryController();

  // Method to format the elapsed time since story creation
  String formatDuration(DateTime createdAt) {
    final Duration duration = DateTime.now().difference(createdAt);

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    String timeString = '';
    if (hours > 0) {
      timeString += '$hours hour${hours > 1 ? 's' : ''} ';
    }
    if (minutes > 0) {
      timeString += '$minutes minute${minutes > 1 ? 's' : ''}';
    }
    return timeString.trim().isEmpty ? 'Just now' : timeString.trim();
  }

  @override
  Widget build(BuildContext context) {
    // Convert stories to StoryItem
    final storyItems = widget.stories.expand((story) {
      // Map each media URL to a StoryItem
      if (story.mediaUrls != null && story.mediaUrls!.isNotEmpty) {
        return story.mediaUrls!.map((url) {
          return story.isVideo == true
              ? StoryItem.pageVideo(
                  url,
                  controller: controller,
                  duration:
                      const Duration(seconds: 5), // Set duration for video
                )
              : StoryItem.pageImage(
                  url: url,
                  caption: Text(story.captions.toString() ?? ''),
                  // Assuming caption is a String in StoryModel
                  controller: controller,
                );
        });
      } else {
        return [
          StoryItem.pageImage(
            url: 'https://via.placeholder.com/150', // Placeholder image
            caption: Text("No image available"), // Default caption
            controller: controller,
          )
        ];
      }
    }).toList();

    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          // Detect downward swipe
          if (details.delta.dy > 0) {
            Navigator.pop(context); // Close the story view
          }
        },
        child: Stack(
          children: [
            StoryView(
              storyItems: storyItems,
              controller: controller,
              onStoryShow: (storyItem, index) {
                // Handle the story show event with the StoryItem and its index
                print("Showing story: $storyItem at index: $index");
              },
              onComplete: () {
                Navigator.pushReplacementNamed(context,
                    'mainScreen'); // Close the story view when complete
              },
              progressPosition: ProgressPosition.top,
              // Inline indicator at the bottom
              repeat: false,
              // Stories do not repeat
              inline: true, // Inline story view
            ),
            Positioned(
              top: 50, // Adjust the position as needed
              left: 10, // Adjust the position as needed
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: widget.stories.first.userProfilePicture!.isNotEmpty?Image.network(
                          widget.stories.first.userProfilePicture.toString(),
                          width: 40, // Set the width of the profile picture
                          height: 40, // Set the height of the profile picture
                          fit: BoxFit
                              .cover, // Ensure the image covers the circular area
                        ):Icon(Icons.person_outline,color: Colors.white,),

                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.stories.first.userName.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          // Adjust the text color for visibility
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 30.w),
                      Text(
                        formatDuration(
                            widget.stories.first.createdAt ?? DateTime.now()),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
