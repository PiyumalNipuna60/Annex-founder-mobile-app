import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final dynamic controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final TextInputType inputType;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.icon,
      required this.inputType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide()),
          hintText: hintText,
          suffixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: icon,
          )),
      obscureText: obscureText,
      keyboardType: inputType,
    );
  }
}
