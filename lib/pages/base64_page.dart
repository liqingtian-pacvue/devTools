import 'package:flutter/material.dart';

import '../core/clipboard_helper.dart';
import '../core/snackbar_helper.dart';
import '../services/base64_service.dart';
import '../widgets/split_panel.dart';
import '../widgets/tool_button.dart';
import '../widgets/tool_page.dart';
import '../widgets/tool_result_panel.dart';
import '../widgets/tool_text_area.dart';

class Base64Page extends StatefulWidget {
  const Base64Page({super.key});

  @override
  State<Base64Page> createState() => _Base64PageState();
}

class _Base64PageState extends State<Base64Page> {
  final inputController = TextEditingController();
  String outputText = '';

  void encode() {
    final text = inputController.text;

    if (text.isEmpty) {
      showMessage('请输入内容');
      return;
    }

    setState(() {
      outputText = Base64Service.encode(text);
    });
  }

  void decode() {
    final text = inputController.text.trim();

    if (text.isEmpty) {
      showMessage('请输入 Base64 内容');
      return;
    }

    try {
      setState(() {
        outputText = Base64Service.decode(text);
      });
    } catch (_) {
      showMessage('Base64 解码失败');
    }
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
          ToolButton(label: '编码', primary: true, onPressed: encode),
          ToolButton(label: '解码', onPressed: decode),
          ToolButton(label: '复制结果', onPressed: copyOutput),
          ToolButton(label: '清空', onPressed: clearAll),
        ],
      ),
      content: SplitPanel(
        left: ToolTextArea(
          controller: inputController,
          label: 'Input',
          hintText: '请输入待编码或解码内容',
        ),
        right: SizedBox.expand(
          child: ToolResultPanel(
            child: outputText.isEmpty
                ? const Center(child: Text('格式化后会在这里显示树结构'))
                : SelectableText(
                    outputText,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}