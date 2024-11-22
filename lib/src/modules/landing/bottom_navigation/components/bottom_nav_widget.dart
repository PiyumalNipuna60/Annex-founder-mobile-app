import 'package:flutter/material.dart';

import '../../../../res/color/app_color.dart';


class BottomNavWidget extends StatelessWidget {
  final Key bottomNavigatorKey;
  final Function(int) onTap;
  final int currentIndex;
  final List<BottomNavigationBarItem> bottomNavItems;
  const BottomNavWidget(
      {super.key,
      required this.bottomNavigatorKey,
      required this.onTap,
      required this.currentIndex,
      required this.bottomNavItems});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: bottomNavigatorKey,
      elevation: 8,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: ColorUtil.tealColor[10],
      selectedFontSize: 14,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: bottomNavItems,
    );
  }
}
