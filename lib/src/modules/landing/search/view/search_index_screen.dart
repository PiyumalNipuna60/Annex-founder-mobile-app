import 'package:annex_finder/src/modules/landing/search/view/all_provinces_screen.dart';
import 'package:annex_finder/src/modules/landing/search/view/search_main_screen.dart';
import 'package:flutter/material.dart';

import '../../../../routes/navigators.dart';

class SearchIndexScreen extends StatelessWidget {
  const SearchIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: searchNavigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const SearchMainScreen(),
            );
          case '/provinces_screen':
            final provinces = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => AllProvincesScreen(
                provinces: provinces['provinces'],
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const SearchMainScreen(),
            );
        }
      },
    );
  }
}
