import 'package:annex_finder/src/modules/landing/profile/view/annex_bookin_screen.dart';
import 'package:annex_finder/src/modules/landing/profile/view/annex_list_screen.dart';
import 'package:annex_finder/src/modules/landing/profile/view/annex_scheduling_screen.dart';
import 'package:annex_finder/src/modules/landing/profile/view/booking_screen.dart';
import 'package:flutter/material.dart';
import '../../../../routes/navigators.dart';
import 'edit_profile_screen.dart';
import 'profile_main_screen.dart';

class ProfileIndexScreen extends StatelessWidget {
  const ProfileIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: profileNavigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const ProfileMainScreen(),
            );
          case '/edit_profile':
            final myUser = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => EditProfileScreen(
                myUser: myUser['my_user'],
              ),
            );
          case '/add_annex':
            return MaterialPageRoute(
              builder: (context) => const AnnexSchedulingScreen(),
            );
          case '/list_annex':
            return MaterialPageRoute(
              builder: (context) => const AnnexListScreen(),
            );
          case '/booking_annex':
            return MaterialPageRoute(
              builder: (context) => const BookingScreen(),
            );
          case '/booking_screen':
            final annexId = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => AnnexBookingsScreen(
                annexDocId: annexId['annexId'],
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const ProfileMainScreen(),
            );
        }
      },
    );
  }
}
