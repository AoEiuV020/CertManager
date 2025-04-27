import 'package:flutter/material.dart';

class CertIssuePage extends StatefulWidget {
  const CertIssuePage({super.key});

  @override
  State<CertIssuePage> createState() => _CertIssuePageState();
}

class _CertIssuePageState extends State<CertIssuePage> {
  final List<TextEditingController> _keyControllers = [];
  final TextEditingController _keyInputController = TextEditingController();
  final String _signature = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('颁发证书')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildKeySelector(),
            const Divider(),
            _buildKeyValueFields(),
            const Divider(),
            Text(_signature, style: const TextStyle(color: Colors.green)),
            ElevatedButton(
              onPressed: _generateSignature,
              child: const Text('生成证书签名'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeySelector() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _keyInputController,
            decoration: const InputDecoration(labelText: '私钥Base64或文件路径'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.upload_file),
          onPressed: () => _pickKeyFile(),
        ),
      ],
    );
  }

  Widget _buildKeyValueFields() {
    return Column(
      children: [
        ..._keyControllers.map(
          (controller) => TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '键值对'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed:
              () => setState(() {
                _keyControllers.add(TextEditingController());
              }),
        ),
      ],
    );
  }

  void _pickKeyFile() {}
  void _generateSignature() {}
}
