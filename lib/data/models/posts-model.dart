class PostModel {
  String? postId;
  String? uid;
  String? description;
  List<String>? mediaUrls;
  DateTime? createdAt;
  List<String>? likes;
  List<String>? comments;
  bool? isVideo;
  String? userName;
  String? userImage;
  bool likePost;

  PostModel({
    this.postId,
    this.uid,
    this.description,
    this.mediaUrls,
    this.createdAt,
    this.likes,
    this.comments,
    this.isVideo,
    this.userName,
    this.userImage,
    this.likePost = false,
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
      'userName': userName,
      'userImage': userImage,
      'likePost': likePost,
    };
  }

  // Create a PostModel from Firestore document
  factory PostModel.fromMap(Map<String, dynamic> map, {String? currentUserId}) {
    List<String> likesList = List<String>.from(map['likes'] ?? []);
    bool isLikedByUser = likesList.contains(currentUserId);

    return PostModel(
      postId: map['postId'] ?? '',
      uid: map['uid'] ?? '',
      description: map['description'] ?? '',
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      likes: likesList,
      comments: List<String>.from(map['comments'] ?? []),
      isVideo: map['isVideo'] ?? false,
      userName: map['userName'] ?? '',
      userImage: map['userImage'] ?? '',
      likePost: isLikedByUser,
    );
  }

  void toggleLike(String userId) {
    if (likes == null) {
      likes = [];
    }
    if (likePost) {
      likes!.remove(userId);
      likePost = false;
    } else {
      likes!.add(userId);
      likePost = true;
    }
  }
}
