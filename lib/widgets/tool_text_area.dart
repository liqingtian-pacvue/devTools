import 'package:flutter/material.dart';

class ToolTextArea extends StatelessWidget {
  const ToolTextArea({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.readOnly = false,
    this.helperText,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool readOnly;
  final String? helperText;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 14,
        height: 1.45,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
        filled: true,
        fillColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}