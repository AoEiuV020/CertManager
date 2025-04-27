import 'package:flutter/material.dart';

import 'package:secure_utils/secure_utils.dart';

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
      appBar: AppBar(title: const Text('生成RSA密钥')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: _generateKey, child: const Text('生成新密钥')),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  FileInputField(
                    labelText: '私钥（Base64）',
                    controller: TextEditingController(text: _privateKey),
                  ),
                  const SizedBox(height: 10),
                  FileInputField(
                    labelText: '公钥（Base64）',
                    controller: TextEditingController(text: _publicKey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _generateKey() {
    // 调用RSA生成方法
    final pair = RSA.genKeyPair();
    setState(() {
      _privateKey = pair.getPrivateKeyBase64();
      _publicKey = pair.getPublicKeyBase64();
    });
  }
}
