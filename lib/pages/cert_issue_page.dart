import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:secure_utils/secure_utils.dart';

import '../widgets/file_input_field.dart';

class CertIssuePage extends StatefulWidget {
  const CertIssuePage({super.key});

  @override
  State<CertIssuePage> createState() => _CertIssuePageState();
}

class FieldConfig {
  final String label;
  final String key;
  final TextEditingController controller;

  const FieldConfig({
    required this.label,
    required this.key,
    required this.controller,
  });
}

class _CertIssuePageState extends State<CertIssuePage> {
  final List<FieldConfig> _fieldConfigs = [
    FieldConfig(
      label: '域名',
      key: 'domain',
      controller: TextEditingController(),
    ),
    FieldConfig(
      label: '公司名称',
      key: 'company',
      controller: TextEditingController(),
    ),
  ];
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _signController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('颁发证书'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FileInputField(labelText: '私钥文件', controller: _keyController),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _generateSignature,
              child: Text('生成证书签名'),
            ),
            SizedBox(height: 8),
            FileInputField(
              labelText: '生成的证书',
              controller: _signController,
              readOnly: true,
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _fieldConfigs.length,
                itemBuilder: (context, index) {
                  final config = _fieldConfigs[index];
                  return Column(
                    children: [
                      FileInputField(
                        labelText: config.label,
                        controller: config.controller,
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateSignature() {
    final data = Map.fromEntries(
      _fieldConfigs.map(
        (e) => MapEntry<String, String>(e.key, e.controller.text),
      ),
    );
    final value = Parameter.concatValues(data);
    final signed = RSA.sign(
      Uint8List.fromList(value.codeUnits),
      base64Decode(_keyController.text),
    );
    setState(() {
      _signController.text = base64Encode(signed);
    });
  }
}
