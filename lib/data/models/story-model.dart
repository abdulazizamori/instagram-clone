class StoryModel {
  String? storyId;
  String? uid;
  String? userProfilePicture; // User's profile picture URL
  String? userName; // User's name who created the story
  List<String>? mediaUrls; // URLs of media in the story (images/videos)
  List<String>? captions; // Captions for the media items
  DateTime? createdAt; // Timestamp of story creation
  bool? isVideo; // Flag to determine if the story is a video
  List<String>? viewers; // List of users who have viewed the story

  StoryModel({
    this.storyId,
    this.uid,
    this.userProfilePicture,
    this.userName,
    this.mediaUrls,
    this.captions, // Add captions field
    this.createdAt,
    this.isVideo,
    this.viewers,
  });

  // Converts the StoryModel instance to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'storyId': storyId,
      'uid': uid,
      'userProfilePicture': userProfilePicture,
      'userName': userName,
      'mediaUrls': mediaUrls,
      'captions': captions, // Include captions in the map
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'isVideo': isVideo,
      'viewers': viewers,
    };
  }

  // Creates a StoryModel instance from a Map
  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      storyId: map['storyId'],
      uid: map['uid'],
      userProfilePicture: map['userProfilePicture'],
      userName: map['userName'],
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      captions: List<String>.from(map['captions'] ?? []), // Include captions in fromMap
      createdAt: map['createdAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : map['createdAt']?.toDate(),
      isVideo: map['isVideo'],
      viewers: List<String>.from(map['viewers'] ?? []),
    );
  }
}
