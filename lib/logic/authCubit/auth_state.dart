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

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class UploadLoading extends AuthState {}

class UploadSuccess extends AuthState {
  final String imageUrl;
  UploadSuccess(this.imageUrl);
}

class UploadError extends AuthState {
  final String message;
  UploadError(this.message);
}

class UserVerificationStatusLoadedState extends AuthState {
  final bool isVerified;
  UserVerificationStatusLoadedState(this.isVerified);
}

final class UserVerificationStatusErrorState extends AuthState{
  UserVerificationStatusErrorState(String string);
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
