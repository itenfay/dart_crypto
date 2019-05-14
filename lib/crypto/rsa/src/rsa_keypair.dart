import 'dart:typed_data' show Uint8List;
import 'dart:convert' show utf8, latin1;

import 'rsa_key.dart';
import 'rsa_pkcs1.dart' as PKCS1;
import 'rsa_padding.dart';
import 'rsa_tools.dart';
import 'rsa_hashing.dart';

import '../../rsa_pkcs/rsa_pkcs.dart' show RSAPKCSParser;

class KeyPair {
  final Key privateKey;
  final Key publicKey;

  Key get private => privateKey;
  Key get public => publicKey;

  KeyPair(this.privateKey, this.publicKey);

  static KeyPair parsePem(String pem, [String password]) {
    var parser = new RSAPKCSParser();
    var pair = parser.parsePEM(pem, password: password);
    var private;
    var public;
    if (null != pair.private) private = new Key.fromRSAPrivateKey(pair.private);
    if (null != pair.public) public = new Key.fromRSAPublicKey(pair.public);
    return new KeyPair(private, public);
  }

  bool get hasPrivateKey => null != privateKey;
  bool get hasPublicKey => null != publicKey;

  BigInt get modulus =>
      null != privateKey ? privateKey.modulus : publicKey.modulus;
  BigInt get n => modulus;

  bool get valid => privateKey.valid && publicKey.valid;

  int get bytesize => modulus.bitLength ~/ 8;

  int get bitsize => modulus.bitLength;
  int get size => bitsize;

  encrypt(plainText, {Padding padding: PKCS1_PADDING}) {
    if (plainText is String) {
      plainText = new Uint8List.fromList(latin1.encode(plainText));
      return DSC.encode(_encrypt(plainText, padding));
    }
    if (plainText is Uint8List) return _encrypt(plainText, padding);
    throw new ArgumentError.value(plainText);
  }

  PublicEncryptionResult publicEncrypt(plainText,
      {Padding padding: PKCS1_PADDING, HashFunction hashFunction: SHA256}) {
    var encrypted = encrypt(plainText);
    var signature = sign(encrypted);
    return new PublicEncryptionResult(encrypted, signature);
  }

  privateDecrypt(PublicEncryptionResult result,
      {Padding padding: PKCS1_PADDING, HashFunction hashFunction: SHA256}) {
    if (verify(result.signature, result.cipher, hashFunction: hashFunction)) {
      return decrypt(result.cipher, padding: padding);
    }
    throw new ArgumentError("Signature could not be verified");
  }

  Uint8List _encrypt(Uint8List plainText, padding) {
    if (null != padding) plainText = padding.apply(plainText, bytesize);
    return PKCS1.i2osp(_encryptInteger(PKCS1.os2ip(plainText)), bytesize);
  }

  decrypt(cipherText, {Padding padding: PKCS1_PADDING}) {
    if (cipherText is String) {
      cipherText = DSC.decode(cipherText);
      return new String.fromCharCodes(_decrypt(cipherText, padding));
    }
    if (cipherText is Uint8List) return _decrypt(cipherText, padding);
    throw new ArgumentError.value(cipherText);
  }

  Uint8List _decrypt(Uint8List cipherText, padding) {
    cipherText =
        PKCS1.i2osp(_decryptInteger(PKCS1.os2ip(cipherText)), bytesize);
    if (null != padding) cipherText = padding.strip(cipherText);
    return cipherText;
  }

  sign(message, {HashFunction hashFunction: SHA256}) {
    if (message is String) {
      message = DSC.decode(message);
      var signature = _sign(message, hashFunction: hashFunction);
      return DSC.encode(signature);
    }
    if (message is Uint8List) return _sign(message, hashFunction: hashFunction);
    throw new ArgumentError.value(message);
  }

  Uint8List _sign(Uint8List message, {HashFunction hashFunction: SHA256}) {
    var em = emsaEncode(message, bytesize, hashFunction: hashFunction);
    var m = PKCS1.os2ip(em);
    var s = PKCS1.rsasp1(privateKey, m);
    var signature = PKCS1.i2osp(s, bytesize);
    return signature;
  }

  bool verify(signature, message, {HashFunction hashFunction: SHA256}) {
    if (signature is String) signature = DSC.decode(signature);
    if (message is String) message = DSC.decode(message);
    if (signature is! Uint8List) throw new ArgumentError.value(signature);
    if (message is! Uint8List) throw new ArgumentError.value(message);
    return _verify(signature, message, hashFunction: hashFunction);
  }

  bool _verify(Uint8List signature, Uint8List message,
      {HashFunction hashFunction: SHA256}) {
    if (signature.length != bytesize) throw new ArgumentError.value(signature);
    var s = PKCS1.os2ip(signature);
    var m = PKCS1.rsavp1(publicKey, s);
    var em1 = PKCS1.i2osp(m, bytesize);
    var em2 = emsaEncode(message, bytesize);
    return equalLists(em1, em2);
  }

  bool equalLists(List first, List second) {
    if (first.length != second.length) return false;
    for (int i = 0; i < first.length; i++) {
      if (first[i] != second[i]) {
        return false;
      }
    }
    return true;
  }

  BigInt _encryptInteger(BigInt plainText) => PKCS1.rsaep(publicKey, plainText);

  BigInt _decryptInteger(BigInt cipherText) => PKCS1.rsadp(privateKey, cipherText);

  BigInt _signInteger(BigInt plainText) => PKCS1.rsasp1(privateKey, plainText);
}
