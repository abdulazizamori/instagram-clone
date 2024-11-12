import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/message-model.dart';
import '../../../logic/chat-cubit/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  final String senderId;
  final String receiverId;
  final TextEditingController _controller = TextEditingController();

  ChatScreen({required this.senderId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    // Loading messages directly from the existing `ChatCubit` instance
    context.read<ChatCubit>().loadMessages(senderId, receiverId);

    return Scaffold(

      body: Column(
        children: [
          Row(children: [],),
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatInitial) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  final messages = state.messages;

                  if (messages.isEmpty) {
                    return Center(child: Text("No messages yet. Start chatting!"));
                  }

                  return ListView.builder(
                    reverse: true, // Show latest messages at the bottom
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == senderId;

                      return Align(
                        alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          margin: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(message.message),
                        ),
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(child: Text("Failed to load messages."));
                } else {
                  return Center(child: Text("Something went wrong!"));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Enter a message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      final message = MessageModel(
                        senderId: senderId,
                        receiverId: receiverId,
                        message: _controller.text.trim(),
                        timestamp: DateTime.now(),
                      );
                      context.read<ChatCubit>().sendMessage(message);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
