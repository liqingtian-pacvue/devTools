import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonTreeView extends StatelessWidget {
  const JsonTreeView({
    super.key,
    required this.data,
  });

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _JsonNode(
        name: 'root',
        value: data,
        level: 0,
      ),
    );
  }
}

class _JsonNode extends StatefulWidget {
  const _JsonNode({
    required this.name,
    required this.value,
    required this.level,
  });

  final String name;
  final dynamic value;
  final int level;

  @override
  State<_JsonNode> createState() => _JsonNodeState();
}

class _JsonNodeState extends State<_JsonNode> {
  bool expanded = true;
  bool hovering = false;

  bool get isExpandable => widget.value is Map || widget.value is List;

  @override
  Widget build(BuildContext context) {
    final indent = widget.level * 18.0;

    if (!isExpandable) {
      return _hoverRow(
        context: context,
        indent: indent,
        child: _valueLine(context),
      );
    }

    final children = widget.value is Map
        ? (widget.value as Map).entries.map((entry) {
            return _JsonNode(
              name: entry.key.toString(),
              value: entry.value,
              level: widget.level + 1,
            );
          }).toList()
        : (widget.value as List).asMap().entries.map((entry) {
            return _JsonNode(
              name: '[${entry.key}]',
              value: entry.value,
              level: widget.level + 1,
            );
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hoverRow(
          context: context,
          indent: indent,
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                expanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: 18,
                color: _mutedColor(context),
              ),
              const SizedBox(width: 4),
              Text(
                widget.name,
                style: TextStyle(
                  color: _keyColor(context),
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                widget.value is Map
                    ? '{${(widget.value as Map).length}}'
                    : '[${(widget.value as List).length}]',
                style: TextStyle(
                  color: _mutedColor(context),
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 120),
          crossFadeState:
              expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _hoverRow({
    required BuildContext context,
    required double indent,
    required Widget child,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        onSecondaryTapDown: (details) {
          _showCopyMenu(context, details.globalPosition);
        },
        child: Container(
          margin: EdgeInsets.only(left: indent, top: 2, bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: hovering
                ? isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _valueLine(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: '${widget.name}: ',
            style: TextStyle(
              color: _keyColor(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: _displayValue(widget.value),
            style: TextStyle(
              color: _valueColor(context, widget.value),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCopyMenu(BuildContext context, Offset position) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: const [
        PopupMenuItem(value: 'key', child: Text('复制 key')),
        PopupMenuItem(value: 'value', child: Text('复制 value')),
      ],
    );

    if (!context.mounted || selected == null) return;

    final text = selected == 'key'
        ? widget.name
        : _copyableValue(widget.value);

    await Clipboard.setData(ClipboardData(text: text));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已复制 $selected')),
    );
  }

  String _displayValue(dynamic value) {
    if (value is String) return '"$value"';
    if (value == null) return 'null';
    return value.toString();
  }

  String _copyableValue(dynamic value) {
    if (value is Map || value is List) {
      return const JsonEncoder.withIndent('  ').convert(value);
    }

    if (value is String) return value;
    if (value == null) return 'null';

    return value.toString();
  }

  Color _keyColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF93C5FD)
        : const Color(0xFF2563EB);
  }

  Color _mutedColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
  }

  Color _valueColor(BuildContext context, dynamic value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (value is String) {
      return isDark ? const Color(0xFF86EFAC) : const Color(0xFF16A34A);
    }

    if (value is num) {
      return isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);
    }

    if (value is bool) {
      return isDark ? const Color(0xFFFDE68A) : const Color(0xFFD97706);
    }

    if (value == null) {
      return isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B);
    }

    return isDark ? const Color(0xFFE5E7EB) : const Color(0xFF111827);
  }
}