import 'package:annex_finder/app_view.dart';
import 'package:annex_finder/src/provider/bloc_provider/authentication/authentication_bloc.dart';
import 'package:annex_finder/src/services/repository/auth/firebases_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/modules/auth/bloc/current_user/current_user_bloc.dart';

class AnnexFinder extends StatelessWidget {
  final FirebasesUser firebasesUser;
  const AnnexFinder(
    this.firebasesUser, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(myUserRepository: firebasesUser),
        ),
        BlocProvider<CurrentUserBloc>(
          create: (_) => CurrentUserBloc(userRepository: firebasesUser),
        ),
      ],
      child: const AnnexFinderView(),
    );
  }
}
