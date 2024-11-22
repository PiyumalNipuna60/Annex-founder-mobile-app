import 'package:flutter/material.dart';

class FromCardWidget extends StatelessWidget {
  final Widget widget;
  const FromCardWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0, -100, 0), // Overlap adjustment
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: widget,
      ),
    );
  }
}
