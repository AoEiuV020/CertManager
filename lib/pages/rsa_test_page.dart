import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:secure_utils/secure_utils.dart';

import '../utils/ext.dart';
import '../widgets/file_input_field.dart';

class RsaTestPage extends StatefulWidget {
  const RsaTestPage({super.key});

  @override
  State<RsaTestPage> createState() => _RsaTestPageState();
}

class _RsaTestPageState extends State<RsaTestPage> {
  final TextEditingController _privateKeyController = TextEditingController();
  final TextEditingController _publicKeyController = TextEditingController();
  final TextEditingController _plainTextController = TextEditingController();
  final TextEditingController _cipherTextController = TextEditingController();
  final TextEditingController _signController = TextEditingController();
  bool? _isValid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RSA加解密测试')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            FileInputField(labelText: '私钥', controller: _privateKeyController),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _generateKeyPair,
                    child: const Text('生成密钥对'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _extractPublicKey,
                    child: const Text('从私钥读取公钥'),
                  ),
                ),
              ],
            ),
            FileInputField(labelText: '公钥', controller: _publicKeyController),
            const Divider(),
            FileInputField(labelText: '明文', controller: _plainTextController),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _encrypt,
                    child: const Text('加密'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _decrypt,
                    child: const Text('解密'),
                  ),
                ),
              ],
            ),
            FileInputField(labelText: '密文', controller: _cipherTextController),
            const Divider(),
            FileInputField(labelText: '签名数据', controller: _signController),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _sign,
                    child: const Text('生成签名'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _verify,
                    child: const Text('验证签名'),
                  ),
                ),
              ],
            ),
            if (_isValid != null)
              Text(
                _isValid! ? '验证通过 ✅' : '验证失败 ❌',
                style: TextStyle(
                  color: _isValid! ? Colors.green : Colors.red,
                  fontSize: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _extractPublicKey() {
    try {
      final publicKey = RSA.extractPublicKey(
        base64Decode(_privateKeyController.text),
      );
      _publicKeyController.text = base64Encode(publicKey);
    } catch (e) {
      context.dialog(content: '提取公钥失败: $e');
    }
  }

  void _encrypt() {
    try {
      final cipherText = RSA.encrypt(
        base64Decode(_plainTextController.text),
        base64Decode(_publicKeyController.text),
      );
      _cipherTextController.text = base64Encode(cipherText);
    } catch (e) {
      context.dialog(content: '加密失败: $e');
    }
  }

  void _decrypt() {
    try {
      final plainText = RSA.decrypt(
        base64Decode(_cipherTextController.text),
        base64Decode(_privateKeyController.text),
      );
      _plainTextController.text = base64Encode(plainText);
    } catch (e) {
      context.dialog(content: '解密失败: $e');
    }
  }

  void _sign() {
    try {
      final signature = RSA.sign(
        base64Decode(_plainTextController.text),
        base64Decode(_privateKeyController.text),
      );
      _signController.text = base64Encode(signature);
    } catch (e) {
      context.dialog(content: '签名失败: $e');
    }
    setState(() => _isValid = null);
  }

  void _verify() {
    try {
      final isValid = RSA.verify(
        base64Decode(_plainTextController.text),
        base64Decode(_publicKeyController.text),
        base64Decode(_signController.text),
      );
      setState(() => _isValid = isValid);
    } catch (e) {
      context.dialog(content: '验证失败: $e');
      setState(() => _isValid = false);
    }
  }

  void _generateKeyPair() {
    try {
      final keyPair = RSA.genKeyPair();
      _privateKeyController.text = base64Encode(keyPair.privateKey);
      _publicKeyController.text = base64Encode(keyPair.publicKey);
    } catch (e) {
      context.dialog(content: '生成密钥对失败: $e');
    }
  }
}
