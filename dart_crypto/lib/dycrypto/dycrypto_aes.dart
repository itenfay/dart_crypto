import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart' as pointy;
import 'package:pointycastle/export.dart' as pointy;

import './aes_pkcs/padded_block_cipher.dart' as padded;
import './aes_pkcs/pkcs7.dart' as pkcs;

class AESEncoder {
  final Uint8List key;

  final _cipher = pointy.AESFastEngine();

  AESEncoder(String key) : key = Uint8List.fromList(utf8.encode(key));

  AESEncoder.fromBytes(this.key);

  String encode(String input) {
    var params = pointy.KeyParameter(this.key);

    var padding = pkcs.PKCS7Padding();

    var pbc = padded.PaddedBlockCipherImpl(padding, _cipher)
      ..reset()
      ..init(true, params);

    var data = Uint8List.fromList(utf8.encode(input));
    var output = pbc.process(data);

    return base64.encode(output);
  }
}

class AESDecoder {
  final Uint8List key;

  final _cipher = pointy.AESFastEngine();

  AESDecoder(String key) : key = Uint8List.fromList(utf8.encode(key));

  AESDecoder.fromBytes(this.key);

  String decode(String input) {
    var params = pointy.KeyParameter(this.key);

    var padding = pkcs.PKCS7Padding();

    var pbc = padded.PaddedBlockCipherImpl(padding, _cipher)
      ..reset()
      ..init(false, params);

    var data = base64.decode(input);
    var output = pbc.process(data);

    return utf8.decode(output);
  }
}

class AES {
  final AESEncoder _encoder;

  final AESDecoder _decoder;

  factory AES(String key) =>
      AES.fromBytes(Uint8List.fromList(utf8.encode(key)));

  factory AES.fromBytes(Uint8List key) {
    return AES.from(AESEncoder.fromBytes(key), AESDecoder.fromBytes(key));
  }

  AES.from(AESEncoder encoder, AESDecoder decoder)
      : _encoder = encoder,
        _decoder = decoder;

  String encode(String input) => _encoder.encode(input);
  String decode(String input) => _decoder.decode(input);
}
