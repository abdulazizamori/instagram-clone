part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}


final class UserCreateSuccess extends AuthState{}

final class UserCreateFailure extends AuthState{}

final class UserCreateError extends AuthState{
  UserCreateError(String string);
}

final class AuthLoading extends AuthState{}

final class AuthSuccess extends AuthState{
  AuthSuccess(String token);
}

final class AuthFailed extends AuthState{}

final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

final class UploadLoading extends AuthState {}

final class UploadSuccess extends AuthState {
  final String imageUrl;
  UploadSuccess(this.imageUrl);
}

final class UploadError extends AuthState {
  final String message;
  UploadError(this.message);
}


final class UserInfoLoaded extends AuthState {
  final UserModel userInfo;

  UserInfoLoaded(this.userInfo);
}

final class UserInfoLoadError extends AuthState {
  final String message;

  UserInfoLoadError(this.message);
}

final class UserInfoLoading extends AuthState {}

class SignOut extends AuthState {}

final class UserInfoUpdated extends AuthState{}

final class UserInfoPostsCountLoaded extends AuthState {
  final int postsCount;

  UserInfoPostsCountLoaded(this.postsCount);
}

final class ImageSelected extends AuthState {
  final XFile image;

  ImageSelected(this.image);
}

final class ImageSelectionError extends AuthState {
  final String message;

  ImageSelectionError(this.message);
}

final class FetchUsersLoading extends AuthState {}
final class FetchUsersSuccess extends AuthState {
  final List<UserModel> users;
  FetchUsersSuccess(this.users);
}
final class FetchUsersError extends AuthState {
  final String error;
  FetchUsersError(this.error);
}
