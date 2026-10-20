import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'gradient_button.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off_rounded, size: 58, color: AppTheme.lavender), const SizedBox(height: 14), Text(message, textAlign: TextAlign.center), const SizedBox(height: 20), GradientButton(label: 'Reintentar', icon: Icons.refresh, onPressed: onRetry)])));
}
