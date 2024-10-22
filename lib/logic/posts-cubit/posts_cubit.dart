import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:meta/meta.dart';

import '../../data/models/posts-model.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  PostsCubit() : super(PostsInitial());

  // Function to create a post
  Future<void> createPost({
    required String uid,
    required String description,
    required bool isVideo,
    List<XFile>? mediaFiles,
  }) async {
    try {
      emit(PostsLoading());

      // Handle media upload (images or videos)
      List<String> mediaUrls = [];
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (XFile file in mediaFiles) {
          String downloadUrl = await _uploadMedia(file);
          mediaUrls.add(downloadUrl);
        }
      }

      // Create the post document in Firestore under the user's subcollection
      String postId = _firestore.collection('users').doc(uid).collection('userPosts').doc().id;
      PostModel newPost = PostModel(
        postId: postId,
        uid: uid,
        description: description,
        mediaUrls: mediaUrls,
        createdAt: DateTime.now(),
        likes: [],
        comments: [],
        isVideo: isVideo,
      );

      // Add the new post to Firestore
      await _firestore.collection('users').doc(uid).collection('userPosts').doc(postId).set(newPost.toMap());

      emit(PostCreatedSuccess(newPost));
    } catch (error) {
      emit(PostsError(error.toString())); // Emit error state on failure
    }
  }



  // Function to like a post
  Future<void> likePost(String postId, String userId) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      await postRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
      emit(PostLikedSuccess());
    } catch (e) {
      emit(PostsError('Failed to like post: $e'));
    }
  }

  // Function to fetch all posts
  Future<void> fetchPosts() async {
    try {
      emit(PostsLoading());

      QuerySnapshot snapshot = await _firestore.collection('posts').get();
      List<PostModel> posts = snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError('Failed to fetch posts: $e'));
    }
  }

  // Function to upload media (images/videos) to Firebase Storage
  Future<String> _uploadMedia(XFile file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child("posts/$fileName");
      UploadTask uploadTask = storageRef.putFile(File(file.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }


  // Function to fetch user posts
  Future<void> fetchUserPosts(String userId) async {
    emit(PostsLoading());
    try {
      // Query posts made by the current user from the subcollection
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('userPosts')
          .orderBy('createdAt', descending: true)
          .get();

      // Check if any documents are returned
      print("Number of posts fetched: ${snapshot.docs.length}");
      snapshot.docs.forEach((doc) {
        print("Post data: ${doc.data()}");
      });

      // Convert snapshot data into a list of PostModel
      List<PostModel> userPosts = snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      emit(PostsLoaded(userPosts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }





  // Fetch all posts for the explore screen or global feed
  Future<List<PostModel>> fetchAllPosts() async {
    emit(PostsLoading());
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true) // Optional: Order by date
          .get();

      List<PostModel> posts = snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return posts;
    } catch (e) {
      emit(PostsError(e.toString()));
      return [];
    }
  }

// Fetch posts from users that the current user follows
  Future<List<PostModel>> fetchFollowedUsersPosts(String currentUserId) async {
    emit(PostsLoading());
    try {
      // Fetch the current user's "following" list
      DocumentSnapshot currentUserSnapshot =
      await _firestore.collection('users').doc(currentUserId).get();
      List<String> following = List<String>.from(currentUserSnapshot['following']);

      // Query posts from followed users
      QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .where('userId', whereIn: following) // Filter by followed user IDs
          .orderBy('createdAt', descending: true) // Optional: Order by date
          .get();

      List<PostModel> posts = snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return posts;
    } catch (e) {
      emit(PostsError(e.toString()));
      return [];
    }
  }

  // Fetch only video posts for the Instagram video screen
  Future<List<PostModel>> fetchVideoPosts() async {
    emit(PostsLoading());
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .where('mediaType', isEqualTo: 'video') // Filter by video media type
          .orderBy('createdAt', descending: true)
          .get();

      List<PostModel> posts = snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return posts;
    } catch (e) {
      emit(PostsError(e.toString()));
      return [];
    }
  }

  // Add post to favorites
  Future<void> addPostToFavorites(String postId, String userId) async {
    emit(PostsLoading());
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayUnion([postId]),
      });

      emit(PostFavorited());
    } catch (e) {
      emit(PostsError('Failed to add post to favorites: $e'));
    }
  }

  // Fetch favorite posts for the favorite screen
  Future<void> fetchFavoritePosts(String userId) async {
    emit(PostsLoading());
    try {
      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(userId).get();
      List<String> favoritePostIds = List<String>.from(userSnapshot['favorites']);

      if (favoritePostIds.isEmpty) {
        emit(PostsLoaded([])); // No favorites, return empty list
        return;
      }

      QuerySnapshot postSnapshot = await _firestore
          .collection('posts')
          .where(FieldPath.documentId, whereIn: favoritePostIds)
          .get();

      List<PostModel> posts = postSnapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError('Failed to fetch favorite posts: $e'));
    }
  }


}
