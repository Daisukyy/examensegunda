import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.controller, required this.label, required this.icon, this.validator, this.obscureText = false, this.keyboardType, this.maxLines = 1, this.suffixIcon, this.onChanged});
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  @override Widget build(BuildContext context) => TextFormField(controller: controller, validator: validator, obscureText: obscureText, keyboardType: keyboardType, maxLines: obscureText ? 1 : maxLines, onChanged: onChanged, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: const Color(0xFFFF6FA5)), suffixIcon: suffixIcon));
}
