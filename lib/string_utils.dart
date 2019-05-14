//
// Created by dyf on 2018/8/31.
// Copyright (c) 2018 dyf.
//

import 'dart:convert';
import 'dart:math' show Random;
import './crypto/crypto_provider.dart' as crypt;

class KeyConstants {
  static final kComm = "!@##@...#FDSFD}";
  static final kPublic =
      "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCB2LJFffp...FTgBJFtOltfmJXVOzHPw8yEO07v+I8tPH56qiCP4KFQIDAQAB";
  static final kPrivate =
      "MIICdgIBADANBgkqhk/rVH+L+ZLtAkEAsfVueXe...V8PM7i5i8JYHGp+TeuYFTKH7MvW9azIm3wBXj+JbuOe5fuSEuofeRWk7LCAzO9K82NEifaGeVstmC7g==";
}

class RandomObjectGenerator {
  int genRandomNumber() {
    var max = 1 << 32;
    return Random().nextInt(max);
  }

  String genRandomString({int length: 20}) {
    var buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      int r = new Random().nextInt(2);

      var s = (r == 1 ? "A" : "a");
      int start = s.codeUnitAt(0);
      int c = start + Random().nextInt(26);

      buffer.writeCharCode(c);
    }

    return buffer.toString();
  }
}

abstract class BaseStringUtils {
  String urlEncode(String s);
  String urlDecode(String s);
  String apiEncode(String s);
  String apiDecode(String s);
}

class StringUtils extends RandomObjectGenerator implements BaseStringUtils {
  @override
  String genRandomString({int length: 20}) => super.genRandomString(length: length);

  String urlEncode(String s) {
    return Uri.encodeQueryComponent(s);
  }

  String urlDecode(String s) {
    return Uri.decodeQueryComponent(s);
  }

  String apiEncode(String s) {
    if (s == null) throw ArgumentError("The input is null");
    if (s.isEmpty) return s;

    try {
      String randomKey = genRandomString();
      print("randomKey: $randomKey");
      String middleKey = randomKey + KeyConstants.kComm;
      print("middleKey: $middleKey");

      String realKey = crypt.DYFCryptoProvider.bit16md5Enconde(middleKey);
      String mParam = crypt.DYFCryptoProvider.aesEncrypt(s, realKey);

      var middleMap = Map();
      middleMap["p"] = mParam;
      middleMap["k"] = randomKey;
      var jp = json.encode(middleMap);
      print("jp: $jp");

      String ciphertext = crypt.DYFCryptoProvider.rsaEncrypt(jp, KeyConstants.kPublic);
      print("ciphertext: $ciphertext");

      return ciphertext;
    } catch (e) {
      print("e: $e");
    }

    return null;
  }

  String apiDecode(String s) {
    if (s == null) throw ArgumentError("The input is null");
    if (s.isEmpty) return s;

    try {
      String data = crypt.DYFCryptoProvider.rsaDecrypt(s, KeyConstants.kPrivate);

      var map = json.decode(data);
      var mParam = map["p"];
      var randomKey = map["k"];
      print("randomKey: $randomKey");

      String middleKey = randomKey + KeyConstants.kComm;
      print("middleKey: $middleKey");

      String realKey = crypt.DYFCryptoProvider.bit16md5Enconde(middleKey);
      String decodedText = crypt.DYFCryptoProvider.aesDecrypt(mParam, realKey);

      return decodedText;
    } catch (e) {
      print("e: $e");
    }

    return null;
  }
}
