import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NavigationState extends Equatable {
  final int index;
  final List<Widget> screens;

  const NavigationState(this.index, this.screens);

  @override
  List<Object> get props => [index, screens];
}
