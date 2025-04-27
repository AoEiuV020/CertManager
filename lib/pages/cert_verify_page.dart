import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/cert.dart';
import '../widgets/file_input_field.dart';

class CertVerifyPage extends StatefulWidget {
  const CertVerifyPage({super.key});

  @override
  State<CertVerifyPage> createState() => _CertVerifyPageState();
}

class _CertVerifyPageState extends State<CertVerifyPage> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _publicKeyController = TextEditingController();
  final TextEditingController _certController = TextEditingController();
  bool? _isValid;
  final TextEditingController _certDataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('证书验证')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            FileInputField(controller: _keyController, labelText: '私钥'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _parsePublicKey,
              child: const Text('从私钥读取公钥'),
            ),
            const SizedBox(height: 8),
            FileInputField(controller: _publicKeyController, labelText: '公钥'),
            const SizedBox(height: 8),
            FileInputField(controller: _certController, labelText: '证书内容'),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _verifyCert, child: const Text('验证证书')),
            const Divider(),
            const SizedBox(height: 20),
            FileInputField(
              controller: _certDataController,
              labelText: '证书数据',
              readOnly: true,
            ),
            const SizedBox(height: 10),
            if (_isValid != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isValid! ? '验证通过 ✅' : '验证失败 ❌',
                    style: TextStyle(
                      color: _isValid! ? Colors.green : Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  if (_isValid!)
                    Text(
                      '有效期至: ${_formatValidTo(_certDataController.text)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _parsePublicKey() async {
    final keyContent = _keyController.text;
    if (keyContent.isEmpty) {
      return;
    }

    final publicKey = CertUtils.extractPublicKey(keyContent);
    setState(() {
      _publicKeyController.text = publicKey;
    });
  }

  String _formatValidTo(String certData) {
    try {
      final validTo = jsonDecode(certData)['validTo'];
      return validTo != null
          ? DateTime.fromMillisecondsSinceEpoch(validTo).toString()
          : '未知';
    } catch (e) {
      return '未知';
    }
  }

  Future<void> _verifyCert() async {
    final certContent = _certController.text;
    if (certContent.isEmpty) {
      setState(() {
        _certDataController.text = '';
        _isValid = null;
      });
      return;
    }

    final result = CertUtils.verifyCertificate(
      certContent,
      _publicKeyController.text,
    );

    setState(() {
      _certDataController.text = result.data;
      _isValid = result.isValid;
    });
  }
}
