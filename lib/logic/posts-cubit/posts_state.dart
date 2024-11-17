part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostCreatedSuccess extends PostsState {
  final PostModel post;

  PostCreatedSuccess(this.post);
}

class PostsLoaded extends PostsState {
  final List<PostModel> posts;

  PostsLoaded(this.posts);
}

class PostsError extends PostsState {
  final String error;

  PostsError(this.error);
}

class PostFavoritedToggle extends PostsState {
  final String postId;
  final bool isFavorited;

  PostFavoritedToggle(this.postId, {required this.isFavorited});
}
class PostSavedToggle extends PostsState {
  final String postId;
  final bool isSaved;

  PostSavedToggle({required this.postId, required this.isSaved});
}