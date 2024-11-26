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
  // Function to create a post
  Future<void> createPost({
    required String uid,
    required String description,
    required bool isVideo,
    List<XFile>? mediaFiles,
    required String userName,
    required String userImage,
  }) async {
    try {
      emit(PostsLoading());

      // Handle media upload
      List<String> mediaUrls = [];
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (XFile file in mediaFiles) {
          String downloadUrl = await _uploadMedia(file);
          mediaUrls.add(downloadUrl);
        }
      }

      // Create the post document
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
        userName: userName,
        userImage: userImage,
      );

      // Add the new post to the user's subcollection
      await _firestore.collection('users').doc(uid).collection('userPosts').doc(postId).set(newPost.toMap());

      // Add the new post to the main 'posts' collection
      await _firestore.collection('posts').doc(postId).set(newPost.toMap());

      // Increment the postsCount in the user's main document
      await _firestore.collection('users').doc(uid).update({
        'postsCount': FieldValue.increment(1),
      });

      emit(PostCreatedSuccess(newPost));
    } catch (error) {
      emit(PostsError(error.toString())); // Emit error state on failure
    }
  }

  // Function to like/unlike a post with instant UI update
  Future<void> toggleLikePost(PostModel post, String userId) async {
    try {
      // Check if the post is currently liked by the user
      final isLiked = post.likes!.contains(userId);

      // Update the local post model by toggling the like status
      if (isLiked) {
        post.likes!.remove(userId); // Remove user ID from likes
      } else {
        post.likes!.add(userId); // Add user ID to likes
      }

      // Reference to the Firestore document for the main posts collection
      DocumentReference postRef = _firestore.collection('posts').doc(post.postId);

      // Reference to the Firestore document in the user's subcollection
      DocumentReference userPostRef = _firestore
          .collection('users')
          .doc(post.uid) // Assuming each post has a userId field
          .collection('userPosts')
          .doc(post.postId);

      // Update the Firestore document accordingly in both collections
      if (isLiked) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([userId]), // Remove like from main posts collection
        });
        await userPostRef.update({
          'likes': FieldValue.arrayRemove([userId]), // Remove like from userPosts subcollection
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([userId]), // Add like to main posts collection
        });
        await userPostRef.update({
          'likes': FieldValue.arrayUnion([userId]), // Add like to userPosts subcollection
        });
      }

    } catch (e) {
      // Emit an error state if there's an issue
      emit(PostsError('Failed to toggle like: $e'));
    }
  }


// Add this function inside your PostsCubit

  Future<void> toggleFavoritePost(PostModel post) async {
    try {
      // Get the currently logged-in user ID
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the logged-in user's favorites collection
      final userRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);
      final favoritesRef = userRef.collection('favorites');

      // Check if the post is already saved
      final docSnapshot = await favoritesRef.doc(post.postId).get();
      bool isCurrentlySaved = docSnapshot.exists;

      if (isCurrentlySaved) {
        // Post is already in favorites, remove it
        await favoritesRef.doc(post.postId).delete();
        print("Post removed from favorites");
      } else {
        // Post is not in favorites, add it
        await favoritesRef.doc(post.postId).set({
          'postId': post.postId,
          'ownerId': post.uid, // ID of the post owner
          'mediaUrls': post.mediaUrls,
          'createdAt': FieldValue.serverTimestamp(), // Store server timestamp
        });
        print("Post added to favorites");
      }

      // Toggle the 'isSaved' status locally in the post
      post.isSaved = !isCurrentlySaved;
    } catch (e) {
      print("Error toggling favorite post: $e");
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
  Future<void> fetchAllPosts() async {
    emit(PostsLoading());
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true) // Order by date
          .get();

      List<PostModel> posts = snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      emit(PostsLoaded(posts)); // Emit loaded state with posts
    } catch (e) {
      emit(PostsError(e.toString())); // Emit error state on failure
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


// Function to fetch favorite posts for the current user
  Future<List<PostModel>> fetchFavoritePosts(String userId) async {
    try {
      // Fetch the documents from the user's posts collection
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .orderBy('createdAt', descending: true)
          .get();

      // Map the fetched documents to a list of PostModel instances
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) return PostModel();  // Return a default PostModel if data is null

        return PostModel(
          postId: data['postId'] ?? '',  // Default to empty string if null
          uid: data['userId'] ?? '',     // Default to empty string if null
          mediaUrls: List<String>.from(data['mediaUrls'] ?? []),  // Handle null mediaUrls
          createdAt: data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()  // Convert Timestamp to DateTime if not null
              : null,
        );
      }).toList();
    } catch (e) {
      print("Error fetching favorite posts: $e");
      return [];  // Return an empty list on error
    }
  }




}




