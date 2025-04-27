import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/export.dart';

/// 私钥是pkcs1, 公钥是pkcs8,
class RSA {
  RSA._();

  /// The default value for the [keySize] is 2048 bits.
  ///
  /// The following keySize is supported:
  /// * 1024
  /// * 2048
  /// * 3072
  /// * 4096
  /// * 8192
  static RsaKeyPair genKeyPair({int keySize = 2048}) {
    final pair =
        CryptoUtils.generateRSAKeyPair(keySize: keySize)
            as AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>;
    return RsaKeyPair(
      CryptoUtils.encodeRSAPublicKeyToDERBytes(pair.publicKey),
      _convertPkcs8ToPkcs1(
        CryptoUtils.encodeRSAPrivateKeyToDERBytes(pair.privateKey),
      ),
    );
  }

  static Uint8List extractPublicKey(Uint8List privateKey) {
    final rsaPrivateKey = _getRsaPrivateKey(privateKey);
    final rsaPublicKey = RSAPublicKey(
      rsaPrivateKey.modulus!,
      BigInt.parse('65537'),
    );
    return CryptoUtils.encodeRSAPublicKeyToDERBytes(rsaPublicKey);
  }

  static String encryptBase64(Uint8List data, Uint8List publicKey) {
    final encryptedData = encrypt(data, publicKey);
    return base64Encode(encryptedData);
  }

  static Uint8List encrypt(Uint8List data, Uint8List publicKey) {
    final rsaPublicKey = _getRsaPublicKey(publicKey);
    return _processRSA(data, true, rsaPublicKey);
  }

  static Uint8List decryptFromBase64(String encrypted, Uint8List privateKey) {
    final encryptedBytes = base64Decode(encrypted);
    return decrypt(encryptedBytes, privateKey);
  }

  static Uint8List decrypt(Uint8List encryptedData, Uint8List privateKey) {
    final rsaPrivateKey = _getRsaPrivateKey(privateKey);
    return _processRSA(encryptedData, false, rsaPrivateKey);
  }

  static String signBase64(String data, Uint8List privateKey) {
    final signature = sign(utf8.encode(data), privateKey);
    return base64Encode(signature);
  }

  static Uint8List sign(Uint8List data, Uint8List privateKey) {
    final rsaPrivateKey = _getRsaPrivateKey(privateKey);
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
    final rsaPublicKey = _getRsaPublicKey(publicKey);
    return CryptoUtils.rsaVerify(rsaPublicKey, data, signature);
  }

  // 私有辅助方法
  static RSAPublicKey _getRsaPublicKey(Uint8List publicKey) {
    return CryptoUtils.rsaPublicKeyFromDERBytes(publicKey);
  }

  static RSAPrivateKey _getRsaPrivateKey(Uint8List privateKey) {
    try {
      return CryptoUtils.rsaPrivateKeyFromDERBytesPkcs1(privateKey);
    } catch (e) {
      // 如果默认解析失败，尝试使用PKCS8格式解析
      return CryptoUtils.rsaPrivateKeyFromDERBytes(privateKey);
    }
  }

  static Uint8List _processRSA(Uint8List data, bool isEncrypt, dynamic key) {
    // 效果同java的 RSA/ECB/PKCS1Padding
    final cipher = PKCS1Encoding(RSAEngine())..init(
      isEncrypt,
      isEncrypt
          ? PublicKeyParameter<RSAPublicKey>(key)
          : PrivateKeyParameter<RSAPrivateKey>(key),
    );
    return cipher.process(data);
  }

  static Uint8List _convertPkcs8ToPkcs1(Uint8List pkcs8Bytes) {
    return Uint8List.sublistView(pkcs8Bytes, 26, pkcs8Bytes.length);
  }

  // ignore: unused_element
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
