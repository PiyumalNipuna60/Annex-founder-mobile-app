part of 'current_user_bloc.dart';

sealed class CurrentUserState extends Equatable {
  const CurrentUserState();
  
  @override
  List<Object> get props => [];
}

// Initial state when nothing has been loaded yet
final class CurrentUserInitial extends CurrentUserState {}

// State when a request is being processed
final class CurrentUserLoading extends CurrentUserState {}

// State when the user profile is successfully loaded
final class CurrentUserLoaded extends CurrentUserState {
  final MyUser user; // Assuming MyUser is your user model
  const CurrentUserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

// State when a user is blocked
final class CurrentUserBlocked extends CurrentUserState {
  final String userId;
  const CurrentUserBlocked({required this.userId});

  @override
  List<Object> get props => [userId];
}

// State when a user is unblocked
final class CurrentUserUnblocked extends CurrentUserState {
  final String userId;
  const CurrentUserUnblocked({required this.userId});

  @override
  List<Object> get props => [userId];
}

// State when an error occurs
final class CurrentUserError extends CurrentUserState {
  final String message;
  const CurrentUserError({required this.message});

  @override
  List<Object> get props => [message];
}
