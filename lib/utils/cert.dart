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
    return base64Encode(RSA.extractPublicKey(base64Decode(privateKey)));
  }

  static String generateCertificate(
    Map<String, dynamic> data,
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

      final str = String.fromCharCodes(data);
      if (isValid) {
        // 验证时间有效性
        final map = jsonDecode(str);
        if (map['validFrom'] != null && map['validTo'] != null) {
          final now = DateTime.now();
          final validFrom = DateTime.fromMillisecondsSinceEpoch(
            map['validFrom'],
          );
          final validTo = DateTime.fromMillisecondsSinceEpoch(map['validTo']);
          if (now.isBefore(validFrom) || now.isAfter(validTo)) {
            return (data: '', isValid: false);
          }
        } else {
          return (data: '', isValid: false);
        }
      }

      return (data: str, isValid: isValid);
    } catch (e) {
      return (data: '', isValid: false);
    }
  }
}
