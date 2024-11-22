import 'package:flutter/material.dart';

import '../../res/color/app_color.dart';

class AppMainButton extends StatelessWidget {
  final String testName;
  final double height;
  final Function()? onTap;
  const AppMainButton(
      {super.key,
      required this.testName,
      required this.onTap,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorUtil.simpleBlueColor[14]),
          child: Center(
              child: Text(
            testName,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          )),
        ),
      ),
    );
  }
}
