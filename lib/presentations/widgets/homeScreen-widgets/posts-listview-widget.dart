import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/posts-cubit/posts_cubit.dart';

import '../../../data/models/posts-model.dart';

class CustomPostsListview extends StatefulWidget {
  const CustomPostsListview({super.key});

  @override
  State<CustomPostsListview> createState() => _CustomPostsListviewState();
}

class _CustomPostsListviewState extends State<CustomPostsListview> {
  @override
  void initState() {
    super.initState();
    // Fetch posts when the widget initializes
    context.read<PostsCubit>().fetchAllPosts();
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
                    PostImage(post: post),
                    PostActions(
                      post: post,
                      uid: uid,
                      onLikeToggle: () {
                        setState(() {
                          final liked = post.likes?.contains(uid) ?? false;
                          cubit.toggleLikePost(post, uid);
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

class PostImage extends StatelessWidget {
  final PostModel post;

  const PostImage({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390.h,
      width: 390.w,
      child: Image.network(
        post.mediaUrls?.isNotEmpty == true
            ? post.mediaUrls!.first
            : 'https://via.placeholder.com/390',
        fit: BoxFit.fill,
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
              color: isLiked ? Colors.red : (Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
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