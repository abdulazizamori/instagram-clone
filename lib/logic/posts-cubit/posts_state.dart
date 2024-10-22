part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostCreatedSuccess extends PostsState {
  final PostModel post;

  PostCreatedSuccess(this.post);
}

class PostLikedSuccess extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostModel> posts;

  PostsLoaded(this.posts);
}

class PostsError extends PostsState {
  final String error;

  PostsError(this.error);
}

class PostFavorited extends PostsState {}


