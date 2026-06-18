import 'package:flutter/material.dart';

class ToolSelectOption {
  const ToolSelectOption({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;
}

class ToolSelect extends StatelessWidget {
  const ToolSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<ToolSelectOption> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        PopupMenuButton<String>(
          onSelected: onChanged,
          color: isDark ? const Color(0xFF020617) : Colors.white,
          itemBuilder: (context) {
            return options.map((option) {
              return PopupMenuItem<String>(
                value: option.value,
                child: Text(option.label),
              );
            }).toList();
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(options.firstWhere((e) => e.value == value).label),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}