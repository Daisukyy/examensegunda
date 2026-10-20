import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.label, required this.selected, required this.onSelected});
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(label: Text(label), selected: selected, onSelected: onSelected, backgroundColor: Colors.white, selectedColor: AppTheme.pink, labelStyle: TextStyle(color: selected ? Colors.white : AppTheme.ink, fontWeight: FontWeight.w600), side: BorderSide(color: selected ? AppTheme.pink : AppTheme.paleLavender)));
}
