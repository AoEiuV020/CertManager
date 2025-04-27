// 假设以下抽象类已实现
import 'dart:convert';
import 'dart:typed_data';

class RSA {
  static RsaKeyPair genKeyPair() => RsaKeyPair(Uint8List(0), Uint8List(0));
  static String encryptBase64(Uint8List data, Uint8List publicKey) =>
      throw UnimplementedError();
  static Uint8List decryptFromBase64(String encrypted, Uint8List privateKey) =>
      throw UnimplementedError();
  static String signBase64(String data, Uint8List privateKey) =>
      throw UnimplementedError();
  static Uint8List sign(Uint8List data, Uint8List privateKey) =>
      throw UnimplementedError();
  static bool verifyFromBase64(
    String data,
    Uint8List publicKey,
    String signature,
  ) => throw UnimplementedError();
  static bool verify(
    Uint8List data,
    Uint8List publicKey,
    Uint8List signature,
  ) => throw UnimplementedError();
}

class RsaKeyPair {
  final Uint8List publicKey;
  final Uint8List privateKey;

  RsaKeyPair(this.publicKey, this.privateKey);

  String getPublicKeyBase64() => base64Encode(publicKey);
  String getPrivateKeyBase64() => base64Encode(privateKey);
}
