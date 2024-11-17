import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/message-model.dart';
import '../../../logic/chat-cubit/chat_cubit.dart';
import '../../widgets/chat-screen-widgets/app-bar-widget.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;

  ChatScreen({required this.senderId, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_textListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_textListener);
    _controller.dispose();
    super.dispose();
  }

  // Listener function for the controller
  void _textListener() {
    // No need to call setState here; the UI will automatically rebuild only when necessary
  }

  @override
  Widget build(BuildContext context) {
    context.read<ChatCubit>().loadMessages(widget.senderId, widget.receiverId);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ChatAppBarWidget(friendid: widget.receiverId),
            Divider(),
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
                        final isMe = message.senderId == widget.senderId;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(message.message,style: TextStyle(color: Colors.white),),
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
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 15),
                  child: Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blue),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                              hintText: "Message...", border: InputBorder.none),
                        ),
                      ),
                      // Use ValueListenableBuilder to update the UI when text changes
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _controller,
                        builder: (context, text, child) {
                          return text.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              if (_controller.text.trim().isNotEmpty) {
                                final message = MessageModel(
                                  senderId: widget.senderId,
                                  receiverId: widget.receiverId,
                                  message: _controller.text.trim(),
                                  timestamp: DateTime.now(),
                                );
                                context.read<ChatCubit>().sendMessage(message);
                                _controller.clear();
                              }
                            },
                          )
                              : Row(
                            children: [
                              Icon(Icons.mic_none_outlined),
                              SizedBox(width: 5.w),
                              Icon(Icons.photo_size_select_actual_outlined),
                              SizedBox(width: 5.w),
                              Icon(Icons.sticky_note_2_outlined),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
