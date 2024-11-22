import 'package:annex_finder/src/modules/landing/message/view/message_main_screen.dart';
import 'package:flutter/material.dart';

import '../../../../routes/navigators.dart';
import 'messenger_screen.dart';

class MessageIndexScreen extends StatelessWidget {
  const MessageIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: messageNavigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const MessageMainScreen(),
            );
          case '/message_screen':
            final userDetails = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => MessengerScreen(
                otherUserId: userDetails['user_id'],
                userId: userDetails['current_id'],
                userName: userDetails['user_name'],
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const MessageMainScreen(),
            );
        }
      },
    );
  }
}
