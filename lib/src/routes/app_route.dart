import 'package:annex_finder/src/modules/annex_details_screen.dart';
import 'package:annex_finder/src/modules/auth/view/logged.dart';
import 'package:annex_finder/src/modules/landing/bottom_navigation/view/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../modules/auth/view/login_page.dart';
import '../modules/auth/view/register_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const Logged(),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        );
      case '/landing':
        return MaterialPageRoute(
          builder: (context) => const LandingScreen(),
        );
      case '/single_view':
        final annexDetails = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => AnnexDetailScreen(
            annex: annexDetails['annex'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
    }
  }
}
