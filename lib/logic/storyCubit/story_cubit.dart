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

  StoryCubit() : super(StoryInitial());

  // Function to create a story
  Future<void> createStory({
    required String uid,
    required bool isVideo,
    List<XFile>? mediaFiles,
  }) async {
    try {
      emit(StoryLoading());

      // Handle media upload (images or videos)
      List<String> mediaUrls = [];
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (XFile file in mediaFiles) {
          String downloadUrl = await _uploadMedia(file);
          mediaUrls.add(downloadUrl);
        }
      }

      // Create the story document in Firestore
      String storyId = _firestore.collection('stories').doc().id;
      StoryModel newStory = StoryModel(
        storyId: storyId,
        uid: uid,
        mediaUrls: mediaUrls,
        createdAt: DateTime.now(),
        isVideo: isVideo,
        viewers: [],
      );

      await _firestore.collection('stories').doc(storyId).set(newStory.toMap());

      emit(StoryCreatedSuccess(newStory));
    } catch (e) {
      emit(StoryError('Failed to create story: $e'));
    }
  }

  // Function to fetch stories of followed users
  Future<void> fetchStories(List<String> following) async {
    try {
      emit(StoryLoading());

      QuerySnapshot snapshot = await _firestore
          .collection('stories')
          .where('uid', whereIn: following) // Get stories from followed users
          .get();

      List<StoryModel> stories = snapshot.docs.map((doc) {
        return StoryModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      emit(StoriesLoaded(stories));
    } catch (e) {
      emit(StoryError('Failed to fetch stories: $e'));
    }
  }

  // Function to add a viewer to a story
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

  // Function to upload media (images/videos) to Firebase Storage
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
}
