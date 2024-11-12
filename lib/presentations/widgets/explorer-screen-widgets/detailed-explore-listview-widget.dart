import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/logic/posts-cubit/posts_cubit.dart';
import 'package:instaclone/main.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

import '../../../data/models/posts-model.dart';

class DetailedExploreListView extends StatefulWidget {
  final List<PostModel> postModel;
  final int initIndex;

  DetailedExploreListView({Key? key, required this.postModel, required this.initIndex}) : super(key: key);

  @override
  State<DetailedExploreListView> createState() => _DetailedExploreListViewState();
}

class _DetailedExploreListViewState extends State<DetailedExploreListView> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;
  int _visibleIndex = 0;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create(); // Correctly initialize here

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (itemScrollController.isAttached) {
        itemScrollController.jumpTo(index: widget.initIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ScrollablePositionedList.builder(
            itemCount: widget.postModel.length,
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener, // Pass it here
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final post = widget.postModel[index];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 10.w,
                          backgroundImage: post.userImage!.isNotEmpty
                              ? NetworkImage(post.userImage!)
                              : null,
                          child: post.userImage!.isEmpty
                              ? Icon(Icons.person)
                              : null,
                        ),
                        SizedBox(width: 7),
                        Text(post.userName.toString()),
                        Spacer(),
                        Icon(Icons.more_horiz),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        context.read<PostsCubit>().toggleLikePost(post, uid);
                      });
                    },
                    child: post.isVideo == true
                        ? VideoPlayerWidget(
                      url: post.mediaUrls!.first,
                      isVisible: _visibleIndex == index,
                    )
                        : Container(
                      height: 390.h,
                      width: 390.w,
                      child: Image.network(
                        post.mediaUrls?.isNotEmpty == true
                            ? post.mediaUrls!.first
                            : 'https://via.placeholder.com/390',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  BlocConsumer<PostsCubit, PostsState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      final cubit = context.read<PostsCubit>();
                      return PostActions(
                        post: post,
                        uid: uid,
                        onLikeToggle: () {
                          setState(() {
                            cubit.toggleLikePost(post, uid);
                          });
                        },
                      );
                    },
                  ),
                  PostLikesCount(post: post),
                  PostDescription(post: post),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool isVisible; // Add this parameter

  const VideoPlayerWidget({Key? key, required this.url, required this.isVisible}) : super(key: key);

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
        ? FittedBox(
      fit: BoxFit.cover, // This makes the video cover the container
      child: SizedBox(
        width: 390.w,
        height: 390.w,
        child: VideoPlayer(_controller),
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





class PostActions extends StatelessWidget {
  final PostModel post;
  final String uid;
  final VoidCallback onLikeToggle;

  const PostActions({
    required this.post,
    required this.uid,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = post.likes?.contains(uid) ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Theme.of(context).iconTheme.color,
              size: 20.sp,
            ),
            onTap: onLikeToggle,
          ),
          SizedBox(width: 10.w),
          Icon(Icons.comment, size: 20),
          SizedBox(width: 10.w),
          Icon(Icons.send, size: 20),
          Spacer(),
          Icon(Icons.bookmark, size: 20),
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
