import 'package:flutter/material.dart';

import '../utils/cert.dart';
import '../widgets/file_input_field.dart';

class KeyGenPage extends StatefulWidget {
  const KeyGenPage({super.key});

  @override
  State<KeyGenPage> createState() => _KeyGenPageState();
}

class _KeyGenPageState extends State<KeyGenPage> {
  String _privateKey = '';
  String _publicKey = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('生成密钥')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(onPressed: _generateKey, child: const Text('生成新密钥')),
            const SizedBox(height: 20),
            FileInputField(
              labelText: '私钥',
              controller: TextEditingController(text: _privateKey),
            ),
            const SizedBox(height: 10),
            FileInputField(
              labelText: '公钥',
              controller: TextEditingController(text: _publicKey),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _generateKey() {
    final pair = CertUtils.genKeyPair();
    setState(() {
      _privateKey = pair.privateKey;
      _publicKey = pair.publicKey;
    });
  }
}
