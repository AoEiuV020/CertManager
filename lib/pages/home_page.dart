import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('证书管理系统')),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        childAspectRatio: 1.5,
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
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
