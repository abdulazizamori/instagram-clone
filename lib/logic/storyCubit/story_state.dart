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
  final bool userHasStory; // New field to check if user has a story

  StoriesLoaded({required this.stories, required this.userHasStory});
}

class StoryViewedSuccess extends StoryState {}

class StoryError extends StoryState {
  final String error;

  StoryError(this.error);
}
