class PostModel {
  String? postId;
  String? uid;
  String? description;
  List<String>? mediaUrls; // Images or video URLs
  DateTime? createdAt;
  List<String>? likes; // UIDs of users who liked the post
  List<String>? comments; // List of comment IDs
  bool? isVideo;

  PostModel({
    this.postId,
    this.uid,
    this.description,
    this.mediaUrls,
    this.createdAt,
    this.likes,
    this.comments,
    this.isVideo,
  });

  // Convert to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'description': description,
      'mediaUrls': mediaUrls,
      'createdAt': createdAt?.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'isVideo': isVideo,
    };
  }

  // Create a PostModel from Firestore document
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] ?? '',
      uid: map['uid'] ?? '',
      description: map['description'] ?? '',
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      likes: List<String>.from(map['likes'] ?? []),
      comments: List<String>.from(map['comments'] ?? []),
      isVideo: map['isVideo'] ?? false,
    );
  }
  @override
  String toString() {
    return 'PostModel{postId: $postId, uid: $uid, description: $description, mediaUrls: $mediaUrls, createdAt: $createdAt, likes: $likes, comments: $comments, isVideo: $isVideo}';
  }

}
