import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import '../../data/models/story-model.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  List<StoryModel> stories = []; // Private list to hold stories


  StoryCubit() : super(StoryInitial());

  // Function to create or update a story
  Future<void> createStory({
    required String uid,
    required String userProfilePicture,
    required String userName,
    List<XFile>? mediaFiles,
  }) async {
    try {
      emit(StoryLoading());

      // Handle media upload and create a list of media URLs
      List<String> mediaUrls = [];
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (XFile file in mediaFiles) {
          String downloadUrl = await _uploadMedia(file);
          mediaUrls.add(downloadUrl); // Collect URLs
        }
      }

      // Check if a story already exists for this user
      QuerySnapshot existingStorySnapshot = await _firestore
          .collection('stories')
          .where('uid', isEqualTo: uid)
          .get();

      if (existingStorySnapshot.docs.isNotEmpty) {
        // Update existing story
        String storyId = existingStorySnapshot.docs.first.id;
        StoryModel existingStory = StoryModel.fromMap(existingStorySnapshot.docs.first.data() as Map<String, dynamic>);

        // Append new media URLs and update the document
        existingStory.mediaUrls!.addAll(mediaUrls);

        await _firestore.collection('stories').doc(storyId).update(existingStory.toMap());
        emit(StoryCreatedSuccess(existingStory)); // Pass the updated story
      } else {
        // Create a new story
        String storyId = _firestore.collection('stories').doc().id;
        StoryModel newStory = StoryModel(
          storyId: storyId,
          uid: uid,
          userProfilePicture: userProfilePicture,
          userName: userName,
          mediaUrls: mediaUrls,
          createdAt: DateTime.now(),
          isVideo: mediaFiles!.any((file) => file.mimeType?.startsWith('video') ?? false),
          viewers: [],
        );

        await _firestore.collection('stories').doc(storyId).set(newStory.toMap());
        emit(StoryCreatedSuccess(newStory)); // Pass the new story
      }
    } catch (e) {
      emit(StoryError('Failed to create story: $e'));
    }
  }

  // Add this method to your StoryCubit class
  Future<void> addImagesToStory(String storyId, List<String> newMediaUrls) async {
    try {
      emit(StoryLoading());

      // Fetch the existing story
      DocumentSnapshot storySnapshot = await _firestore.collection('stories').doc(storyId).get();

      if (storySnapshot.exists) {
        // Update existing story's media URLs
        StoryModel existingStory = StoryModel.fromMap(storySnapshot.data() as Map<String, dynamic>);

        // Append new media URLs
        existingStory.mediaUrls!.addAll(newMediaUrls);

        // Update the Firestore document
        await _firestore.collection('stories').doc(storyId).update(existingStory.toMap());

        emit(StoryCreatedSuccess(existingStory)); // Emit the updated story
      } else {
        emit(StoryError('Story not found.'));
      }
    } catch (e) {
      emit(StoryError('Failed to add images to story: $e'));
    }
  }


  // Fetch stories of followed users
  Future<void> fetchStories(List<String> following) async {
    try {
      emit(StoryLoading());

      QuerySnapshot snapshot = await _firestore
          .collection('stories')
          .where('uid', whereIn: following)
          .get();

      List<StoryModel> stories = snapshot.docs.map((doc) {
        return StoryModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      emit(StoriesLoaded(stories));
    } catch (e) {
      emit(StoryError('Failed to fetch stories: $e'));
    }
  }

  // Fetch all available stories
  // Fetch all available stories and filter by creation time
  Future<void> fetchAllStories() async {
    try {
      emit(StoryLoading());

      QuerySnapshot snapshot = await _firestore.collection('stories').get();

      // Get current time
      DateTime now = DateTime.now();

      // Filter stories created within the last 24 hours
      List<StoryModel> stories = snapshot.docs.map((doc) {
        StoryModel story = StoryModel.fromMap(doc.data() as Map<String, dynamic>);
        // Check if the story was created within the last 24 hours
        if (story.createdAt != null && now.difference(story.createdAt!).inHours < 24) {
          return story;
        }
        return null; // Exclude this story
      }).where((story) => story != null).cast<StoryModel>().toList(); // Remove null values

      emit(StoriesLoaded(stories));
    } catch (e) {
      emit(StoryError('Failed to fetch stories: $e'));
    }
  }


  // Add viewer to a story
  Future<void> addViewer(String storyId, String userId) async {
    try {
      DocumentReference storyRef = _firestore.collection('stories').doc(storyId);
      await storyRef.update({
        'viewers': FieldValue.arrayUnion([userId]),
      });
      emit(StoryViewedSuccess());
    } catch (e) {
      emit(StoryError('Failed to add viewer: $e'));
    }
  }

  // Upload media to Firebase Storage
  Future<String> _uploadMedia(XFile file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child("stories/$fileName");
      UploadTask uploadTask = storageRef.putFile(File(file.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }

  // Pick multiple media files
  Future<List<XFile>?> pickMediaFiles() async {
    try {
      return await _picker.pickMultiImage(); // Use pickMultiImage to select multiple images
    } catch (e) {
      emit(StoryError('Failed to pick media: $e'));
      return null; // Return null if picking fails
    }
  }
}
