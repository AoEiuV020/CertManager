import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('证书管理系统')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildFeatureCard(context, 'RSA测试', Icons.security, '/rsa_test'),
          _buildFeatureCard(context, '生成密钥', Icons.vpn_key, '/key_gen'),
          _buildFeatureCard(context, '颁发证书', Icons.assignment, '/cert_issue'),
          _buildFeatureCard(context, '验证证书', Icons.verified, '/cert_verify'),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.pushNamed(context, route),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
