import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/json_service.dart';
import '../widgets/json_tree_view.dart';
import '../widgets/tool_button.dart';
import '../widgets/tool_page.dart';
import '../widgets/split_panel.dart';
import '../core/clipboard_helper.dart';
import '../core/snackbar_helper.dart';
import '../widgets/tool_text_area.dart';
import '../widgets/tool_result_panel.dart';

class JsonPage extends StatefulWidget {
  const JsonPage({super.key});

  @override
  State<JsonPage> createState() => _JsonPageState();
}

class _JsonPageState extends State<JsonPage> {
  final inputController = TextEditingController();
  final outputController = TextEditingController();

  dynamic parsedJson;
  String? errorText;

  void parseJson({required bool pretty}) {
    final text = inputController.text.trim();

    if (text.isEmpty) {
      setState(() {
        parsedJson = null;
        errorText = '请输入 JSON 内容';
      });
      return;
    }

    try {
      final json = jsonDecode(text);

      setState(() {
        parsedJson = json;
        errorText = null;

        outputController.text = pretty
            ? JsonService.format(text)
            : JsonService.minify(text);
      });
    } catch (e) {
      setState(() {
        parsedJson = null;
        errorText = 'JSON 格式错误';
      });
    }
  }

  void formatJson() {
    parseJson(pretty: true);
  }

  void minifyJson() {
    parseJson(pretty: false);
  }

  void clearAll() {
    setState(() {
      inputController.clear();
      outputController.clear();
      parsedJson = null;
      errorText = null;
    });
  }

  Future<void> copyOutput() async {
    final text = outputController.text.trim();

    if (text.isEmpty) {
      SnackBarHelper.show(context, '没有可复制的内容');
      return;
    }

    await ClipboardHelper.copy(text);

    if (!mounted) return;
    SnackBarHelper.show(context, '已复制');
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
      toolbar: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ToolButton(label: '格式化', primary: true, onPressed: formatJson),
          ToolButton(label: '压缩', onPressed: minifyJson),
          ToolButton(label: '复制结果', onPressed: copyOutput),
          ToolButton(label: '清空', onPressed: clearAll),
        ],
      ),
      content: SplitPanel(
        left: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter, control: true):
                FormatJsonIntent(),
            SingleActivator(LogicalKeyboardKey.enter, meta: true):
                FormatJsonIntent(),
          },
          child: Actions(
            actions: {
              FormatJsonIntent: CallbackAction<FormatJsonIntent>(
                onInvoke: (_) {
                  formatJson();
                  return null;
                },
              ),
            },
            child: Focus(
              autofocus: true,
              child: ToolTextArea(
                controller: inputController,
                label: 'Input JSON',
                hintText: '请输入 JSON 内容',
                helperText: '快捷键：Ctrl + Enter / Cmd + Enter 格式化',
              ),
            ),
          ),
        ),
        right: SizedBox.expand(
          child: ToolResultPanel(
            child: errorText != null
                ? Text(errorText!)
                : parsedJson == null
                ? const Center(child: Text('格式化后会在这里显示树结构'))
                : JsonTreeView(data: parsedJson),
          ),
        ),
      ),
    );
  }
}

class FormatJsonIntent extends Intent {
  const FormatJsonIntent();
}
