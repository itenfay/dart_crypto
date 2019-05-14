//
// Created by dyf on 2018/8/31.
// Copyright (c) 2018 dyf.
//
// Deprecated("Use rsa keyPair")
//

import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart' as pointy;
import 'package:pointycastle/export.dart';

import './rsa/rsa_block.dart';

class RSAPublicKey {
  /// Modulus
  final BigInt n;

  /// Public exponent
  final BigInt e;

  RSAPublicKey(this.n, this.e);
}

class RSAPrivateKey implements RSAPublicKey {
  /// Modulus
  final BigInt n;

  /// Public exponent
  final BigInt e;

  /// Private exponent
  final BigInt d;

  /// Prime p
  final BigInt p;

  /// Prime q
  final BigInt q;

  RSAPrivateKey(this.n, this.e, this.d, this.p, this.q);
}

@Deprecated("Use rsa keyPair")
class RSAEncoder extends Converter<String, String> {
  final RSAPublicKey key;

  RSAEncoder(this.key);

  @override
  String convert(String input) {
    var engine = RSAEngine();
    engine.reset();
    engine.init(
        true,
        PublicKeyParameter<pointy.RSAPublicKey>(
            pointy.RSAPublicKey(key.n, key.e)));

    // input.codeUnits
    Uint8List data = Uint8List.fromList(utf8.encode(input));

    int blockSize = engine.inputBlockSize - 11;
    var rb = RSABlock(data, blockSize);
    var count = rb.blockCount;

    var builder = BytesBuilder();

    for (var i = 0; i < count; i++) {
      int dataLength = data.lengthInBytes;

      int start = i * blockSize;
      int bufferSize = Math.min(blockSize, dataLength - start);
      int end = start + bufferSize;
      var subdata = data.sublist(start, end);

      Uint8List output = engine.process(Uint8List.fromList(subdata));
      builder.add(output);
    }

    // hexStringDecoder.convert(output)
    return base64Encode(builder.toBytes());
  }
}

@Deprecated("Use rsa keyPair")
class RSADecoder extends Converter<String, String> {
  final RSAPrivateKey key;

  RSADecoder(this.key);

  @override
  String convert(String input) {
    var engine = RSAEngine();
    engine.reset();
    engine.init(
        false,
        PrivateKeyParameter<pointy.RSAPrivateKey>(
            pointy.RSAPrivateKey(key.n, key.d, key.p, key.q)));

    // hexStringEncoder.convert(input)
    Uint8List data = base64Decode(input);

    int blockSize = engine.inputBlockSize;
    var rb = new RSABlock(data, blockSize);
    var count = rb.blockCount;

    var builder = BytesBuilder();

    for (var i = 0; i < count; i++) {
      int dataLength = data.lengthInBytes;

      int start = i * blockSize;
      int bufferSize = Math.min(blockSize, dataLength - start);
      int end = start + bufferSize;
      var subdata = data.sublist(start, end);

      Uint8List output = engine.process(Uint8List.fromList(subdata));
      builder.add(output);
    }

    return utf8.decode(builder.toBytes());
  }
}

@Deprecated("Use rsa keyPair")
class RSA extends Codec<String, String> {
  @override
  final RSAEncoder encoder;

  @override
  final RSADecoder decoder;

  RSA(RSAPublicKey key)
      : encoder = RSAEncoder(key),
        decoder = key is RSAPrivateKey ? RSADecoder(key) : null;

  @override
  String decode(String encoded) {
    if (decoder == null) throw Exception('Do not have Private key!');
    return super.decode(encoded);
  }
}
