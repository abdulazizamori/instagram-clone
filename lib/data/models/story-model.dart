class StoryModel {
  String? storyId;
  String? uid;
  List<String>? mediaUrls; // Images or video URLs
  DateTime? createdAt;
  bool? isVideo; // For identifying if it's a video
  List<String>? viewers; // List of UIDs of users who have seen the story

  StoryModel({
    this.storyId,
    this.uid,
    this.mediaUrls,
    this.createdAt,
    this.isVideo,
    this.viewers,
  });

  // Convert to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'storyId': storyId,
      'uid': uid,
      'mediaUrls': mediaUrls,
      'createdAt': createdAt?.toIso8601String(),
      'isVideo': isVideo,
      'viewers': viewers,
    };
  }

  // Create a StoryModel from Firestore document
  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      storyId: map['storyId'],
      uid: map['uid'],
      mediaUrls: List<String>.from(map['mediaUrls']),
      createdAt: DateTime.parse(map['createdAt']),
      isVideo: map['isVideo'],
      viewers: List<String>.from(map['viewers']),
    );
  }
}
