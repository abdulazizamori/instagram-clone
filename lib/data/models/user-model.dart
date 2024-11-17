import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? userName;
  String? name;
  String? email;
  String? website;
  String? bio;
  String? gender;
  String? profilePicture;
  String? phone;
  List<String>? followers;
  List<String>? following;
  bool? isVerified;
  DateTime? createdAt;
  DateTime? lastUpdated;
  List<String>? favorites;
  int postsCount;
  int followersCount;
  int followingCount;
  List<String>? participants; // List of active chat IDs
  Map<String, dynamic>? lastMessages; // Last messages by chat ID
  String? fcmToken;


  UserModel({
    this.uid,
    this.userName,
    this.name,
    this.email,
    this.website,
    this.bio,
    this.gender,
    this.profilePicture,
    this.phone,
    this.followers,
    this.following,
    this.isVerified,
    DateTime? createdAt,
    DateTime? lastUpdated,
    this.favorites,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.participants,
    this.fcmToken,
    this.lastMessages,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastUpdated = lastUpdated ?? DateTime.now();

  // Converts UserModel instance to a Map for Firestore
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
      'followersCount': followersCount,
      'followingCount': followingCount,
      'phone': phone,
      'participants': participants,
      'lastMessages': lastMessages,
      'fcmToken': fcmToken,

    };
  }

  // Factory method to create UserModel from Map data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      userName: map['userName'],
      name: map['name'],
      email: map['email'],
      website: map['website'],
      bio: map['bio'],
      gender: map['gender'],
      profilePicture: map['profilePicture'],
      phone: map['phone'],
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      isVerified: map['isVerified'],
      createdAt: map['createdAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : map['createdAt']?.toDate(),
      lastUpdated: map['lastUpdated'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['lastUpdated'])
          : map['lastUpdated']?.toDate(),
      favorites: List<String>.from(map['favorites'] ?? []),
      postsCount: map['postsCount'] ?? 0,
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessages: Map<String, dynamic>.from(map['lastMessages'] ?? {}),
      fcmToken: map['fcmToken'],
    );
  }
}
