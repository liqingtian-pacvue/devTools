import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/clipboard_helper.dart';
import '../core/snackbar_helper.dart';
import '../core/timezone_constants.dart';
import '../services/timestamp_service.dart';
import '../widgets/tool_button.dart';
import '../widgets/tool_input.dart';
import '../widgets/tool_page.dart';
import '../widgets/tool_result_panel.dart';
import '../widgets/tool_select.dart';

class TimestampPage extends StatefulWidget {
  const TimestampPage({super.key});

  @override
  State<TimestampPage> createState() => _TimestampPageState();
}

class _TimestampPageState extends State<TimestampPage> {
  final inputController = TextEditingController();

  String selectedTimezone = 'Asia/Shanghai';
  String outputText = '';

  final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  void convertTimestamp() {
    final text = inputController.text.trim();

    if (text.isEmpty) {
      showMessage('请输入时间戳');
      return;
    }

    try {
      final utcDateTime = TimestampService.fromTimestamp(text);
      final targetDateTime = TimestampService.convertToTimezone(
        utcDateTime,
        selectedTimezone,
      );

      setState(() {
        outputText = [
          'Timezone: $selectedTimezone',
          '',
          'Selected Time:',
          dateFormat.format(targetDateTime),
          '',
          'UTC Time:',
          dateFormat.format(utcDateTime.toUtc()),
          '',
          'Local Time:',
          dateFormat.format(utcDateTime.toLocal()),
          '',
          'Unix Seconds:',
          '${utcDateTime.millisecondsSinceEpoch ~/ 1000}',
          '',
          'Unix Milliseconds:',
          '${utcDateTime.millisecondsSinceEpoch}',
        ].join('\n');
      });
    } catch (_) {
      showMessage('时间戳格式错误');
    }
  }

  void useCurrentTime() {
    final now = DateTime.now().toUtc();

    setState(() {
      inputController.text = now.millisecondsSinceEpoch.toString();
    });

    convertTimestamp();
  }

  Future<void> copyOutput() async {
    if (outputText.isEmpty) {
      showMessage('没有可复制的内容');
      return;
    }

    await ClipboardHelper.copy(outputText);

    if (!mounted) return;
    showMessage('已复制');
  }

  void clearAll() {
    setState(() {
      inputController.clear();
      outputText = '';
    });
  }

  void showMessage(String message) {
    SnackBarHelper.show(context, message);
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToolPage(
      toolbar: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ToolButton(
            label: '转换',
            primary: true,
            onPressed: convertTimestamp,
          ),
          ToolButton(
            label: '当前时间',
            onPressed: useCurrentTime,
          ),
          ToolButton(
            label: '复制结果',
            onPressed: copyOutput,
          ),
          ToolButton(
            label: '清空',
            onPressed: clearAll,
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToolSelect(
            label: '显示时区',
            value: selectedTimezone,
            options: TimezoneConstants.options,
            onChanged: (value) {
              setState(() {
                selectedTimezone = value;
              });

              if (inputController.text.trim().isNotEmpty) {
                convertTimestamp();
              }
            },
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
                outputText.isEmpty ? '转换结果会显示在这里' : outputText,
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