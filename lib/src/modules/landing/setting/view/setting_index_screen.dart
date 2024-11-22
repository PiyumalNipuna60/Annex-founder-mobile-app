import 'package:annex_finder/src/modules/landing/setting/view/setting_main_screen.dart';
import 'package:annex_finder/src/routes/navigators.dart';
import 'package:flutter/material.dart';

class SettingIndexScreen extends StatelessWidget {
  const SettingIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: settingNavigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const SettingMainScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const SettingMainScreen(),
            );
        }
      },
    );
  }
}
