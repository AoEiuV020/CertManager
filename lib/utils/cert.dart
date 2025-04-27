import 'dart:convert';
import 'dart:typed_data';

import 'package:secure_utils/secure_utils.dart';

class CertUtils {
  CertUtils._();
  static ({String publicKey, String privateKey}) genKeyPair() {
    final pair = RSA.genKeyPair();
    return (
      publicKey: pair.getPublicKeyBase64(),
      privateKey: pair.getPrivateKeyBase64(),
    );
  }

  static String extractPublicKey(String privateKey) {
    throw UnimplementedError();
  }

  static String generateCertificate(
    Map<String, String> data,
    String privateKey,
  ) {
    final value = jsonEncode(data);
    final signed = RSA.sign(
      Uint8List.fromList(value.codeUnits),
      base64Decode(privateKey),
    );
    return '${base64Encode(value.codeUnits)}.${base64Encode(signed)}';
  }

  static ({String data, bool isValid}) verifyCertificate(
    String certificate,
    String publicKey,
  ) {
    try {
      final parts = certificate.split('.');
      if (parts.length != 2) return (data: '', isValid: false);

      final data = base64Decode(parts[0]);
      final signature = base64Decode(parts[1]);

      final isValid = RSA.verify(data, base64Decode(publicKey), signature);

      return (data: String.fromCharCodes(data), isValid: isValid);
    } catch (e) {
      return (data: '解析错误: $e', isValid: false);
    }
  }
}
