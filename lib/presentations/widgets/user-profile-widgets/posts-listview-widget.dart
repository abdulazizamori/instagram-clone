import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../logic/posts-cubit/posts_cubit.dart';

class PostsListView extends StatefulWidget {
  const PostsListView({Key? key}) : super(key: key);

  @override
  _PostsListViewState createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      print("Fetching posts for user: $userId");
      context.read<PostsCubit>().fetchUserPosts(userId);
    } else {
      print("No user is currently logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit, PostsState>(
      builder: (context, state) {
        if (state is PostsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostsLoaded) {
          final userPosts = state.posts;
          if (userPosts.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: userPosts.length,
            itemBuilder: (context, index) {
              final post = userPosts[index];

              return GestureDetector(
                onTap: () {
                  print('Tapped on post ${post.postId}');
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: post.mediaUrls != null && post.mediaUrls!.isNotEmpty
                          ? Image.network(
                        post.mediaUrls![0],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,

                      )
                          : const Center(child: Text('No image available')),
                    ),
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
          );
        } else if (state is PostsError) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const Center(child: Text('Unexpected state'));
        }
      },
      listener: (context, state) {
        // Handle side effects here if needed
      },
    );
  }
}
