class UserModel {
  String? uid; // User ID (matches Firebase Auth UID)
  String? userName; // Username
  String? name; // Full name
  String? email; // Email address
  String? website; // User's website
  String? bio; // User's bio
  String? gender; // User's gender
  String? profilePicture; // URL for the profile picture
  String? phone; // User's phone number
  List<String>? followers; // List of user IDs following this user
  List<String>? following; // List of user IDs this user is following
  bool? isVerified; // Verification status
  DateTime? createdAt; // Account creation timestamp
  DateTime? lastUpdated; // Last profile update timestamp
  List<String>? favorites; // List of post IDs that the user has favorited
  int postsCount; // Number of posts the user has

  UserModel({
    this.uid,
    this.userName,
    this.name,
    this.email,
    this.website,
    this.bio,
    this.gender,
    this.profilePicture,
    this.followers,
    this.following,
    this.isVerified,
    DateTime? createdAt,
    DateTime? lastUpdated,
    this.favorites,
    this.postsCount = 0, // Default value for postsCount
    this.phone,
  })  : createdAt = createdAt ?? DateTime.now(), // Default to now if not provided
        lastUpdated = lastUpdated ?? DateTime.now(); // Default to now if not provided

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'name': name,
      'email': email,
      'website': website,
      'bio': bio,
      'gender': gender,
      'profilePicture': profilePicture,
      'followers': followers,
      'following': following,
      'isVerified': isVerified,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'lastUpdated': lastUpdated?.millisecondsSinceEpoch,
      'favorites': favorites,
      'postsCount': postsCount,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      userName: map['userName'],
      name: map['name'],
      email: map['email'],
      website: map['website'],
      bio: map['bio'],
      gender: map['gender'],
      phone: map['phone'],
      profilePicture: map['profilePicture'],
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      isVerified: map['isVerified'],
      createdAt: map['createdAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : map['createdAt']?.toDate(), // Handle Firestore Timestamp
      lastUpdated: map['lastUpdated'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['lastUpdated'])
          : map['lastUpdated']?.toDate(), // Handle Firestore Timestamp
      favorites: List<String>.from(map['favorites'] ?? []),
      postsCount: map['postsCount'] ?? 0,
    );
  }
}
