part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class MyUserSignInProcessState extends SignInState {}

final class MyUserSignInFailureState extends SignInState {
  final String message;
  const MyUserSignInFailureState({required this.message});
}

final class MyUserSignInSuccessState extends SignInState {}

final class MyUserGoogleSignInSuccessState extends SignInState {}

final class MyUserFacebookSignInSuccessState extends SignInState {}
