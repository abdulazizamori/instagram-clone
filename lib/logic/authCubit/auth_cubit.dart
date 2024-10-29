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
