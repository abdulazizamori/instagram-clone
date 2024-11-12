import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import '../../data/models/message-model.dart';
import '../../data/models/user-model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  StreamSubscription? _messageSubscription;



  Future<void> getChatParticipants(String currentUserId) async {
    try {
      emit(ChatParticipantsLoading());  // Emit loading state

      final participants = await fetchChatParticipants(currentUserId);

      emit(ChatParticipantsLoaded(participants)); // Emit loaded state with users
    } catch (e) {
      emit(ChatError("Error fetching chat participants: $e"));
    }
  }

// This method should fetch participants and return a list of UserModel
  Future<List<UserModel>> fetchChatParticipants(String currentUserId) async {
    try {
      // Fetch participants from Firestore or Realtime Database
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (!userSnapshot.exists) {
        throw Exception("User not found");
      }

      // Deserialize the current user's data into UserModel
      final currentUser = UserModel.fromMap(userSnapshot.data()!);
      final participantIds = currentUser.participants ?? [];

      // Fetch participant data
      final List<UserModel> participants = [];
      for (String participantId in participantIds) {
        final participantSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(participantId)
            .get();

        if (participantSnapshot.exists) {
          participants.add(UserModel.fromMap(participantSnapshot.data()!));
        }
      }

      return participants; // Return the list of participants
    } catch (e) {
      print("Error fetching participants: $e");
      return [];
    }
  }

  void loadMessages(String senderId, String receiverId) {
    emit(ChatInitial()); // Ensure it starts with a loading state

    _messageSubscription?.cancel();
    _messageSubscription = getMessages(senderId, receiverId).listen(
          (messages) {
        emit(ChatLoaded(messages)); // Emit loaded state with messages
      },
      onError: (error) {
        emit(ChatError("Failed to load messages"));
      },
    );
  }

  // Add this method to your ChatCubit class
  Future<MessageModel?> getLastMessage(String senderId, String receiverId) async {
    try {
      final chatId = _generateChatId(senderId, receiverId);
      final messagesSnapshot = await _db
          .child('chats/$chatId')
          .orderByChild('timestamp')
          .limitToLast(1)
          .once();

      final data = messagesSnapshot.snapshot.value as Map?;
      if (data == null || data.isEmpty) return null;

      final messageData = data.values.first;
      return MessageModel.fromJson(Map<String, dynamic>.from(messageData));
    } catch (e) {
      return null;
    }
  }

  Future<void> sendMessage(MessageModel message) async {
    try {
      // Creating a combined sender-receiver ID for chat room identification
      final chatId = _generateChatId(message.senderId, message.receiverId);

      // First, send the message to the chat
      await _db.child('chats/$chatId').push().set(message.toJson());

      // Now, update the participants for both sender and receiver
      await _updateParticipants(message.senderId, message.receiverId);
    } catch (e) {
      emit(ChatError("Failed to send message"));
    }
  }

  Future<void> _updateParticipants(String senderId, String receiverId) async {
    try {
      // Fetch the current user's data
      final senderSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .get();
      final receiverSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();

      if (!senderSnapshot.exists || !receiverSnapshot.exists) {
        throw Exception("One or both users not found");
      }

      // Deserialize the users' data into UserModel
      final senderUser = UserModel.fromMap(senderSnapshot.data()!);
      final receiverUser = UserModel.fromMap(receiverSnapshot.data()!);

      // Check if the receiver is already in the sender's participants list
      if (!senderUser.participants!.contains(receiverId)) {
        senderUser.participants!.add(receiverId);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(senderId)
            .update({'participants': senderUser.participants});
      }

      // Check if the sender is already in the receiver's participants list
      if (!receiverUser.participants!.contains(senderId)) {
        receiverUser.participants!.add(senderId);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(receiverId)
            .update({'participants': receiverUser.participants});
      }
    } catch (e) {
      print("Error updating participants: $e");
      throw Exception("Error updating participants");
    }
  }


  Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
    final chatId = _generateChatId(senderId, receiverId);

    return _db
        .child('chats/$chatId')
        .orderByChild('timestamp')
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.entries.map((entry) {
        return MessageModel.fromJson(Map<String, dynamic>.from(entry.value));
      }).toList();
    });
  }

  String _generateChatId(String senderId, String receiverId) {
    return senderId.compareTo(receiverId) < 0
        ? '$senderId\_$receiverId'
        : '$receiverId\_$senderId';
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
