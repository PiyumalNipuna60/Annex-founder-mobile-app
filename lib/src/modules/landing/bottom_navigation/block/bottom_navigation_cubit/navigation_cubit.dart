import 'package:bloc/bloc.dart';
import 'package:annex_finder/src/modules/landing/home/view/home_index_screen.dart';
import 'package:annex_finder/src/modules/landing/message/view/message_index_screen.dart';
import 'package:annex_finder/src/modules/landing/profile/view/profile_index_screen.dart';
import 'package:annex_finder/src/modules/landing/search/view/search_index_screen.dart';
import 'package:flutter/material.dart';

import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  // Store the screens as instance variables to avoid recreating them
  final List<Widget> _screens = const [
    HomeIndexScreen(),
    SearchIndexScreen(),
    MessageIndexScreen(),
    ProfileIndexScreen(),
  ];

  NavigationCubit() : super(const NavigationState(0, [])) {
    emit(NavigationState(0, _screens));
  }

  void updateIndex(int newIndex) {
    emit(NavigationState(newIndex, _screens));
  }
}
