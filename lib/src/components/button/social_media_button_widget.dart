import 'package:flutter/material.dart';

class SocialMediaButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final String assetPath;
  final Function()? onTap;
  const SocialMediaButtonWidget(
      {super.key,
      required this.backgroundColor,
      required this.assetPath,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10), // Rounded corners
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 8, // Shadow blur radius
              offset: Offset(0, 4), // Shadow offset
            ),
          ],
        ),
        padding: const EdgeInsets.all(12), // Padding for the button
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(30), // Ensure the image is also rounded
          child: Image.asset(
            assetPath,
            width: 40,
            height: 40,
            fit: BoxFit.cover, // Ensure the image covers the entire area
          ),
        ),
      ),
    );
  }
}
