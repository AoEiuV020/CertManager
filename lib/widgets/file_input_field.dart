import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';

import '../utils/ext.dart';

class FileInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const FileInputField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final files = result.xFiles;
    if (files.isEmpty) return;
    final file = files.first;
    final content = await file.readAsString();
    controller.text = content;
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    if (controller.text.isEmpty) return;
    try {
      await Clipboard.setData(ClipboardData(text: controller.text));
      if (context.mounted) {
        context.showSnackBar(content: '已复制到剪贴板');
      }
    } catch (e) {
      if (context.mounted) {
        context.dialog(content: '复制失败: ${e.toString()}');
      }
    }
  }

  Future<void> _saveFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: '保存文件',
        fileName: '$labelText.dat',
        bytes: Uint8List.fromList(controller.text.codeUnits),
      );

      if (result == null || controller.text.isEmpty) return;

      if (context.mounted) {
        context.dialog(content: '文件已保存至：$result');
      }
    } catch (e) {
      if (context.mounted) {
        context.dialog(content: '保存失败：${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.upload_file),
          onPressed: () => _pickFile(context),
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () => _copyToClipboard(context),
        ),
        IconButton(
          icon: const Icon(Icons.save_alt),
          onPressed: () => _saveFile(context),
        ),
      ],
    );
  }
}
