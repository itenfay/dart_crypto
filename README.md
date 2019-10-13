[如果你觉得能帮助到你，请给一颗小星星。谢谢！(If you think it can help you, please give it a star. Thanks!)](https://github.com/dgynfi/dart_crypto)

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;
[![Support](https://img.shields.io/badge/support-Flutter%20|%20iOS%20|%20Android-blue.svg?style=flat)](https://flutterchina.club)&nbsp;

## 技术交流群(群号:155353383)

- 欢迎加入技术交流群 ，一起探讨技术问题。

<div align=left>
&emsp; <img src="https://github.com/dgynfi/dart_crypto/raw/master/images/qq155353383.jpg" width="20%" />
</div> 

## dart_crypto

&emsp; 此 Flutter 工程基于 flutter_macos_v0.5.8-dev 版本，用 dart 语言开发。一行代码就实现 Base64, 32/16 bit MD5, AES, RSA算法，操作简单好用。 (This Flutter project is based on flutter_macos_v0.5.8-dev and is developed in dart language。it achieves Base64, 32/16 bit MD5, AES and RSA algorithms in one line of code, the operation is simple and easy to use.)

## Experience

&emsp; 在 v0.5.8 或以前版本中，flutter 开源库不是很稳定，AES、 RSA 等算法或多或少存在一些问题。通过查阅资料和调试，历经7个工作日的时间和算法打交道，非常辛苦地完成了 Base64、MD5、AES、 RSA 等算法的编写！

## Getting Started

&emsp; For help getting started with Flutter, view our online <br />
1. [Documentation](https://flutter.io/) <br />
2. [Flutter中文网](https://flutterchina.club) <br />
3. [Flutter SDK Archive](https://flutter.io/sdk-archive/#macos) <br />
4. [Dart Packages](https://pub.flutter-io.cn) <br />
5. [Dart2 中文文档](https://www.kancloud.cn/marswill/dark2_document/709087) <br />

## Usage

1. 原文

```dart
final plainText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit ........。本文基本上是将dart官网部分内容进行翻译，没兴趣的请出门左转至Dart的官网，有兴趣的同志请继续阅读本文。Flutter教程在这里通常，映射是一个有键和值的对象。 键和值都可以是任何类型的对象。 每个键只出现一次，但您可以多次使用相同的值。Dart的Map支持由映射文字和Map。int和double都是num的子类型。 num类型包括基本运算符，如+， - ，/和*，也是你可以找到abs()，ceil()和floor()以及其他方法的地方。 （按位运算符，如>>，在int类中有定义。）如果num及其子类没有您要想要内容，那dart：math库可能有您想要的。Dart字符串是一系列UTF-16代码单元。 您可以使用单引号或双引号来创建字符串：您可以使用{expression}将表达式的值放在字符串中。如果表达式是标识符，则可以跳过{}。 要获取对应于对象的字符串，Dart调用对象的toString()方法。为了表示布尔值，Dart有一个名为bool的类型。 只有两个对象具有bool类型：true和false，它们都是编译时常量。Dart的类型安全意味着您不能使用if（nonbooleanValue）或assert（nonbooleanValue）等代码。 相反，明确检查值，如下所示：也许几乎每种编程语言中最常见的集合是数组或有序的对象组。 在Dart中，数组是List对象，因此大多数人只是将它们称为列表。Dart列表文字看起来像JavaScript数组文字。 这是一个简单的Dart List：";
```

2. Base64

```dart
try {
    // Base64 - Encode/Decode
    final base64Encoded = crypto.DYFCryptoProvider.yf_base64Encode(plainText);
    print("[base64] encode: " + base64Encoded);

    final base64Decoded = crypto.DYFCryptoProvider.yf_base64Decode(base64Encoded);
    print("[base64] decode: " + base64Decoded);
} catch (e) {
    print("e: $e");
}
```

3. MD5

```dart
try {
    // MD5 - 32/16 bit Encode
    final md5Hash = crypto.DYFCryptoProvider.md5Encode(plainText);
    print("[md5] Hash: " + md5Hash);

    final md5b16hash = crypto.DYFCryptoProvider.bit16md5Enconde(plainText);
    print("[md5] 16 bit hash: " + md5b16hash);
} catch (e) {
    print("e: $e");
}
```

4. AES

```dart
try {
    // AES - Encrypt/Decrypt
    // final aesKey = "smMQI8dMK2nOMUR0TdpBYQUnLpbW8kjHrdy86WtU6eB1Ff6mYveYzezopmbjwBZEjPQmg";
    final aesKey = "smMQI8dMK2";
    print("[aes] key: " + aesKey);

    String aesEncryptedText = crypto.DYFCryptoProvider.aesEncrypt(plainText, aesKey);
    print("[aes] encryptedText: " + aesEncryptedText);

    String aesDecryptedText = crypto.DYFCryptoProvider.aesDecrypt(aesEncryptedText, aesKey);
    print("[aes] decryptedText: " + aesDecryptedText);
} catch (e) {
    print("e: $e");
}
```

5. RSA

```
// 公钥
final publicKey =
"""MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCmPW2SwJFldGVB1SM82VYvSZYR
F1H5DREUiDK2SLnksxHAV/roC1uB44a4siUehJ9AKeV/g58pVrjhX3eSiBh9Khom
/S2hEWF2n/6+lqqiwQi1W5rjl86v+dI2F6NgbPFpfesrRjWD9uskT2VX/ZJuMRLz
8VPIyQOM9TW3PkMYBQIDAQAB""";

// 私钥(pkcs8)
final privateKey =
"""MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKY9bZLAkWV0ZUHV
IzzZVi9JlhEXUfkNERSIMrZIueSzEcBX+ugLW4HjhriyJR6En0Ap5X+DnylWuOFf
d5KIGH0qGib9LaERYXaf/r6WqqLBCLVbmuOXzq/50jYXo2Bs8Wl96ytGNYP26yRP
ZVf9km4xEvPxU8jJA4z1Nbc+QxgFAgMBAAECgYArZVW5PXO3HE9ihBUSyVlqNrdp
9sB7VyHiTjuOwiVkwiocH9trv6s/mPmONVLjSJOZ2FYEl4Nw8yaIDrfUFJrvhdbh
HJnwkO27Wo5jEfm2qGCwgQNtUACoIH637LXfP81v5I7eZtEa7kfO8Axpp3czvO1H
dIAlOI8rU4jb3fB1cQJBANLgfHd/CDro1gtvTrUeTw/lqsKVScGiHn+pmT+THed6
ftJ2MAJVcL/0H8+fFN5mRypCL7LQyPO48dTmfY9PbocCQQDJz8xZGq2BNAd3gSrN
i3q++SEyjRPzDfr8AGJBJF8qtslcSYrVB/jjPx/qNNlMxOoXnpozBojzVTO3UirM
J/wTAkEAzb930YOhPREGHnwImFCtJT6ZYGcWYpXSGg8Y1d2tlLeA28myx+QjMTZ4
fzOgwemaz9FqBpcNKjctxOLqaRRAKwJAXPZwznbgh8zcx6rjea2PjFscdLnR/7tn
6x+OIy3K/NUYan+iCUHT33JblDpmAtwObXTs2SZgfZ645PBfsI2WqwJAGJxnG8+w
iCnzN0CIZvG96tfOZmz0lkM4NSHDwdCSbagJlZccOtodpn00Dzy+l0t+oFe0Xm3R
A0WkPzQX/seO0Q==""";
```

```dart
try {
    // RSA - Encrypt/Decrypt
    String rsaEncryptedText = crypto.DYFCryptoProvider.rsaEncrypt(plainText, publicKey);
    print("[rsa] encryptedText: " + rsaEncryptedText);

    String rsaDecryptedText = crypto.DYFCryptoProvider.rsaDecrypt(rsaEncryptedText, privateKey);
    print("[rsa] decryptedText: " + rsaDecryptedText);

    // RSA - Sign/Verify
    String signature = crypto.DYFCryptoProvider.rsaSign(plainText, privateKey);
    print("[rsa] signature: " + signature);

    bool ret = crypto.DYFCryptoProvider.rsaVerify(signature, plainText, publicKey);
    print("[rsa] signature verification: " + ret.toString());
} catch (e) {
    print("e: $e");
}
```

## Sample Codes

- [Sample Codes Gateway](https://github.com/dgynfi/dart_crypto/blob/master/lib/string_utils.dart)


