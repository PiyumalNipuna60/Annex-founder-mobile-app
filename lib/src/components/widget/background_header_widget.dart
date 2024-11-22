import 'package:annex_finder/src/res/color/app_color.dart';
import 'package:flutter/material.dart';

class BackgroundHeaderWidget extends StatelessWidget {
  final String headerText;
  final String subText;
  const BackgroundHeaderWidget({
    super.key,
    required this.headerText,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.35,
      color: ColorUtil.simpleBlueColor[10], // Purple background
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            headerText,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: ColorUtil.whiteColor[10],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subText,
            style: TextStyle(
              fontSize: 16,
              color: ColorUtil.whiteColor[14],
            ),
          ),
        ],
      ),
    );
  }
}
