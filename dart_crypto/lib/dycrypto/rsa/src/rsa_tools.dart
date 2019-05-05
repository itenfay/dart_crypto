import 'dart:convert';
import 'dart:typed_data' show Uint8List;

const DigestStringCodec DSC = const DigestStringCodec();

class DigestToStringConverter extends Converter<Uint8List, String> {
  const DigestToStringConverter() : super();

  String convert(Uint8List digest) {
    var base64 = base64Encode(digest);
    var utf = utf8.encode(base64);
    return new String.fromCharCodes(utf);
  }
}

class StringToDigestConverter extends Converter<String, Uint8List> {
  const StringToDigestConverter() : super();

  Uint8List convert(String digest) {
    var base64 = utf8.decode(digest.codeUnits);
    var bytes = base64Decode(base64);
    return bytes;
  }
}

class DigestStringCodec extends Codec<Uint8List, String> {
  final encoder = const DigestToStringConverter();
  final decoder = const StringToDigestConverter();

  const DigestStringCodec() : super();
}

class PublicEncryptionResult {
  final signature;
  final cipher;

  PublicEncryptionResult(this.cipher, this.signature);
}
