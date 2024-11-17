part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}
class ChatLoaded extends ChatState {
  final List<MessageModel> messages;

  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String errorMessage;

  ChatError(this.errorMessage);
}

class ChatParticipantsLoaded extends ChatState {
  final List<UserModel> users;

  ChatParticipantsLoaded(this.users);
}
final class ChatParticipantsLoading extends ChatState{}
final class ChatLoading extends ChatState{}

