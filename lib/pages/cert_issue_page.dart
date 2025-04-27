import 'package:flutter/material.dart';

import '../utils/cert.dart';
import '../widgets/date_time_picker.dart';
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
  final TextEditingController _certController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 90));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('颁发证书')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            FileInputField(labelText: '私钥（Base64）', controller: _keyController),
            SizedBox(height: 8),
            ElevatedButton(onPressed: _generateSignature, child: Text('生成证书')),
            SizedBox(height: 8),
            FileInputField(
              labelText: '生成的证书',
              controller: _certController,
              readOnly: true,
            ),
            SizedBox(height: 8),
            DateTimePickerWidget(
              title: '有效期开始时间',
              date: _startDate,
              firstDate: DateTime.now(),
              lastDate: _startDate.add(Duration(days: 365 * 10)),
              onChanged: (date) => setState(() => _startDate = date),
            ),
            SizedBox(height: 8),
            DateTimePickerWidget(
              title: '有效期结束时间',
              date: _endDate,
              firstDate: _startDate,
              lastDate: _startDate.add(Duration(days: 365 * 100)),
              onChanged: (date) => setState(() => _endDate = date),
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            ListView.builder(
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
    setState(() {
      _certController.text = CertUtils.generateCertificate({
        ...data,
        'validFrom': _startDate.millisecondsSinceEpoch,
        'validTo': _endDate.millisecondsSinceEpoch,
      }, _keyController.text);
    });
  }
}
