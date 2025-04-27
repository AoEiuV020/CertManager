import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'dart:typed_data';
import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:pointycastle/pointycastle.dart';

/// 私钥是pkcs1, 公钥是pkcs8,
class RSA {
  static RsaKeyPair genKeyPair() {
    final pair =
        CryptoUtils.generateRSAKeyPair()
            as AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>;
    return RsaKeyPair(
      CryptoUtils.encodeRSAPublicKeyToDERBytes(pair.publicKey),
      _convertPkcs8ToPkcs1(CryptoUtils.encodeRSAPrivateKeyToDERBytes(pair.privateKey)),
    );
  }

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
static Uint8List _convertPkcs8ToPkcs1(Uint8List pkcs8Bytes) {
  return Uint8List.sublistView(pkcs8Bytes, 26, pkcs8Bytes.length);
}
 static  Uint8List _convertPkcs1ToPkcs8(Uint8List pkcs1Bytes) {
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
