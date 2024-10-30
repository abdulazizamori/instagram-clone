import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/presentations/screens/profile-screen/detailed-post-screen.dart';
import '../../../logic/posts-cubit/posts_cubit.dart';
import '../../screens/explorer-screen/Detailed-explore-screen.dart';

class ExplorerGridViewWidget extends StatefulWidget {
  const ExplorerGridViewWidget({Key? key}) : super(key: key);

  @override
  _ExplorerGridViewWidgetState createState() => _ExplorerGridViewWidgetState();
}

class _ExplorerGridViewWidgetState extends State<ExplorerGridViewWidget> {
  @override
  void initState() {
    super.initState();
      context.read<PostsCubit>().fetchAllPosts();
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailedExploreScreen(postModel: userPosts, initIndex:index)));
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
