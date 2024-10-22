part of 'user_details_cubit.dart';

@immutable
sealed class UserDetailsState {}

final class UserDetailsInitial extends UserDetailsState {}

final class AuthLoading extends UserDetailsState{}
final class AuthSuccess extends UserDetailsState{
  AuthSuccess(String token);
}
final class AuthFailed extends UserDetailsState{}
class AuthError extends UserDetailsState {
  final String message;
  AuthError(this.message);
}

final class UserInfoLoaded extends UserDetailsState {
  final UserModel userInfo;

  UserInfoLoaded(this.userInfo);
}

final class UserInfoLoadError extends UserDetailsState {
  final String message;

  UserInfoLoadError(this.message);
}

final class UserInfoLoading extends UserDetailsState {}