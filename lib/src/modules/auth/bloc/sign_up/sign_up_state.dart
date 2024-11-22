part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

final class MyUserSignUpProcessState extends SignUpState {}

final class MyUserSignUpFailureState extends SignUpState {
  final String message;
  const MyUserSignUpFailureState({required this.message});
}

final class MyUserSignUpSuccessState extends SignUpState {}

final class MyUserGoogleSignUpSuccessState extends SignUpState {}

final class MyUserFacebookSignUpSuccessState extends SignUpState {}
