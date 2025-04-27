import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/export.dart';

/// 私钥是pkcs1, 公钥是pkcs8,
class RSA {
  static RsaKeyPair genKeyPair() {
    final pair =
        CryptoUtils.generateRSAKeyPair()
            as AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>;
    return RsaKeyPair(
      CryptoUtils.encodeRSAPublicKeyToDERBytes(pair.publicKey),
      _convertPkcs8ToPkcs1(
        CryptoUtils.encodeRSAPrivateKeyToDERBytes(pair.privateKey),
      ),
    );
  }

  static String encryptBase64(Uint8List data, Uint8List publicKey) {
    final rsaPublicKey = CryptoUtils.rsaPublicKeyFromDERBytes(publicKey);
    var cipher =
        RSAEngine()..init(true, PublicKeyParameter<RSAPublicKey>(rsaPublicKey));
    var cipherText = cipher.process(data);
    return base64Encode(cipherText);
  }

  static Uint8List decryptFromBase64(String encrypted, Uint8List privateKey) {
    // 里面有个rsaPrivateKeyFromDERBytesPkcs1但不对，
    final rsaPrivateKey = CryptoUtils.rsaPrivateKeyFromDERBytes(privateKey);
    final encryptedBytes = base64Decode(encrypted);
    var cipher =
        RSAEngine()
          ..init(false, PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey));
    var decrypted = cipher.process(encryptedBytes);
    return decrypted;
  }

  static String signBase64(String data, Uint8List privateKey) {
    final signature = sign(utf8.encode(data), privateKey);
    return base64Encode(signature);
  }

  static Uint8List sign(Uint8List data, Uint8List privateKey) {
    final rsaPrivateKey = CryptoUtils.rsaPrivateKeyFromDERBytesPkcs1(
      privateKey,
    );
    return CryptoUtils.rsaSign(rsaPrivateKey, data);
  }

  static bool verifyFromBase64(
    String data,
    Uint8List publicKey,
    String signature,
  ) {
    return verify(utf8.encode(data), publicKey, base64Decode(signature));
  }

  static bool verify(Uint8List data, Uint8List publicKey, Uint8List signature) {
    final rsaPublicKey = CryptoUtils.rsaPublicKeyFromDERBytes(publicKey);
    return CryptoUtils.rsaVerify(rsaPublicKey, data, signature);
  }

  static Uint8List _convertPkcs8ToPkcs1(Uint8List pkcs8Bytes) {
    return Uint8List.sublistView(pkcs8Bytes, 26, pkcs8Bytes.length);
  }

  static Uint8List _convertPkcs1ToPkcs8(Uint8List pkcs1Bytes) {
    int pkcs1Length = pkcs1Bytes.length;
    int totalLength = pkcs1Length + 22;

    Uint8List pkcs8Header = Uint8List.fromList([
      0x30,
      (totalLength >> 8) & 0xff,
      totalLength & 0xff, // Sequence + total length
      0x02, 0x01, 0x00, // Integer (0)
      0x30,
      0x0D,
      0x06,
      0x09,
      0x2A,
      0x86,
      0x48,
      0x86,
      0xF7,
      0x0D,
      0x01,
      0x01,
      0x01,
      0x05,
      0x00, // Sequence: 1.2.840.113549.1.1.1, NULL
      0x04,
      (pkcs1Length >> 8) & 0xff,
      pkcs1Length & 0xff, // Octet string + length
    ]);

    return Uint8List.fromList([...pkcs8Header, ...pkcs1Bytes]);
  }
}

class RsaKeyPair {
  final Uint8List publicKey;
  final Uint8List privateKey;

  RsaKeyPair(this.publicKey, this.privateKey);

  String getPublicKeyBase64() => base64Encode(publicKey);
  String getPrivateKeyBase64() => base64Encode(privateKey);
}
