import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/data/sharedprefrence/cache.dart';
import 'package:meta/meta.dart';
import '../../data/models/user-model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? errorMessage;
  bool verified = false;
  String? _downloadUrl;
  String? get downloadUrl => _downloadUrl;
  final ImagePicker picker = ImagePicker();
  String? uploadedImageUrl;
  var cache = CacheHelper();
  UserModel? userModel;

  // Function to pick a single image for profile picture
  Future<void> pickImage() async {
    try {
      // Use pickImage instead of pickMultiImage to select only one image
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        emit(ImageSelected(image)); // Emit state with the selected image
        await uploadImage(image); // Upload the selected image and update the profile picture
      }
    } catch (e) {
      emit(ImageSelectionError(e.toString())); // Emit error state on failure
    }
  }


// Function to upload the selected profile picture
  Future<String?> uploadImage(XFile image) async {
    try {
      emit(UploadLoading()); // Emit loading state
      File imageFile = File(image.path);

      // Define storage reference path
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child("ProfilePictures/$fileName");

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update the user's profile picture URL in Firestore
      final String userId = FirebaseAuth.instance.currentUser!.uid; // Get current user ID
      await _firestore.collection('users').doc(userId).update({
        'profilePicture': downloadUrl, // Update the profilePicture field
      });

      emit(UploadSuccess(downloadUrl)); // Emit success with the download URL
      return downloadUrl; // Return the download URL

    } catch (e) {
      emit(UploadError(e.toString())); // Emit error state with the error message
      return null;
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword(
      String? email, String? password, String? userName) async {
    try {
      emit(AuthLoading());
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      UserModel newUser = UserModel(
        uid: userCredential.user?.uid,
        userName: userName,
        email: email,
        name: '',
        website: '',
        bio: '',
        gender: '',
        profilePicture: '',
        followers: [],
        following: [],
        isVerified: false,
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
        favorites: [],
        postsCount: 0,
        participants: []

      );

      await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());

      emit(UserCreateSuccess());
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      emit(UserCreateError(e.toString()));
    } catch (e) {
      errorMessage = e.toString();
      emit(AuthError(e.toString()));
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword(String? email, String? password) async {
    try {
      emit(AuthLoading());
      await _auth.signInWithEmailAndPassword(email: email!, password: password!);
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      String token = doc.get('uid') as String;
      await cache.setData(key: 'auth_token', value: token);

      emit(AuthSuccess(token));
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      emit(AuthError(e.toString()));
    }
  }

  /// Check if user is logged in
  Future<void> checkAuthStatus() async {
    String? token = cache.getData(key: 'auth_token');
    if (token != null) {
      emit(AuthSuccess(token));
    } else {
      emit(AuthInitial());
    }
  }

  // /// Update user profile fields
  // Future<void> updateCurrentUser(String field, String value) async {
  //   try {
  //     emit(AuthLoading());
  //     User? currentUser = _auth.currentUser;
  //     if (currentUser != null) {
  //       await _firestore.collection('users').doc(currentUser.uid).update({
  //         field: value,
  //       });
  //       emit(AuthSuccess("User information updated successfully"));
  //     } else {
  //       emit(AuthError('No user is signed in'));
  //     }
  //   } catch (e) {
  //     emit(AuthError('Error updating user information: $e'));
  //   }
  // }



  /// Update user profile fields
  Future<void> updateUserProfile({
    required String name,
    required String userName,
    required String website,
    required String bio,
    required String email,
    required String gender,
    required String phone,
  }) async {
    try {
      emit(AuthLoading());

      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        Map<String, dynamic> updatedData = {
          'name': name,
          'userName': userName,
          'website': website,
          'bio': bio,
          'email': email,
          'gender': gender,
          'phone':phone,
          'lastUpdated': DateTime.now(),

        };

        // Update the user document in Firestore
        await _firestore.collection('users').doc(currentUser.uid).update(updatedData);

        emit(AuthSuccess("User profile updated successfully"));
      } else {
        emit(AuthError('No user is signed in'));
      }
    } catch (e) {
      emit(AuthError('Error updating user profile: $e'));
    }
  }




  /// Sign out
  Future<void> signOut() async {
    await cache.deleteData(key: 'auth_token');
    emit(SignOut());
  }

  /// Fetch current user information
  Future<void> fetchUserInfo() async {
    emit(UserInfoLoading()); // Emit loading state
    final String? userId = _auth.currentUser?.uid; // Get current user ID

    if (userId == null) {
      emit(UserInfoLoadError("User is not logged in."));
      print("User is not logged in."); // Log message
      return;
    }

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        emit(UserInfoLoadError("User document not found for ID: $userId.")); // Log message
        print("User document not found for ID: $userId."); // Log message
        return;
      }

      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData == null) {
        emit(UserInfoLoadError("User data is empty."));
        print("User data is empty for ID: $userId."); // Log message
        return;
      }

      UserModel userInfo = UserModel.fromMap(userData);
      emit(UserInfoLoaded(userInfo)); // Emit loaded state
      print("User info loaded successfully for ID: $userId."); // Log message
    } catch (error) {
      emit(UserInfoLoadError("Error fetching user info: ${error.toString()}"));
      print("Error fetching user info: ${error.toString()}"); // Log message
    }
  }
  /// Fetch all users from the 'users' collection
  Future<void> fetchAllUsers() async {
    emit(FetchUsersLoading()); // Emit loading state

    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Query all users except the current user
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isNotEqualTo: currentUserId) // Exclude current user
          .get();

      List<UserModel> users = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      emit(FetchUsersSuccess(users)); // Emit success state with users list
    } catch (e) {
      emit(FetchUsersError('Failed to fetch users: ${e.toString()}')); // Emit error state
    }
  }


  /// Update user profile fields
  // Future<void> updateUserProfile({
  //   required String name,
  //   required String userName,
  //   required String website,
  //   required String bio,
  //   required String email,
  //   required String gender,
  //   required String phone,
  // }) async {
  //   try {
  //     emit(AuthLoading());
  //
  //     User? currentUser = _auth.currentUser;
  //     if (currentUser != null) {
  //       Map<String, dynamic> updatedData = {
  //         'name': name,
  //         'userName': userName,
  //         'website': website,
  //         'bio': bio,
  //         'email': email,
  //         'gender': gender,
  //         'phone': phone,
  //         'lastUpdated': DateTime.now(),
  //       };
  //
  //       // Update the user document in Firestore
  //       await _firestore.collection('users').doc(currentUser.uid).update(updatedData);
  //
  //       emit(AuthSuccess("User profile updated successfully"));
  //     } else {
  //       emit(AuthError('No user is signed in'));
  //     }
  //   } catch (e) {
  //     emit(AuthError('Error updating user profile: $e'));
  //   }
  // }

// Function to follow a user and update followers/following counts
  Future<void> followUser(String targetUserId) async {
    final currentUserId = _auth.currentUser?.uid;

    if (currentUserId == null) {
      emit(AuthError("User not logged in."));
      return;
    }

    try {
      emit(AuthLoading());

      final currentUserRef = _firestore.collection('users').doc(currentUserId);
      final targetUserRef = _firestore.collection('users').doc(targetUserId);

      // Start a batch write operation to ensure consistency
      await _firestore.runTransaction((transaction) async {
        // Fetch current user and target user data
        final currentUserDoc = await transaction.get(currentUserRef);
        final targetUserDoc = await transaction.get(targetUserRef);

        // Update current user's following list
        final currentUserData = currentUserDoc.data() as Map<String, dynamic>;
        final following = List<String>.from(currentUserData['following'] ?? []);
        int followingCount = currentUserData['followingCount'] ?? 0; // Get initial following count

        if (!following.contains(targetUserId)) {
          following.add(targetUserId);
          transaction.update(currentUserRef, {
            'following': following,
            'followingCount': followingCount + 1 // Increment following count
          });
        }

        // Update target user's followers list
        final targetUserData = targetUserDoc.data() as Map<String, dynamic>;
        final followers = List<String>.from(targetUserData['followers'] ?? []);
        int followersCount = targetUserData['followersCount'] ?? 0; // Get initial followers count

        if (!followers.contains(currentUserId)) {
          followers.add(currentUserId);
          transaction.update(targetUserRef, {
            'followers': followers,
            'followersCount': followersCount + 1 // Increment followers count
          });
        }
      });

      // Update local user model
      userModel!.following ??= [];
      if (!userModel!.following!.contains(targetUserId)) {
        userModel!.following!.add(targetUserId);
      }

      emit(FollowUserSuccess(targetUserId, userModel!.following!.length)); // Emit with updated following count
      emit(UserUpdated(userModel!)); // Emit updated state
    } catch (e) {
      emit(AuthError("Failed to follow user: $e"));
    }
  }

// Function to unfollow a user and update followers/following counts
  Future<void> unfollowUser(String targetUserId) async {
    final currentUserId = _auth.currentUser?.uid;

    if (currentUserId == null) {
      emit(AuthError("User not logged in."));
      return;
    }

    try {
      emit(AuthLoading());

      final currentUserRef = _firestore.collection('users').doc(currentUserId);
      final targetUserRef = _firestore.collection('users').doc(targetUserId);

      // Start a batch write operation to ensure consistency
      await _firestore.runTransaction((transaction) async {
        // Fetch current user and target user data
        final currentUserDoc = await transaction.get(currentUserRef);
        final targetUserDoc = await transaction.get(targetUserRef);

        // Update current user's following list
        final currentUserData = currentUserDoc.data() as Map<String, dynamic>;
        final following = List<String>.from(currentUserData['following'] ?? []);
        int followingCount = currentUserData['followingCount'] ?? 0; // Get initial following count

        if (following.contains(targetUserId)) {
          following.remove(targetUserId);
          transaction.update(currentUserRef, {
            'following': following,
            'followingCount': followingCount - 1 // Decrement following count
          });
        }

        // Update target user's followers list
        final targetUserData = targetUserDoc.data() as Map<String, dynamic>;
        final followers = List<String>.from(targetUserData['followers'] ?? []);
        int followersCount = targetUserData['followersCount'] ?? 0; // Get initial followers count

        if (followers.contains(currentUserId)) {
          followers.remove(currentUserId);
          transaction.update(targetUserRef, {
            'followers': followers,
            'followersCount': followersCount - 1 // Decrement followers count
          });
        }
      });

      // Update local user model
      userModel!.following?.remove(targetUserId);
      emit(UnfollowUserSuccess(targetUserId, userModel!.following!.length)); // Emit with updated following count
      emit(UserUpdated(userModel!)); // Emit updated state
    } catch (e) {
      emit(AuthError("Failed to unfollow user: $e"));
    }
  }


  /// Function to fetch a user's information by UID
  Future<void> fetchUser(String userId) async {
    emit(FetchUserLoading());

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        // Assuming UserModel has a factory constructor to convert from Map
        final user = UserModel.fromMap(userDoc.data()!);
        emit(FetchUserSuccess(user));
      } else {
        emit(FetchUserError("User not found."));
      }
    } catch (e) {
      emit(FetchUserError("Failed to fetch user: $e"));
    }
  }


  Future<void> searchUsers(String query) async {
    emit(FetchUsersLoading());
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('userName', isGreaterThanOrEqualTo: query)
          .where('userName', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      List<UserModel> users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      emit(FetchUsersSuccess(users));
    } catch (e) {
      emit(FetchUsersError(e.toString()));
    }
  }


  Future<void> fetchUserPostsCount(String userId) async {
    emit(UserInfoLoading()); // Emit loading state

    try {
      // Query Firestore for posts by the user
      QuerySnapshot postSnapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();

      int postsCount = postSnapshot.docs.length; // Count the number of posts

      // You could add this to the UserModel if you'd like to store the post count there:
      // emit a state containing this value if needed
      emit(UserInfoPostsCountLoaded(postsCount)); // Emit loaded state with post count
    } catch (error) {
      emit(UserInfoLoadError(
          "Error fetching post count: ${error.toString()}")); // Emit error state
    }
  }


}
