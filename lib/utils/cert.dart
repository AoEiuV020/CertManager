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
    String publicKey, {
    Map<String, dynamic>? checkValues,
  }) {
    var str = '';
    try {
      final parts = certificate.split('.');
      if (parts.length != 2) return (data: '', isValid: false);

      final data = base64Decode(parts[0]);
      str = String.fromCharCodes(data);
      final signature = base64Decode(parts[1].trim());

      final isValid = RSA.verify(data, base64Decode(publicKey), signature);

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
            return (data: str, isValid: false);
          }
        } else {
          return (data: str, isValid: false);
        }

        // 校验额外参数值
        if (checkValues != null) {
          for (final entry in checkValues.entries) {
            if (map[entry.key] != entry.value) {
              return (data: str, isValid: false);
            }
          }
        }
      }

      return (data: str, isValid: isValid);
    } catch (e) {
      return (data: str, isValid: false);
    }
  }
}
