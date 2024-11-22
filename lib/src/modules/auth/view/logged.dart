import 'package:annex_finder/src/modules/auth/view/login_page.dart';
import 'package:annex_finder/src/modules/landing/bottom_navigation/view/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../provider/bloc_provider/authentication/authentication_bloc.dart';
import '../bloc/current_user/current_user_bloc.dart';

class Logged extends StatelessWidget {
  const Logged({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          context.read<CurrentUserBloc>().add(GetCurrentUserEvent());

          return BlocBuilder<CurrentUserBloc, CurrentUserState>(
            builder: (context, userState) {
              if (userState is CurrentUserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (userState is CurrentUserLoaded) {
                if (userState.user.isBlocked) {
                  return const Center(
                    child: Text(
                      'Your account has been blocked. Please contact support.',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return const LandingScreen();
                }
              } else if (userState is CurrentUserError) {
                return Center(
                  child: Text(
                    'Error: ${userState.message}',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return const LandingScreen();
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
