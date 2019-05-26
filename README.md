[搜到此项目的同学，希望给此项目一个star，激历我更好的创作。](https://github.com/dgynfi/dart_crypto)

# 技术交流群

欢迎加入技术交流群(群号:155353383) ，一起探讨技术问题。<br>
![群号:155353383](https://github.com/dgynfi/dart_crypto/raw/master/images/qq155353383.jpg)

# dart_crypto

A Flutter project based on flutter_macos_v0.5.8-dev. It provides Base64, MD5, AES, RSA with dart.

## Experience

在v0.5.8或以前版本中，flutter开源库不是很稳定，AES、 RSA等算法或多或少存在一些问题。通过查阅资料和调试，历经7个工作日的时间和算法打交道，非常地辛苦完成了Base64、MD5、AES、 RSA等算法！<br>

## Getting Started

For help getting started with Flutter, view our online <br>
1. [documentation](https://flutter.io/) <br>
2. [Flutter中文网](https://flutterchina.club) <br>
3. [Flutter SDK Archive](https://flutter.io/sdk-archive/#macos) <br>
4. [Dart Packages](https://pub.flutter-io.cn) <br>
5. [Dart2 中文文档](https://www.kancloud.cn/marswill/dark2_document/709087) <br>

## Usage

1. 原文
```dart
final plainText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit ........。本文基本上是将dart官网部分内容进行翻译，没兴趣的请出门左转至Dart的官网，有兴趣的同志请继续阅读本文。Flutter教程在这里通常，映射是一个有键和值的对象。 键和值都可以是任何类型的对象。 每个键只出现一次，但您可以多次使用相同的值。Dart的Map支持由映射文字和Map。int和double都是num的子类型。 num类型包括基本运算符，如+， - ，/和*，也是你可以找到abs()，ceil()和floor()以及其他方法的地方。 （按位运算符，如>>，在int类中有定义。）如果num及其子类没有您要想要内容，那dart：math库可能有您想要的。Dart字符串是一系列UTF-16代码单元。 您可以使用单引号或双引号来创建字符串：您可以使用{expression}将表达式的值放在字符串中。如果表达式是标识符，则可以跳过{}。 要获取对应于对象的字符串，Dart调用对象的toString()方法。为了表示布尔值，Dart有一个名为bool的类型。 只有两个对象具有bool类型：true和false，它们都是编译时常量。Dart的类型安全意味着您不能使用if（nonbooleanValue）或assert（nonbooleanValue）等代码。 相反，明确检查值，如下所示：也许几乎每种编程语言中最常见的集合是数组或有序的对象组。 在Dart中，数组是List对象，因此大多数人只是将它们称为列表。Dart列表文字看起来像JavaScript数组文字。 这是一个简单的Dart List：";
```

2. Base64
```dart
try {
    final base64Encoded = dtcrypt.DYFCryptoProvider.aBase64Encode(plainText);
    debugPrint("[base64] encode: " + base64Encoded);
    final base64Decoded = dtcrypt.DYFCryptoProvider.aBase64Decode(base64Encoded);
    debugPrint("[base64] decode: " + base64Decoded);
} catch (e) {
    debugPrint("e: $e");
}
```

3. MD5
```dart
try {
    final md5Hash = dtcrypt.DYFCryptoProvider.md5Encode(plainText);
    debugPrint("[md5] Hash: " + md5Hash);
    final md5b16hash = dtcrypt.DYFCryptoProvider.bit16md5Enconde(plainText);
    debugPrint("[md5] 16 bit hash: " + md5b16hash);
} catch (e) {
    debugPrint("e: $e");
}
```

4. AES
```dart
try {
    final aesKey = "smMQI8dMK2nOMUR0TdpBYQUnLpbW8kjHrdy86WtU6eB1Ff6mYveYzezopmbjwBZEjPQmg";
    debugPrint("[aes] key: " + aesKey);
    String aesEncryptedText = dtcrypt.DYFCryptoProvider.aesEncrypt(plainText, aesKey);
    debugPrint("[aes] encryptedText: " + aesEncryptedText);
    String aesDecryptedText = dtcrypt.DYFCryptoProvider.aesDecrypt(aesEncryptedText, aesKey);
    debugPrint("[aes] decryptedText: " + aesDecryptedText);
} catch (e) {
    debugPrint("e: $e");
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
// 私钥
final privateKey =
"""MIICXAIBAAKBgQCmPW2SwJFldGVB1SM82VYvSZYRF1H5DREUiDK2SLnksxHAV/ro
C1uB44a4siUehJ9AKeV/g58pVrjhX3eSiBh9Khom/S2hEWF2n/6+lqqiwQi1W5rj
l86v+dI2F6NgbPFpfesrRjWD9uskT2VX/ZJuMRLz8VPIyQOM9TW3PkMYBQIDAQAB
AoGAK2VVuT1ztxxPYoQVEslZaja3afbAe1ch4k47jsIlZMIqHB/ba7+rP5j5jjVS
40iTmdhWBJeDcPMmiA631BSa74XW4RyZ8JDtu1qOYxH5tqhgsIEDbVAAqCB+t+y1
3z/Nb+SO3mbRGu5HzvAMaad3M7ztR3SAJTiPK1OI293wdXECQQDS4Hx3fwg66NYL
b061Hk8P5arClUnBoh5/qZk/kx3nen7SdjACVXC/9B/PnxTeZkcqQi+y0MjzuPHU
5n2PT26HAkEAyc/MWRqtgTQHd4EqzYt6vvkhMo0T8w36/ABiQSRfKrbJXEmK1Qf4
4z8f6jTZTMTqF56aMwaI81Uzt1IqzCf8EwJBAM2/d9GDoT0RBh58CJhQrSU+mWBn
FmKV0hoPGNXdrZS3gNvJssfkIzE2eH8zoMHpms/RagaXDSo3LcTi6mkUQCsCQFz2
cM524IfM3Meq43mtj4xbHHS50f+7Z+sfjiMtyvzVGGp/oglB099yW5Q6ZgLcDm10
7NkmYH2euOTwX7CNlqsCQBicZxvPsIgp8zdAiGbxverXzmZs9JZDODUhw8HQkm2o
CZWXHDraHaZ9NA88vpdLfqBXtF5t0QNFpD80F/7HjtE=""";
```
```dart
try {
    String rsaEncryptedText = dtcrypt.DYFCryptoProvider.rsaEncrypt(plainText, publicKey);
    debugPrint("[rsa] encryptedText: " + rsaEncryptedText);
    String rsaDecryptedText = dtcrypt.DYFCryptoProvider.rsaDecrypt(rsaEncryptedText, privateKey);
    debugPrint("[rsa] decryptedText: " + rsaDecryptedText);

    String signature = dtcrypt.DYFCryptoProvider.rsaSign(plainText, privateKey);
    debugPrint("[rsa] signature: " + signature);
    bool ret = dtcrypt.DYFCryptoProvider.rsaVerify(signature, plainText, publicKey);
    debugPrint("[rsa] signature verification: " + ret.toString());
} catch (e) {
    debugPrint("e: $e");
}
```
