import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/posts-cubit/posts_cubit.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/posts-model.dart';

class CustomPostsListview extends StatefulWidget {
  const CustomPostsListview({super.key});

  @override
  State<CustomPostsListview> createState() => _CustomPostsListviewState();
}

class _CustomPostsListviewState extends State<CustomPostsListview> {
  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;
  int _visibleIndex = 0;


  @override
  void initState() {
    super.initState();
    // Fetch posts when the widget initializes
    context.read<PostsCubit>().fetchAllPosts();

    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();

    // Add listener to track visible indices
    itemPositionsListener.itemPositions.addListener(() {
      final visibleItems = itemPositionsListener.itemPositions.value
          .where((position) => position.itemTrailingEdge > 0 && position.itemLeadingEdge < 1)
          .map((position) => position.index)
          .toList();

      if (visibleItems.isNotEmpty && _visibleIndex != visibleItems.first) {
        setState(() {
          _visibleIndex = visibleItems.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit, PostsState>(
      builder: (context, state) {
        final uid = FirebaseAuth.instance.currentUser!.uid;
        final cubit = context.read<PostsCubit>();

        if (state is PostsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PostsLoaded) {
          final posts = state.posts;

          if (posts.isEmpty) {
            return Center(child: Text("No posts available"));
          }

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    PostHeader(post: post),
                    SizedBox(height: 10.h),
                    post.isVideo == true
                        ? VideoPlayerWidget(url: post.mediaUrls!.first, isVisible: _visibleIndex == index, onDoubleTap: () {  setState(() {
                      cubit.toggleLikePost(post, uid);
                    }); },)
                        : PostImage(post: post, onDoubleTap: () { setState(() {
                      cubit.toggleLikePost(post, uid);
                    }); },),
                    PostActions(
                      post: post,
                      uid: uid,
                      onLikeToggle: () {
                        setState(() {
                          cubit.toggleLikePost(post, uid);
                        });
                      }, onFavoriteToggle: () async{
                      await cubit.toggleFavoritePost(post);
                      setState(() {

                      });

                    },
                    ),
                    PostLikesCount(post: post),
                    PostDescription(post: post),
                  ],
                ),
              );
            },
          );
        } else if (state is PostsError) {
          return Center(child: Text("Failed to load posts: ${state.error}"));
        } else {
          return Center(child: Text("Unexpected state"));
        }
      },
      listener: (context, state) {
        print('Current State: $state'); // Log the state
      },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool isVisible; // Add this parameter
  final GestureTapCallback onDoubleTap;

  const VideoPlayerWidget({Key? key, required this.url, required this.isVisible, required this.onDoubleTap}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown after the video is initialized
      });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      _controller.play();
    } else {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? GestureDetector(
      onDoubleTap: widget.onDoubleTap,
          child: FittedBox(
                fit: BoxFit.cover, // This makes the video cover the container
                child: SizedBox(
          width: 390.w,
          height: 390.w,
          child: VideoPlayer(_controller),
                ),
              ),
        )
        : Container(
      height: 390.h,
      width: 390.w,
      color: Colors.black,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}


class PostImage extends StatelessWidget {
  final PostModel post;
  final GestureTapCallback onDoubleTap;

  const PostImage({required this.post, required this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Container(
        height: 390.h,
        width: 390.w,
        child: Image.network(
          post.mediaUrls?.isNotEmpty == true
              ? post.mediaUrls!.first
              : 'https://via.placeholder.com/390',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class PostHeader extends StatelessWidget {
  final PostModel post;

  const PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.w,
            backgroundImage: post.userImage!.isNotEmpty
                ? NetworkImage(post.userImage!)
                : null,
            child: post.userImage!.isEmpty ? Icon(Icons.person) : null,
          ),
          SizedBox(width: 10.w),
          Text(
            post.userName ?? 'Username',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}

class PostActions extends StatefulWidget {
  final PostModel post;
  final String uid;
  final VoidCallback onLikeToggle;
  final VoidCallback onFavoriteToggle;


  const PostActions({
    required this.post,
    required this.uid,
    required this.onLikeToggle, required this.onFavoriteToggle,
  });

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Like button
          GestureDetector(
            child: Icon(
              (widget.post.likes?.contains(widget.uid) ?? false)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: (widget.post.likes?.contains(widget.uid) ?? false)
                  ? Colors.red
                  : Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              size: 20.w,
            ),
            onTap: widget.onLikeToggle,
          ),
          SizedBox(width: 10.w),
          // Comment and Send icons
          Image.asset(
            'assets/icons/comment.png',
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            width: 20.w,
            height: 20.h,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 10.w),
          Image.asset(
            'assets/icons/send.png',
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            width: 20.w,
            height: 20.h,
            fit: BoxFit.fill,
          ),
          Spacer(),
          // Save button
          GestureDetector(
            child: Icon(
              widget.post.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: widget.post.isSaved ? Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white : Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,
              size: 20.w,
            ),

            onTap:widget.onFavoriteToggle

          ),
        ],
      ),
    );
  }
}

class PostLikesCount extends StatelessWidget {
  final PostModel post;

  const PostLikesCount({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Text(
            '${post.likes?.length ?? 0}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 5.w),
          Text('Likes', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class PostDescription extends StatelessWidget {
  final PostModel post;

  const PostDescription({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Text(
            post.userName ?? 'Username',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 5.w),
          Expanded(child: Text(post.description ?? '')),
        ],
      ),
    );
  }
}
