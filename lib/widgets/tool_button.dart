import 'package:flutter/material.dart';

class ToolButton extends StatelessWidget {
  const ToolButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = primary
        ? (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF020617))
        : (isDark ? const Color(0xFF020617) : Colors.white);

    final textColor = primary
        ? (isDark ? const Color(0xFF020617) : Colors.white)
        : (isDark ? const Color(0xFFE5E7EB) : const Color(0xFF111827));

    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onPressed,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: primary ? null : Border.all(color: borderColor),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}