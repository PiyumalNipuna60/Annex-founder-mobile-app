part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class MyUserSignUpEvent extends SignUpEvent {
  final String email;
  final String password;
  final String fullName;
  const MyUserSignUpEvent(
      {required this.email, required this.password, required this.fullName});

  @override
  List<Object> get props => [email, password, fullName];
}

class MyUserGoogleSignUpEvent extends SignUpEvent {
  const MyUserGoogleSignUpEvent();
}

class MyUserFacebookSignUpEvent extends SignUpEvent {
  const MyUserFacebookSignUpEvent();
}
