import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../res/color/app_color.dart';
import '../../../../routes/navigators.dart';
import '../block/bottom_navigation_cubit/navigation_cubit.dart';
import '../block/bottom_navigation_cubit/navigation_state.dart';
import '../components/bottom_nav_widget.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          currentIndex = state.index;
          return BottomNavWidget(
            bottomNavigatorKey: bottomNavigatorKey,
            onTap: (bottomIndex) {
              context.read<NavigationCubit>().updateIndex(bottomIndex);
            },
            currentIndex: currentIndex,
            bottomNavItems: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(
                  Iconsax.home_2,
                  color: currentIndex == 0
                      ? ColorUtil.simpleBlueColor[10]
                      : ColorUtil.whiteColor[14],
                  size: 30,
                ),
              ),
              BottomNavigationBarItem(
                label: 'search',
                icon: Icon(
                  Iconsax.search_normal,
                  color: currentIndex == 1
                      ? ColorUtil.simpleBlueColor[10]
                      : ColorUtil.whiteColor[14],
                  size: 30,
                ),
              ),
              BottomNavigationBarItem(
                label: 'message',
                icon: Icon(Iconsax.message,
                    color: currentIndex == 2
                        ? ColorUtil.simpleBlueColor[10]
                        : ColorUtil.whiteColor[14],
                    size: 30),
              ),
              BottomNavigationBarItem(
                label: 'profile',
                icon: Icon(Iconsax.profile_circle,
                    color: currentIndex == 3
                        ? ColorUtil.simpleBlueColor[10]
                        : ColorUtil.whiteColor[14],
                    size: 30),
              ),
            ],
          );
        },
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(microseconds: 100),
            switchInCurve: Curves.bounceInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: state.screens[state.index],
          );
        },
      ),
    );
  }
}
