import 'package:flutter/material.dart';

class RsaTestPage extends StatefulWidget {
  const RsaTestPage({super.key});

  @override
  State<RsaTestPage> createState() => _RsaTestPageState();
}

class _RsaTestPageState extends State<RsaTestPage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  final TextEditingController _signController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RSA加解密测试')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(labelText: '明文/密文'),
              maxLines: 3,
            ),
            Row(
              children: [
                ElevatedButton(onPressed: _encrypt, child: const Text('加密')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _decrypt, child: const Text('解密')),
              ],
            ),
            TextField(
              controller: _outputController,
              decoration: const InputDecoration(labelText: '结果'),
              maxLines: 3,
              readOnly: true,
            ),
            const Divider(),
            TextField(
              controller: _signController,
              decoration: const InputDecoration(labelText: '签名数据'),
              maxLines: 3,
            ),
            ElevatedButton(onPressed: _sign, child: const Text('生成签名')),
            TextField(
              controller: _verifyController,
              decoration: const InputDecoration(labelText: '验证结果'),
              maxLines: 3,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  void _encrypt() {}
  void _decrypt() {}
  void _sign() {}
}
