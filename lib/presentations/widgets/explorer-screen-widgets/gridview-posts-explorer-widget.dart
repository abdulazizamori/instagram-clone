import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/presentations/screens/profile-screen/detailed-post-screen.dart';
import '../../../data/models/posts-model.dart';
import '../../../logic/posts-cubit/posts_cubit.dart';
import '../../screens/explorer-screen/Detailed-explore-screen.dart';
import 'package:video_player/video_player.dart';

class ExplorerGridViewWidget extends StatefulWidget {
  const ExplorerGridViewWidget({Key? key}) : super(key: key);

  @override
  _ExplorerGridViewWidgetState createState() => _ExplorerGridViewWidgetState();
}

class _ExplorerGridViewWidgetState extends State<ExplorerGridViewWidget> {
  late List<VideoPlayerController> _videoControllers = [];
  late Future<void> _initFuture; // Future for initialization

  @override
  void initState() {
    super.initState();
    context.read<PostsCubit>().fetchAllPosts();
  }

  @override
  void dispose() {
    // Dispose all video controllers
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeControllers(List<PostModel> userPosts) async {
    _videoControllers = userPosts.map((post) {
      if (post.isVideo == true && post.mediaUrls != null && post.mediaUrls!.isNotEmpty) {
        final controller = VideoPlayerController.network(post.mediaUrls!.first);
        return controller..initialize().then((_) => setState(() {})); // Ensure the widget rebuilds when initialized
      }
      return null; // Return null for non-video posts
    }).whereType<VideoPlayerController>().toList(); // Filter out null values
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

          // Initialize video controllers
          if (_videoControllers.isEmpty) {
            _initFuture = _initializeControllers(userPosts);
          }

          return FutureBuilder<void>(
            future: _initFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
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
                          builder: (context) => DetailedExploreScreen(
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
                          child: post.isVideo == true &&
                              post.mediaUrls != null &&
                              post.mediaUrls!.isNotEmpty
                              ? VideoPlayerWidget(
                            controller: _videoControllers[index],
                            isVisible: true, // Adjust based on your visibility logic
                          )
                              : post.mediaUrls != null && post.mediaUrls!.isNotEmpty
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
            },
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

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isVisible;

  const VideoPlayerWidget({Key? key, required this.controller, required this.isVisible}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.setLooping(true); // Optional: Loop the video
    widget.controller.play(); // Start playing when the widget initializes
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      widget.controller.play();
    } else {
      widget.controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: VideoPlayer(widget.controller),
    );
  }

  @override
  void dispose() {
    // Do not dispose of the controller here; it is managed by the parent widget
    super.dispose();
  }
}


