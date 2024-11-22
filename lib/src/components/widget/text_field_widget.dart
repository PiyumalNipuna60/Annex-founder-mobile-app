import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData? iconData;
  final Color? color;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.iconData,
    this.color,
    this.onChanged,
    required this.obscureText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        suffixIcon: Icon(iconData, color: color),
      ),
    );
  }
}
