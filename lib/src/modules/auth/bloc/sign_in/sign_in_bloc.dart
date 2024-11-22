import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../services/repository/auth/firebases_user.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    FirebasesUser firebasesUser = FirebasesUser();

    // Email and password sign-in
    on<MyUserSignInEvent>((event, emit) async {
      emit(MyUserSignInProcessState());
      try {
        final userLogin = await firebasesUser.userLogin(event.email, event.password);
        if (userLogin) {
          emit(MyUserSignInSuccessState());
        } else {
          emit(const MyUserSignInFailureState(message: 'Failed to log in. Please check your credentials.'));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = _handleFirebaseAuthException(e);
        emit(MyUserSignInFailureState(message: errorMessage));
      } catch (e) {
        emit(const MyUserSignInFailureState(message: 'An unknown error occurred. Please try again.'));
      }
    });

    // Google sign-in
    on<MyUserGoogleSignInEvent>((event, emit) async {
      emit(MyUserSignInProcessState());
      try {
        final googleSignIn = await firebasesUser.googleSignIn();
        if (googleSignIn) {
          emit(MyUserGoogleSignInSuccessState());
        } else {
          emit(const MyUserSignInFailureState(message: 'Failed to sign in with Google.'));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = _handleFirebaseAuthException(e);
        emit(MyUserSignInFailureState(message: errorMessage));
      } catch (e) {
        emit(const MyUserSignInFailureState(message: 'An unknown error occurred during Google sign-in.'));
      }
    });

    // Facebook sign-in
    on<MyUserFacebookSignInEvent>((event, emit) async {
      emit(MyUserSignInProcessState());
      try {
        final facebookSignIn = await firebasesUser.facebookSignIn();
        if (facebookSignIn) {
          emit(MyUserFacebookSignInSuccessState());
        } else {
          emit(const MyUserSignInFailureState(message: 'Failed to sign in with Facebook.'));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = _handleFirebaseAuthException(e);
        emit(MyUserSignInFailureState(message: errorMessage));
      } catch (e) {
        emit(const MyUserSignInFailureState(message: 'An unknown error occurred during Facebook sign-in.'));
      }
    });
  }

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'wrong-password':
        return 'The password is incorrect.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'Login failed: ${e.message ?? 'Unknown error'}';
    }
  }
}
