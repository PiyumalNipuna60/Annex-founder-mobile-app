import 'package:flutter/material.dart';

class ProfileHorizontalBarWidget extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final Color color;
  final String title;
  final String? badgeValue;
  final bool isVisibleBadge;
  const ProfileHorizontalBarWidget(
      {super.key,
      required this.onTap,
      required this.color,
      required this.icon,
      required this.title,
      this.badgeValue,
      required this.isVisibleBadge});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Badge(
            isLabelVisible: isVisibleBadge,
            label: Text(badgeValue ?? ""),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(title),
        ],
      ),
    );
  }
}
