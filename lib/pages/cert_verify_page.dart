import 'package:flutter/material.dart';

class CertVerifyPage extends StatefulWidget {
  const CertVerifyPage({super.key});

  @override
  State<CertVerifyPage> createState() => _CertVerifyPageState();
}

class _CertVerifyPageState extends State<CertVerifyPage> {
  final TextEditingController _certController = TextEditingController();
  String _certData = '';
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('证书验证')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _certController,
                    decoration: const InputDecoration(labelText: '证书内容'),
                    maxLines: 5,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: _pickCertFile,
                ),
              ],
            ),
            ElevatedButton(onPressed: _verifyCert, child: const Text('验证证书')),
            const SizedBox(height: 20),
            Text('证书数据：\n$_certData'),
            const SizedBox(height: 10),
            Text(
              _isValid ? '验证通过 ✅' : '验证失败 ❌',
              style: TextStyle(
                color: _isValid ? Colors.green : Colors.red,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickCertFile() {}
  void _verifyCert() {
    // 调用验证方法
    setState(() {
      _certData = '解析后的数据\n签名结果：XXXXX';
      _isValid = true;
    });
  }
}
