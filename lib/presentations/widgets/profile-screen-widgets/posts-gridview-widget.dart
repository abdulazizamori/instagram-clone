import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/presentations/screens/profile-screen/detailed-post-screen.dart';
import 'package:video_player/video_player.dart';
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedPostScreen(
                        postModel: userPosts,
                        initIndex: index,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: post.mediaUrls != null && post.mediaUrls!.isNotEmpty
                          ? post.isVideo!
                          ? VideoThumbnailWidget(videoUrl: post.mediaUrls![0])
                          : Image.network(
                        post.mediaUrls![0],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      )
                          : const Center(child: Text('No media available')),
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

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnailWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoThumbnailWidgetState createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Update the UI when video is loaded
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : const Center(child: CircularProgressIndicator());
  }
}
