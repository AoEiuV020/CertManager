import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/rsa_test_page.dart';
import 'pages/key_gen_page.dart';
import 'pages/cert_issue_page.dart';
import 'pages/cert_verify_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '证书管理系统',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/rsa_test': (context) => const RsaTestPage(),
        '/key_gen': (context) => const KeyGenPage(),
        '/cert_issue': (context) => const CertIssuePage(),
        '/cert_verify': (context) => const CertVerifyPage(),
      },
    );
  }
}
