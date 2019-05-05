import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as Math;

import 'package:crypto/crypto.dart';

import './des/tripledes.dart' as DESUtils;
import './dycrypto_aes.dart';
import './rsa/rsa.dart' show KeyPair;
import './rsa/rsa_block.dart' show RSABlock;
import './rsa/rsa_key_formatter.dart' show RSAKeyFormatter;

/// [DYCryptoProvider] provides Base64, 16/32 MD5, AES, RSA, etc.
class DYCryptoProvider {
  /// Converts a string to base64.
  static dyBase64Encode(String string) {
    if (string == null) throw new ArgumentError("The argument is null");

    // get a base64 encoder instance.
    var encoder = new Base64Encoder();

    // utf8 encoding.
    var list = utf8.encode(string);
    // encode a string to Base64.
    var encodedString = encoder.convert(list);

    return encodedString;
  }

  /// Converts a base64 encoded string to a string or a `Uint8List`.
  static dyBase64Decode(String encodedString, {bool createUint8List = false}) {
    if (encodedString == null) throw new ArgumentError("encodedString is null");

    // get a base64 decoder instance.
    var decoder = Base64Decoder();

    // decode a base64 encoded string to a List of bytes.
    var bytes = decoder.convert(encodedString);

    if (createUint8List) {
      return createUint8ListFromList(bytes);
    }

    var output = utf8.decode(bytes);

    return output;
  }

  /// Converts a List of bytes to a base64 encoded string.
  static base64EncodeList(List<int> bytes) {
    if (bytes == null) throw new ArgumentError("The list is null");

    // get a base64 encoder instance
    var encoder = new Base64Encoder();

    // encode a List of bytes - use line breaks
    var out = encoder.convert(bytes);

    return out;
  }

  /// Converts a base64 encoded List of bytes to a string or a `Uint8List`.
  static base64DecodeList(List<int> bytes, {bool createUint8List = false}) {
    if (bytes == null) throw new ArgumentError("The list is null");

    // get a base64 decoder instance
    var decoder = Base64Decoder();

    var input = new String.fromCharCodes(bytes);
    // decode a Base64 encoded list
    var result = decoder.convert(input);

    if (createUint8List) {
      return createUint8ListFromList(result);
    }

    var output = utf8.decode(result);

    return output;
  }

  /// Creates a hash value with md5.
  static md5Encode(String input) {
    if (input == null) throw new ArgumentError("The input is null");

    var bytes = utf8.encode(input); // data being hashed
    var digest = md5.convert(bytes);

    return digest.toString();
  }

  /// Creates a 16 bytes hash value with md5.
  static md5Bytes16Enconde(String input) {
    var hash = md5Encode(input);
    return hash.substring(8, 24);
  }

  /// Returns a cipher text with `DES` algorithm.
  @Deprecated("No support for Chinese")
  static desEncrypt(String message, String key) {
    if (message == null || key == null)
      throw new ArgumentError("message or key is null");

    var blockCipher = DESUtils.BlockCipher(DESUtils.DESEngine(), key);
    var ciphertext = blockCipher.encodeB64(message);

    return ciphertext;
  }

  /// Returns a decoded text with `DES` algorithm.
  @Deprecated("No support for Chinese")
  static desDecrypt(String ciphertext, String key) {
    if (ciphertext == null || key == null)
      throw new ArgumentError("ciphertext or key is null");

    var blockCipher = DESUtils.BlockCipher(DESUtils.DESEngine(), key);
    var decodedText = blockCipher.decodeB64(ciphertext);

    return decodedText;
  }

  /// Private. The length for AES key is 128 bits, 192 bits, 256 bits.
  static Uint8List _getAESKey(String key, int blockSize) {
    var keyData = createUint8ListFromList(utf8.encode(key));

    var length = blockSize ~/ 8;
    var output = createUint8ListFromList(List.generate(length, (i) => 0));

    int count = Math.min(keyData.lengthInBytes, output.lengthInBytes);
    for (var i = 0; i < count; i++) {
      output[i] = keyData[i];
    }

    return output;
  }

  /// Returns a cipher text with `AES` algorithm.
  /// The length for AES key is 128 bits, 192 bits, 256 bits.
  static aesEncrypt(String message, String key, {int blockSize: 128}) {
    if (message == null || key == null)
      throw new ArgumentError("message or key is null");

    var keyData = _getAESKey(key, blockSize);
    var aes = AES.fromBytes(keyData);
    var ciphertext = aes.encode(message);

    return ciphertext;
  }

  /// Returns a decoded text with `AES` algorithm.
  /// The length for AES key is 128 or 192 or 256 bits.
  static aesDecrypt(String ciphertext, String key, {int blockSize: 128}) {
    if (ciphertext == null || key == null)
      throw new ArgumentError("ciphertext or key is null");

    var keyData = _getAESKey(key, blockSize);
    var aes = AES.fromBytes(keyData);
    var decryptedText = aes.decode(ciphertext);

    return decryptedText;
  }

  /// Returns a cipher text with `RSA` algorithm.
  static rsaEncrypt(String message, String publicKey) {
    if (message == null || publicKey == null)
      throw new ArgumentError("message or publicKey is null");

    String pubKey = RSAKeyFormatter.formatRSAPublicKey(publicKey);
    KeyPair pair = KeyPair.parsePem(pubKey);
    int blockSize = pair.bytesize - 11;

    var builder = BytesBuilder();

    var data = utf8.encode(message);
    var rb = RSABlock(data, blockSize);
    int count = rb.blockCount;

    for (var i = 0; i < count; i++) {
      int dataLength = data.length;

      int start = i * blockSize;
      int bufferSize = Math.min(blockSize, dataLength - start);
      int end = start + bufferSize;
      var subdata = data.sublist(start, end);

      var bytes = pair.encrypt(subdata);
      builder.add(bytes);
    }

    var ciphertext = base64Encode(builder.toBytes());

    return ciphertext;
  }

  /// Returns a decoded text with `RSA` algorithm.
  static rsaDecrypt(String ciphertext, String privateKey) {
    if (ciphertext == null || privateKey == null)
      throw new ArgumentError("ciphertext or privateKey is null");

    String privKey = RSAKeyFormatter.formatRSAPrivateKey(privateKey);
    KeyPair pair = KeyPair.parsePem(privKey);
    int blockSize = pair.bytesize;

    var builder = BytesBuilder();

    var data = base64Decode(ciphertext);
    var rb = RSABlock(data, blockSize);
    int count = rb.blockCount;

    for (var i = 0; i < count; i++) {
      int dataLength = data.length;

      int start = i * blockSize;
      int bufferSize = Math.min(blockSize, dataLength - start);
      int end = start + bufferSize;
      var subdata = data.sublist(start, end);

      var bytes = pair.decrypt(subdata);
      builder.add(bytes);
    }

    var decryptedText = utf8.decode(builder.toBytes());

    return decryptedText;
  }

  /// Returns a signature with `RSA` algorithm.
  static rsaSign(String message, String privateKey) {
    if (message == null || privateKey == null)
      throw new ArgumentError("message or privateKey is null");

    String privKey = RSAKeyFormatter.formatRSAPrivateKey(privateKey);
    KeyPair pair = KeyPair.parsePem(privKey);

    var msgBytes = createUint8ListFromList(utf8.encode(message));
    var signBytes = pair.sign(msgBytes);

    var sign = base64Encode(signBytes);

    return sign;
  }

  /// Verifies a signature with `RSA` algorithm.
  /// If true, the signature is correct, otherwise, signing failed.
  static rsaVerify(String signature, String message, String publicKey) {
    if (signature == null || message == null || publicKey == null)
      throw new ArgumentError("signature, message or publicKey is null");

    String pubKey = RSAKeyFormatter.formatRSAPublicKey(publicKey);
    KeyPair pair = KeyPair.parsePem(pubKey);

    var signBytes = base64Decode(signature);
    var msgBytes = createUint8ListFromList(utf8.encode(message));
    bool ret = pair.verify(signBytes, msgBytes);

    return ret;
  }

  /// Creates a `Uint8List` by a list of bytes.
  static Uint8List createUint8ListFromList(List<int> elements) {
    return new Uint8List.fromList(elements);
  }

  /// Creates a `Uint8List` by a hex string.
  static Uint8List createUint8ListFromHexString(String hex) {
    if (hex == null) throw new ArgumentError("hex is null");

    var result = new Uint8List(hex.length ~/ 2);
    for (var i = 0; i < hex.length; i += 2) {
      var num = hex.substring(i, i + 2);
      var byte = int.parse(num, radix: 16);
      result[i ~/ 2] = byte;
    }

    return result;
  }

  /// Returns a hex string by a `Uint8List`.
  static String formatBytesAsHexString(Uint8List bytes) {
    if (bytes == null) throw new ArgumentError("The list is null");

    var result = new StringBuffer();
    for (var i = 0; i < bytes.lengthInBytes; i++) {
      var part = bytes[i];
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }

    return result.toString();
  }
}
