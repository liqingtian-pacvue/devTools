import 'package:flutter/material.dart';

import '../services/timestamp_service.dart';
import '../widgets/tool_button.dart';
import '../widgets/tool_page.dart';
import '../core/clipboard_helper.dart';
import '../core/snackbar_helper.dart';
import '../widgets/tool_input.dart';
import '../widgets/tool_select.dart';
import '../widgets/tool_result_panel.dart';

class TimestampPage extends StatefulWidget {
  const TimestampPage({super.key});

  @override
  State<TimestampPage> createState() => _TimestampPageState();
}

class _TimestampPageState extends State<TimestampPage> {
  final inputController = TextEditingController();
  final outputController = TextEditingController();

  String selectedTimezone = 'local';

  final timezoneOptions = const <ToolSelectOption>[
    ToolSelectOption(value: 'local', label: '本地时区'),
    ToolSelectOption(value: 'utc', label: 'UTC'),
  ];

  void convertTimestamp() {
    final text = inputController.text.trim();

    if (text.isEmpty) {
      showMessage('请输入时间戳');
      return;
    }

    try {
      final dateTime = TimestampService.fromTimestamp(text);

      final displayDateTime = selectedTimezone == 'utc'
          ? dateTime.toUtc()
          : dateTime.toLocal();

      final timezoneLabel = selectedTimezone == 'utc' ? 'UTC' : '本地时间';

      setState(() {
        outputController.text = [
          '$timezoneLabel：$displayDateTime',
          '',
          '本地时间：${dateTime.toLocal()}',
          'UTC 时间：${dateTime.toUtc()}',
          '',
          '秒级时间戳：${TimestampService.toSeconds(dateTime)}',
          '毫秒时间戳：${TimestampService.toMilliseconds(dateTime)}',
        ].join('\n');
      });
    } catch (_) {
      showMessage('时间戳格式错误');
    }
  }

  void useCurrentTime() {
    final now = DateTime.now();

    setState(() {
      inputController.text = TimestampService.toMilliseconds(now).toString();
    });

    convertTimestamp();
  }

  void clearAll() {
    setState(() {
      inputController.clear();
      outputController.clear();
    });
  }

  Future<void> copyOutput() async {
    final text = outputController.text;

    if (text.isEmpty) {
      SnackBarHelper.show(context, '没有可复制的内容');
      return;
    }

    await ClipboardHelper.copy(text);

    if (!mounted) return;
    SnackBarHelper.show(context, '已复制');
  }

  void showMessage(String message) {
    SnackBarHelper.show(context, message);
  }

  @override
  void dispose() {
    inputController.dispose();
    outputController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ToolPage(
      toolbar: Row(
        children: [
          ToolButton(label: '转换', primary: true, onPressed: convertTimestamp),
          const SizedBox(width: 8),
          ToolButton(label: '当前时间', onPressed: useCurrentTime),
          const SizedBox(width: 8),
          ToolButton(label: '复制结果', onPressed: copyOutput),
          const SizedBox(width: 8),
          TextButton(onPressed: clearAll, child: const Text('清空')),
        ],
      ),
      content: Column(
        children: [
          Row(
            children: [
              const Text('显示时区：'),
              const SizedBox(width: 12),
              ToolSelect(
                label: '显示时区',
                value: selectedTimezone,
                options: timezoneOptions,
                onChanged: (value) {
                  setState(() {
                    selectedTimezone = value;
                  });

                  if (inputController.text.trim().isNotEmpty) {
                    convertTimestamp();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ToolInput(
            controller: inputController,
            label: 'Timestamp',
            hintText: '例如：1718000000 或 1718000000000',
            onSubmitted: (_) => convertTimestamp(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ToolResultPanel(
              child: SelectableText(
                outputController.text.isEmpty
                    ? '转换结果会显示在这里'
                    : outputController.text,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
