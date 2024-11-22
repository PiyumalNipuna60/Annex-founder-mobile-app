import 'package:annex_finder/src/modules/auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:annex_finder/src/modules/landing/profile/block/annex/annex_bloc.dart';
import 'package:annex_finder/src/routes/navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/modules/auth/bloc/sign_in/sign_in_bloc.dart';
import 'src/modules/landing/bottom_navigation/block/bottom_navigation_cubit/navigation_cubit.dart';
import 'src/provider/bloc_provider/theme_bloc/theme_bloc.dart';
import 'src/res/themes/app_mode.dart';
import 'src/routes/app_route.dart';
import 'src/services/repository/annex_service.dart';

class AnnexFinderView extends StatelessWidget {
  const AnnexFinderView({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate AnnexService (or inject it using a Dependency Injection framework if available)
    final AnnexService _annexService =
        AnnexService(); // Ensure AnnexService is properly defined

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeBloc(),
        ),
        BlocProvider(
          create: (_) => SignUpBloc(),
        ),
        BlocProvider(
          create: (_) => SignInBloc(),
        ),
        BlocProvider(
          create: (_) => NavigationCubit(),
        ),
        BlocProvider(
          create: (_) =>
              AnnexBloc(_annexService), // Provide AnnexService to AnnexBloc
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: globalNavigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Annex Finder',
            theme: lightMode,
            themeMode: state,
            darkTheme: darkMode,
            initialRoute: '/',
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
