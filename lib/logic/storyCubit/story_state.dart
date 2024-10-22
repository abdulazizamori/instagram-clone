part of 'story_cubit.dart';

@immutable
abstract class StoryState {}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryCreatedSuccess extends StoryState {
  final StoryModel story;

  StoryCreatedSuccess(this.story);
}

class StoriesLoaded extends StoryState {
  final List<StoryModel> stories;

  StoriesLoaded(this.stories);
}

class StoryViewedSuccess extends StoryState {}

class StoryError extends StoryState {
  final String error;

  StoryError(this.error);
}
