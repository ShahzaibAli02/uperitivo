import 'package:flutter/material.dart';

class CTBTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextAlign textAlign;
  final IconData? icon;

  const CTBTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.textAlign = TextAlign.center,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: textAlign,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10.0,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFFEC6500),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFFEC6500),
            width: 2.0,
          ),
        ),
        prefixIcon:
            icon != null ? Icon(icon, color: const Color(0xFFEC6500)) : null,
      ),
    );
  }
}
