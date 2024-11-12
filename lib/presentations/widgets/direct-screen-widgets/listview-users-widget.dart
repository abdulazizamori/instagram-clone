import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instaclone/logic/chat-cubit/chat_cubit.dart';
import 'package:instaclone/data/models/message-model.dart';
import '../../screens/chat-screens/chat-screen.dart';

class ListOfUsersWidget extends StatefulWidget {
  @override
  State<ListOfUsersWidget> createState() => _ListOfUsersWidgetState();
}

class _ListOfUsersWidgetState extends State<ListOfUsersWidget> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // Fetch participants when the screen loads
    context.read<ChatCubit>().getChatParticipants(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatParticipantsLoaded) {
            final users = state.users;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  // Fetch the last message for each user
                  return FutureBuilder<MessageModel?>(
                    future: context.read<ChatCubit>().getLastMessage(currentUser, user.uid.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePicture ?? 'https://via.placeholder.com/150'),
                          ),
                          title: Text(user.userName ?? 'Unknown'),
                          subtitle: Text('Loading...'),
                          trailing: Icon(Icons.camera_alt_outlined),
                        );
                      }

                      final lastMessage = snapshot.data;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePicture ?? 'https://via.placeholder.com/150'),
                        ),
                        title: Text(user.userName ?? 'Unknown'),
                        subtitle: Text(lastMessage?.message ?? 'No messages yet'),
                        trailing: Icon(Icons.camera_alt_outlined, size: 28),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                senderId: currentUser,
                                receiverId: user.uid.toString(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is ChatParticipantsLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text("No users found"));
          }
        },
      ),
    );
  }
}
