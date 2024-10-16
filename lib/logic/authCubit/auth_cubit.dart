import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

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



  Future<String?> uploadImage(XFile image) async {
    try {
      emit(UploadLoading()); // Emit loading state
      File imageFile = File(image.path);

      // Define storage reference path
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child("images/$fileName");

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      uploadedImageUrl = downloadUrl; // Store the URL
      emit(UploadSuccess(downloadUrl)); // Emit success with the download URL
      return downloadUrl;

      // Return the download URL for further use
    } catch (e) {
      emit(UploadError(e.toString())); // Emit error state with the error message
      return null;
    }
  }


  Future<void> signUpWithEmailAndPassword(String? email, String? password, String? name) async {
    try {
      emit(AuthLoading());
      // Sign up the user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );


      // Create a User instance
      UserModel newUser = UserModel(
          uid: userCredential.user?.uid,
          name: name, // Pass this name as an argument
          email: email,

      );

      // Store additional user info in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.uid) // Use the uid as the document ID
          .set(newUser.toMap()) // Use the toMap() method to convert the User to a Map
          .then((_) {
        emit(UserCreateSuccess());
      })
          .catchError((e) {
        throw Exception("Failed to save user data: $e");
      });
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      emit(UserCreateError(e.toString()));
    } catch (e) {
      errorMessage = e.toString();
      emit(AuthError(e.toString()));
    }
  }



  Future<void> signInWithEmailAndPassword(String? email, String? password) async {
    try {
      emit(AuthLoading());
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('vendors').doc(FirebaseAuth.instance.currentUser!.uid).get();

      String token = doc.get('uid') as String;

      // Save the token using SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      print('=============>$token');
      emit(AuthSuccess(token));
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      emit(AuthError(e.toString()));
    }
  }

  /// Check login status from cache
  Future<void> checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null) {
      emit(AuthSuccess(token)); // User is already authenticated
    } else {
      emit(AuthInitial()); // No token found, back to initial state
    }
  }

  Future<void> updateCurrentUser(String field,String value) async {
    try {
      emit(AuthLoading());
      // Get current user
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        // Update Firestore document in 'users' collection
        await _firestore.collection('vendors').doc(uid).update({
          '$field': value,
        });

        print('========>>>>>>$field');
        print('========>>>>>>$value');


        emit(AuthSuccess("User information updated successfully"));
      } else {
        emit(AuthError('No user is signed in'));
      }
    } catch (e) {
      emit(AuthError('Error updating user information: $e'));
    }
  }


  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('user token:${prefs.get('auth_token')}');
    await prefs.remove('auth_token');
    print(prefs.get('auth_token'));
    print('User logged out'); // Debug statement
    emit(SignOut());
  }

  Future<void> fetchUserInfo() async {
    emit(UserInfoLoading()); // Emit loading state
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    // Check if userId is null
    if (userId == null) {
      emit(UserInfoLoadError("User is not logged in.")); // Handle the error
      return;
    }

    try {
      // Fetch the user's document from the 'vendors' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(userId) // Get the document for the current user
          .get();

      // Check if the user document exists
      if (!userDoc.exists) {
        emit(UserInfoLoadError("User document not found.")); // Handle the error
        return;
      }

      // Access the user data and cast it to a Map
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      // Check if userData is null
      if (userData == null) {
        emit(UserInfoLoadError("User data is empty.")); // Handle the error
        return;
      }

      // Create a UserModel from the userData
      UserModel userInfo = UserModel.fromMap(userData);

      // Emit loaded state with user info
      emit(UserInfoLoaded(userInfo));
    } catch (error) {
      emit(UserInfoLoadError("Error fetching user info: ${error.toString()}")); // Emit error state
    }
  }

  Future<void> updateUserInfo(UserModel user) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    user.uid = userId;

    try {
      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(userId)
          .update(user.toMap());

      emit(UserInfoUpdated());
      await fetchUserInfo(); // Fetch updated products list
    } catch (error) {
      emit(UserInfoLoadError(error.toString()));
    }
  }
}
