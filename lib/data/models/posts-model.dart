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
  List<String>? saves;
  bool isSaved; // Add this field



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
    this.saves,
    this.isSaved = false,

  });
  PostModel copyWith({
    String? id,
    bool? isSaved,
    List<String>? likes,
    String? description,
    String? userName,
    String? userImage,
    bool? isVideo,
    List<String>? mediaUrls,
  }) {
    return PostModel(
      uid: id ?? this.uid,
      isSaved: isSaved ?? this.isSaved,
      likes: likes ?? this.likes,
      description: description ?? this.description,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      isVideo: isVideo ?? this.isVideo,
      mediaUrls: mediaUrls ?? this.mediaUrls,
    );
  }

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
      'isSaved': isSaved, // Include in map

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
      isSaved: map['isSaved'] ?? false, // Default to false if not in map

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
