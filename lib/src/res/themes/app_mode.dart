import 'package:flutter/material.dart';

import '../color/app_color.dart';
import 'hex_color.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: ColorUtil.tealColor[10]!,
    onPrimary: ColorUtil.tealColor[16]!,
    secondary: ColorUtil.blackColor[10]!,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: HexColor('#202231'),
    secondary: HexColor('#3d6adb'),
  ),
  fontFamily: 'Oswald',
);
