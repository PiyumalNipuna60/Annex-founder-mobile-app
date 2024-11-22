import 'package:annex_finder/src/modules/landing/home/view/home_main_screen.dart';
import 'package:flutter/material.dart';
import '../../../../routes/navigators.dart';

class HomeIndexScreen extends StatelessWidget {
  const HomeIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeNavigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const HomeMainScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const HomeMainScreen(),
            );
        }
      },
    );
  }
}
