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

  static String generateSignature(Map<String, String> data, String privateKey) {
    final value = Parameter.concatValues(data);
    final signed = RSA.sign(
      Uint8List.fromList(value.codeUnits),
      base64Decode(privateKey),
    );
    return base64Encode(signed);
  }
}
