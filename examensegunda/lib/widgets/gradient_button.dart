import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  @override Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.hotPink, AppTheme.lavender]), borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: AppTheme.pink.withValues(alpha: .3), blurRadius: 14, offset: const Offset(0, 6))]),
        child: ElevatedButton.icon(onPressed: onPressed, icon: icon == null ? const SizedBox.shrink() : Icon(icon), label: Text(label), style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(52), shape: const StadiumBorder(), textStyle: const TextStyle(fontWeight: FontWeight.w700))),
      );
}
