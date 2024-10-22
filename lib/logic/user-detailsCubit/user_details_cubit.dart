import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../data/models/user-model.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;





  Future<void> fetchUserInfo() async {
    emit(UserInfoLoading()); // Emit loading state
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    // Check if userId is null
    if (userId == null) {
      emit(UserInfoLoadError("User is not logged in.")); // Handle the error
      return;
    }

    try {
      // Fetch the user's document from the 'users' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
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

  Future<void> updateCurrentUser(String field,String value) async {
    try {
      emit(AuthLoading());
      // Get current user
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        // Update Firestore document in 'users' collection
        await _firestore.collection('users').doc(uid).update({
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

}
