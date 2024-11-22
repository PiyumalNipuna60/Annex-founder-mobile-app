import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  final String sectionText;
  const SectionWidget({
    super.key,
    required this.sectionText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: Divider(thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(sectionText),
          ),
          const Expanded(child: Divider(thickness: 1)),
        ],
      ),
    );
  }
}
