import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/logic/posts-cubit/posts_cubit.dart';
import 'package:instaclone/main.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../data/models/posts-model.dart';

class DetailedListView extends StatefulWidget {
  final List<PostModel> postModel;
  final int initIndex;

  DetailedListView(
      {super.key, required this.postModel, required this.initIndex});

  @override
  State<DetailedListView> createState() => _DetailedListViewState();
}

class _DetailedListViewState extends State<DetailedListView> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late ItemScrollController itemScrollController;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();

    // Scroll to the initial index after build completes
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
                          backgroundImage: widget.postModel[index].userImage!.isNotEmpty
                              ? NetworkImage(widget.postModel[index].userImage!)
                              : null,
                          child: widget.postModel[index].userImage!.isEmpty
                              ? Icon(Icons.person)
                              : null,
                        ),
                        SizedBox(width: 7),
                        Text(widget.postModel[index].userName.toString()),
                        Spacer(),
                        Icon(Icons.more_horiz)
                      ],
                    ),
                  ),
                  Container(
                    height: 390.h,
                    width: 390.w,
                    child: Image.network(
                      widget.postModel[index].mediaUrls?.isNotEmpty == true
                          ? widget.postModel[index].mediaUrls!.first
                          : 'https://via.placeholder.com/390',
                      fit: BoxFit.fill,
                    ),
                  ),
                  BlocConsumer<PostsCubit, PostsState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      final cubit = context.read<PostsCubit>();
                      return PostActions(
                        post: widget.postModel[index],
                        uid: uid,
                        onLikeToggle: () {
                          setState(() {
                            final liked = post.likes?.contains(uid) ?? false;
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
              color: isLiked
                  ? Colors.red
                  : (Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
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
