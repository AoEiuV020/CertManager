import 'dart:convert';

import 'package:test/test.dart';

import 'package:secure_utils/src/rsa.dart';

void main() {
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
  const encrypted =
      "ejOeerZ5MXrlVi6MyiFiPFqVGPb0hV8gaUqylAu8V+X5/BJMXzYwRNxp0SL0VM9aWGyqtUZbimY/VUB7/fxHHj4nf9bmLKoQkGGgjJ8NfdotyENFgLo01Xe4j58BOIrfre7rnXRYZPGkVCPgXXYPZ49L0yk+O7co+kOFaJbvM+A=";
  const sign =
      "b1bE8VRWHu3Lwe+kGls6M8uHGQ4Ft/QeAHNpGaLP5tZvZy9CmVKvkNOtQauFq+ETLcynG/crmEhBe0nlx/0gZjyAXv5Ygzct62tPNLl36CIiM5h+YJI+8eym+mCGeSnJsWLxiI96gUQ/dNCyVPrpAY1Zs9Ivw1u8rHEJtDSA+pE=";

  group('RSA Tests', () {
    test('genKeyPair should generate valid key pair', () {
      final pair = RSA.genKeyPair();
      print(pair.getPublicKeyBase64());
      print(pair.getPrivateKeyBase64());

      expect(pair.publicKey, isNotNull);
      expect(pair.privateKey, isNotNull);
      expect(base64Decode(pair.getPublicKeyBase64()), equals(pair.publicKey));
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
  });
}
