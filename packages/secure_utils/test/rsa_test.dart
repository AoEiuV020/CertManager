import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';

import 'package:secure_utils/src/rsa.dart';

void main() {
  group('RSA Tests', () {
    test('genKeyPair should generate valid key pair', () {
      final pair = RSA.genKeyPair();
      print(pair.getPublicKeyBase64());
      print(pair.getPrivateKeyBase64());

      expect(pair.publicKey, isNotNull);
      expect(pair.privateKey, isNotNull);
      expect(base64Decode(pair.getPublicKeyBase64()), equals(pair.publicKey));
    });

    test('pkcs1 to 8', () {
      final pkcs8 = keyPair.privateKey;
      final pkcs1 = RSA.convertPkcs8ToPkcs1(pkcs8);
      final newPkcs8 = RSA.convertPkcs1ToPkcs8(pkcs1);
      expect(newPkcs8, equals(pkcs8));
    });

    test('publicEncrypt/decrypt should work', () {
      final encrypted = RSA.encryptBase64(
        utf8.encode(content),
        keyPair.publicKey,
      );
      final decrypted = RSA.decryptFromBase64(encrypted, keyPair.privateKey);

      expect(utf8.decode(decrypted), equals(content));
    });

    test('pkcs1 key should work', () {
      final encrypted = RSA.encryptBase64(
        utf8.encode(content),
        keyPairPkcs1.publicKey,
      );
      final decrypted = RSA.decryptFromBase64(
        encrypted,
        keyPairPkcs1.privateKey,
      );

      expect(utf8.decode(decrypted), equals(content));
    });

    test('sign and verify should work', () {
      final signature = RSA.signBase64(content, keyPair.privateKey);
      print(signature);
      expect(
        RSA.verifyFromBase64(content, keyPair.publicKey, signature),
        isTrue,
      );
    });

    test('verify with wrong content should fail', () {
      expect(
        RSA.verify(
          Uint8List.fromList('wrong content'.codeUnits),
          keyPair.publicKey,
          signRaw,
        ),
        isFalse,
      );
    });

    test('pkcs1 key sign and verify should work', () {
      final signature = RSA.signBase64(content, keyPairPkcs1.privateKey);
      expect(
        RSA.verifyFromBase64(content, keyPairPkcs1.publicKey, signature),
        isTrue,
      );
    });

    test('precomputed encryption should match', () {
      final encrypted = RSA.encrypt(contentRaw, keyPair.publicKey);
      print(base64Encode(encrypted));
      // RSA/ECB/PKCS1Padding 每次加密都不同，所以这里不匹配，
      expect(encrypted, isNot(equals(encryptedRaw)));
    });

    test('precomputed decryption should match', () {
      final decrypted = RSA.decrypt(encryptedRaw, keyPairPkcs1.privateKey);
      expect(decrypted, equals(contentRaw));
    });

    test('precomputed signature should match', () {
      final signed = RSA.sign(contentRaw, keyPair.privateKey);
      print(base64Encode(signed));
      expect(signed, equals(signRaw));
    });
    test('precomputed signature should verify', () {
      expect(RSA.verify(contentRaw, keyPair.publicKey, signRaw), isTrue);
    });

    test('precomputed signature should match sha1', () {
      final signed = RSA.sign(
        contentRaw,
        keyPairPkcs1.privateKey,
        algorithm: 'SHA-1/RSA',
      );
      print(base64Encode(signed));
      expect(signed, equals(signRawSha1));
    });
    test('precomputed signature should verify sha1', () {
      expect(
        RSA.verify(
          contentRaw,
          keyPairPkcs1.publicKey,
          signRawSha1,
          algorithm: 'SHA-1/RSA',
        ),
        isTrue,
      );
    });

    test('extractPublicKey should work', () {
      final extractedPublicKey = RSA.extractPublicKey(keyPair.privateKey);
      expect(extractedPublicKey, equals(keyPair.publicKey));
    });

    test('pkcs1 extractPublicKey should work', () {
      final extractedPublicKey = RSA.extractPublicKey(keyPairPkcs1.privateKey);
      expect(extractedPublicKey, equals(keyPairPkcs1.publicKey));
    });
  });
}

final keyPair = RsaKeyPair(
  base64Decode(
    """MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCLjXCd0y8wucMlQDd9S9cFeCA0H
/l/prnouwWgGOEzoaS1gBK4IK0AAiNd7mz8EP+4m9DqeaGW63ei3aws43qV1lDpsVepfJ2PPe/5
VBx7uAKKGqPU+IlNP6EBWUWMMsrCS/oh6LHucCyLah5YhyXOju1cZTfqQ1VFWsbZupmUaQIDAQAB"""
        .replaceAll("\n", ""),
  ),
  base64Decode(
    """MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAIuNcJ3TLzC5wyVAN31L
1wV4IDQf+X+muei7BaAY4TOhpLWAErggrQACI13ubPwQ/7ib0Op5oZbrd6LdrCzjepXWUOmxV6l8
nY897/lUHHu4Aooao9T4iU0/oQFZRYwyysJL+iHose5wLItqHliHJc6O7VxlN+pDVUVaxtm6mZRpA
gMBAAECgYAKHDkodgBZO1wT+s8KWNA/KTDMFfTxdpbJcaM6shK+tttD+v9gL53Y/k6po3hp2qFsM
n20PxOh53VHa1/p8KEU1j+DwLbNC5eIp7/5ZNWwftQTSHBCqSyr+7rE0i6Gcst1qT0ioKUS1fOHI
ZSt0gfBOf1eEzhpLDT1o0QgY98cAQJBANrWFNml89xHZQAUmXvrcC/vzmbfktWuHpTP4gRoURp4U
h7j07xD7dVN/gbk42K70VWCTWTRSARApA9IfjACuqECQQCjQH4hh/2H70b23h3OUfiGUSnhupoNU
z93xTsaBYbwiTGYH81Sno5aQbO3j8H9gi8qZanSHRG24MUVeyQdRYzJAkBHJ0aeQgxZeklHzmrdV
P8kRwfIgTdgDP5aioFFx5lfTvH8oz1MQJYLPhGzsiaRCtqUwApkFnwhDdeKNJr7B1ghAkEAm/knS
TQbp/+VxpGK2q/4iaQMJs3ZF7gc4HrBL+ht92ysxJJF4pT4nwU9BrlD98ik9ZXyPXxmi1qPEin35
Dup+QJBAMQsiQwjjTGoVJpNrXoxHbSwgrHhJrgP4HUX2XKmbjCfem8dWdU93G4/VDFUDcNJyd33x
DOHispMoe+rHwgG0xQ=""".replaceAll("\n", ""),
  ),
);

final keyPairPkcs1 = RsaKeyPair(
  base64Decode(
    "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCCjpncvOtMHIp4Bv9sX3JMoSlYKCWsaHdDZ5Oi+QybEDQQlk+MS0wDv+CodsbBFkFwkYcScJzXO/2tM7zVLJR71H761u/woIC5WiBivEMfF6paD0oUM/M440N6ek9ZVONd+W29tnsA+pRVPhN8JhIJaWpuB//UoROXp0PWMjfiZwIDAQAB",
  ),
  base64Decode(
    "MIICXAIBAAKBgQCCjpncvOtMHIp4Bv9sX3JMoSlYKCWsaHdDZ5Oi+QybEDQQlk+MS0wDv+CodsbBFkFwkYcScJzXO/2tM7zVLJR71H761u/woIC5WiBivEMfF6paD0oUM/M440N6ek9ZVONd+W29tnsA+pRVPhN8JhIJaWpuB//UoROXp0PWMjfiZwIDAQABAoGAd/oYBzRNfzpTPY4guDTWUvlfhzYNuOyffP/4OrJoFS/EyOF45NJlXqS8DdRpPhP3uzzhRd7bIyhsLPj4tWYsZGuyA+GyOjF9Zj/rOWPU1rP4qWSFQ1p9pHvugoi3yt9I1bIqggvUcXk3hdnuVdfSjQE1fY5lpXZvGKB6zNpqZVECQQDuWimYnFgc/1BJtSfCwtKiN0eFMw8S4gTyzWttwOtFxBsHo7Q1l5Xvk564kwZXr2CuOXahrJaDjYm7vNzfoy6bAkEAjDk9QynP8YXQsISPB/X/PxYYpZbAti85sk3JPVO2jb3tAkxCYmIxUg1xgpogaOupqKxeQe83gD8742+5xSXSJQJASuFegghUEkAPjChyZlhobffp6ynASZFiNplcb62U/GUAjOTcH54Qx6Rbz+a4rmF1gSaiY2ZiHtAffjB2P3f3kwJASBx7k9mh1ZwyeUSCZd6tOB096ZJAYrCgpEB6eC5f2D7O7vqWvQ+wO3ksYbSvbCWdZ1/VTWUfDrX2L31adLeBfQJBALGYWVO6Ksv72k1vbSywhLYOKVe3JLZiZgFUNvKLh0g1Tfm1pK29veSSGey8HIkGtI04E6tgQVLx3adZSxjdnFI=",
  ),
);

const content = "hello";

final contentRaw = base64Decode("kolOt/LYqkhf/RZu6aJcIA==");
final encryptedRaw = base64Decode(
  "a6CIZzAPpzaDysCOE9X5FYp723lsTRia/GVDmU4yyhcKaFX2iBICfVwK5gakKK+NgTQ4veMu0l3wpIHM+eRA+Q6zrxCYjE8tkH1O4Jbxcvx4Nai4QP0JqCXDXNpxJMccKhqyNZ01uBq1RjJ++ATkMt66rt5DMW4pLtToh7nLjhg=",
);
final signRaw = base64Decode(
  "VnEka0wYeYmaG45qW7+RTPH+prTO9ryxrtqyAwpoZOymeQGJTPfkmm+Ti16UJPZetYR1LF+ETQ++XAkuTQIqhu4sgXyuhw4/TIYyMDzaEuEDOciwvJLiyC73E0Q4jXQx6kT8o+65Ki9h4LPxjjr8tOc+/r3U1uhute8/QWWYiuA=",
);

final signRawSha1 = base64Decode(
  "RvxmCkUxhtSPLss712C2vH7jpXaV82QXDe/e9EaclgWuVPEliDPmUkwg20PfG5d/xM0l3LAEexHAUWD3svg6HTWo9zw7/l+fYxtkbv59i8Uz7r5Y+j3HVaHKevFEw2Z34PHbiPXVNYBRE/4Qzl8wLT2ZSLzo50yBBFziD4LgvtU=",
);
