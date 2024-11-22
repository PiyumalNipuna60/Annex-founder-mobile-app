part of 'current_user_bloc.dart';

sealed class CurrentUserEvent extends Equatable {
  const CurrentUserEvent();

  @override
  List<Object> get props => [];
}

// Event to get the current user profile
final class GetCurrentUserEvent extends CurrentUserEvent {}

// Event to block a user
final class CurrentUserBlockEvent extends CurrentUserEvent {
  final String userId;
  const CurrentUserBlockEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

// Event to unblock a user
final class CurrentUserUnBlockEvent extends CurrentUserEvent {
  final String userId;
  const CurrentUserUnBlockEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

// Event to unblock a user
final class CurrentUserUpdateEvent extends CurrentUserEvent {
  final String userId;
  final MyUser myUser;
  final File? imageFile;
  const CurrentUserUpdateEvent(
      {required this.userId, required this.myUser, this.imageFile});

  @override
  List<Object> get props => [userId, myUser];
}
