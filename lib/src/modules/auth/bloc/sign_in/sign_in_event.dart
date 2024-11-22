part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class MyUserSignInEvent extends SignInEvent {
  final String email;
  final String password;
  const MyUserSignInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class MyUserGoogleSignInEvent extends SignInEvent {
  @override
  List<Object> get props => [];
}

class MyUserFacebookSignInEvent extends SignInEvent {
  @override
  List<Object> get props => [];
}
