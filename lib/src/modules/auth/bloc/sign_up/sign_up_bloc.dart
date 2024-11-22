import 'dart:developer';
import 'package:annex_finder/src/services/repository/auth/firebases_user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    FirebasesUser firebasesUser = FirebasesUser();

    // Email/Password Sign-Up
    on<MyUserSignUpEvent>((event, emit) async {
      emit(MyUserSignUpProcessState());
      try {
        final userCreate = await firebasesUser.userRegister(
          event.email,
          event.password,
          event.fullName,
        );

        if (userCreate) {
          emit(MyUserSignUpSuccessState());
        } else {
          emit(const MyUserSignUpFailureState(message: "User registration failed. Please try again."));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = _handleFirebaseAuthException(e);
        emit(MyUserSignUpFailureState(message: errorMessage));
      } catch (e) {
        emit(const MyUserSignUpFailureState(message: 'An unknown error occurred during sign-up. Please try again.'));
      }
    });

    // Google Sign-Up
    on<MyUserGoogleSignUpEvent>((event, emit) async {
      emit(MyUserSignUpProcessState());
      try {
        final googleSignIn = await firebasesUser.googleSignUp();
        if (googleSignIn) {
          emit(MyUserGoogleSignUpSuccessState());
        } else {
          emit(const MyUserSignUpFailureState(message: 'Google sign-up failed. Please try again.'));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = _handleFirebaseAuthException(e);
        emit(MyUserSignUpFailureState(message: errorMessage));
      } catch (e) {
        log(e.toString());
        emit(const MyUserSignUpFailureState(message: 'An unknown error occurred during Google sign-up.'));
      }
    });

    // Facebook Sign-Up
    on<MyUserFacebookSignUpEvent>((event, emit) async {
      emit(MyUserSignUpProcessState());
      try {
        final facebookSignIn = await firebasesUser.facebookSignUp();
        if (facebookSignIn) {
          emit(MyUserFacebookSignUpSuccessState());
        } else {
          emit(const MyUserSignUpFailureState(message: 'Facebook sign-up failed. Please try again.'));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = _handleFirebaseAuthException(e);
        emit(MyUserSignUpFailureState(message: errorMessage));
      } catch (e) {
        log(e.toString());
        emit(const MyUserSignUpFailureState(message: 'An unknown error occurred during Facebook sign-up.'));
      }
    });
  }

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid. Please provide a valid email.';
      case 'operation-not-allowed':
        return 'Sign-ups are disabled for this method.';
      default:
        return 'Sign-up failed: ${e.message ?? 'Unknown error'}';
    }
  }
}
