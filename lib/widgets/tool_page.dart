import 'package:flutter/material.dart';

class ToolPage extends StatelessWidget {
  const ToolPage({
    super.key,
    required this.toolbar,
    required this.content,
  });

  final Widget toolbar;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          toolbar,
          const SizedBox(height: 20),
          Expanded(child: content),
        ],
      ),
    );
  }
}