# crpto_demo

 A Flutter project based on flutter_macos_v0.5.8-dev. It provides Base64, MD5, AES, RSA with dart.

## Getting Started

For help getting started with Flutter, view our online <br>
1. [documentation](https://flutter.io/). <br>
2. [Flutter中文网](https://flutterchina.club). <br>
3. [Flutter SDK Archive](https://flutter.io/sdk-archive/#macos). <br>
4. [Dart Packages](https://pub.flutter-io.cn). <br>
5. [Dart2 中文文档](https://www.kancloud.cn/marswill/dark2_document/709087). <br>

## Usage

1.原文
```dart
final plainText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit ........。本文基本上是将dart官网部分内容进行翻译，没兴趣的请出门左转至Dart的官网，有兴趣的同志请继续阅读本文。Flutter教程在这里通常，映射是一个有键和值的对象。 键和值都可以是任何类型的对象。 每个键只出现一次，但您可以多次使用相同的值。Dart的Map支持由映射文字和Map。int和double都是num的子类型。 num类型包括基本运算符，如+， - ，/和*，也是你可以找到abs()，ceil()和floor()以及其他方法的地方。 （按位运算符，如>>，在int类中有定义。）如果num及其子类没有您要想要内容，那dart：math库可能有您想要的。Dart字符串是一系列UTF-16代码单元。 您可以使用单引号或双引号来创建字符串：您可以使用{expression}将表达式的值放在字符串中。如果表达式是标识符，则可以跳过{}。 要获取对应于对象的字符串，Dart调用对象的toString()方法。为了表示布尔值，Dart有一个名为bool的类型。 只有两个对象具有bool类型：true和false，它们都是编译时常量。Dart的类型安全意味着您不能使用if（nonbooleanValue）或assert（nonbooleanValue）等代码。 相反，明确检查值，如下所示：也许几乎每种编程语言中最常见的集合是数组或有序的对象组。 在Dart中，数组是List对象，因此大多数人只是将它们称为列表。Dart列表文字看起来像JavaScript数组文字。 这是一个简单的Dart List：";
```

2.Base64
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

3.MD5
```dart
try {
    final md5Hash = dtcrypt.DYFCryptoProvider.md5Encode(plainText);
    debugPrint("[md5] Hash: " + md5Hash);
    final md5b16hash = dtcrypt.DYFCryptoProvider.md5Bytes16Enconde(plainText);
    debugPrint("[md5] 16bytes hash: " + md5b16hash);
} catch (e) {
    debugPrint("e: $e");
}
```

4.AES
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

5.RSA
```
// 公钥与私钥
final publicKey =
"""MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApSHIqtGQIMp5vUv5XpLz
sdVMxy9RW5VhH4dlVo7C3ZhIjS6UOxxXIVzC1AYjQIWHx9exxu4XsoeyvAisHuM+
GvEzpZ43NPrputlDNcoIY5Ff+U8UFThx/v4hlsOJY9/Mo65p1HbTPgN4uQSaVZMU
4UrVmR6Lj9yj6+0TpmN1fjS1d23RXGFfx+lIridUTyJMJu27NklUQd7MloaZr6dJ
czQWdbzEs1uOIJcxo/msY3K7pLJuZ83xXI8CPxkEe/nDQ9kJ6HKPvbXlk9hO1kR9
k3fo3DCmx9HdNSRPlKXNpzOPn579dQMGg1OgpH1uO5cljkPWdkvliVljY4SWV6fu
mQIDAQAB""";

final privateKey =
"""MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQClIciq0ZAgynm9
S/lekvOx1UzHL1FblWEfh2VWjsLdmEiNLpQ7HFchXMLUBiNAhYfH17HG7heyh7K8
CKwe4z4a8TOlnjc0+um62UM1yghjkV/5TxQVOHH+/iGWw4lj38yjrmnUdtM+A3i5
BJpVkxThStWZHouP3KPr7ROmY3V+NLV3bdFcYV/H6UiuJ1RPIkwm7bs2SVRB3syW
hpmvp0lzNBZ1vMSzW44glzGj+axjcruksm5nzfFcjwI/GQR7+cND2Qnoco+9teWT
2E7WRH2Td+jcMKbH0d01JE+Upc2nM4+fnv11AwaDU6CkfW47lyWOQ9Z2S+WJWWNj
hJZXp+6ZAgMBAAECggEAHBq93mTAVPRg99jAXlpAY5nb8WKaRC4OU6Flm++8Np6+
aljtHYpbQfBZsGBDC64uR9LsDOFk4xu5TctkD/W5EjjPA3cECl5R/V0Q1UzHVLrf
TL0qu9nZfP6flNs+vOLQH2OF24VFup44o7Sm172qphVoeSD7u8Zfl73HxF/VFV95
LPQ81ITms4z7ddcOgzzM88RiISVitTJQWncq7BfxfjH7WdoXiYGs4c9v2CFrZWjy
qoSmS9xP2mvaE9kaXhGPw3wiAMMBAkZ0QcUTR956xUvt8DuImAaJp696nglW/lEn
8b+SO3R0RHzBaAambSAPCQOBz7SSCFE6+x7FJHrgqQKBgQDQSH2XuJs9lt7fYsE0
FRzRgTFyerkZn/O6rPye1KLAeW7LzA+iOK0EDMkzrmzNffudBi53HnBf03Od1F89
/hZX22UZQ+Z52S1lhy8OnK2PS78pCJsZm2BFgpvXFXS8NOXOjdwxDq6Hqy1oDyeS
LatRUqdirOxoP4BU/VVoBK0RDwKBgQDK9omLppSHz13ipIfDucjiDay5tdYwMv5c
BwUDdNF0aHRUWiO3NqwBe33mSIN4spjbPwHnk3wN9hZJHJJug9t7czJPjJvV3/SL
D50/AoL+iO76ZQ/0jo7XCcSwMCXj33UKfj2LArSH0dZOgceM7E8otx+II78z6ldO
Gq4M4NG11wKBgHqXkESzBbyUho3ZJHqxSosNjbsh/LzWZrCjjPU3lqvPTaVqcHE9
BqjxlaNzsNqqomRj9QlrwxzD6rMlAwIMAb6ohbL/QjLJ32x4yvvAwG8tWFCgnhnO
WDXRkERifpkgUXroCIhfad60pD8xXEsv0jxFd/weZ+9cIP7lNVXKGsuFAoGBALnB
rB9ZJYWq34WICg2zosxpsZUCfHb+pNf7QLZqGy1MUHPHT/rmGcT9jjvOUC2OX+IB
p6+XxylL+heOA+ML4Tv6MaimyxWS9FC1yLgbh2KIVxhqmJC+TLM46IBMgNEu+gLR
iWgJ4MqR3W9azhUHTme4Oi6ycNOF/cOpHXUB6k1fAoGBAJ5ThMARzkV9Rl5lxfRs
BHHy+6JhHirubnV6NLWP/1pI9yS3H/kQKmgoueAIytB43kX/upQdASZZkRJwFZqr
qRszOiB3ds/jKTZuokCkT7cq5CrLUyoDpu6SsRgNI1yO9BTKI+UF6htNlehJjN+g
0/uj5f+4Zr5HZvGd7XQm00wm""";
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
    debugPrint("[rsa] signature verify: " + ret.toString());
} catch (e) {
    debugPrint("e: $e");
}
```
