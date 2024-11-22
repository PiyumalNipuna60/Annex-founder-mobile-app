import 'dart:async';
import 'dart:developer';

import 'package:annex_finder/src/services/repository/auth/firebases_user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebasesUser firebasesUser;
  late final StreamSubscription<User?> _subscription;

  AuthenticationBloc({
    required FirebasesUser myUserRepository,
  })  : firebasesUser = myUserRepository,
        super(const AuthenticationState.unknown()) {
    _subscription = firebasesUser.user.listen((authUser) {
      add(AuthenticationUserChange(authUser));
    });

    on<AuthenticationUserChange>((event, emit) {
      if (event.user != null) {
        emit(AuthenticationState.authenticated(event.user!));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });
    on<UserSignOut>((event, emit) async {
      try {
        await firebasesUser.logout().then(
              (value) {},
            );
      } catch (e) {
        log(e.toString());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
