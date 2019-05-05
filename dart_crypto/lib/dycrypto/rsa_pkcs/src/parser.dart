import 'dart:convert';
import 'package:asn1lib/asn1lib.dart';

class RSAPKCSParser {
  static const String PKCS_HEADER = "-----";
  static const String PKCS1_PUBLIC_HEADER = "-----BEGIN RSA PUBLIC KEY-----";
  static const String PKCS8_PUBLIC_HEADER = "-----BEGIN PUBLIC KEY-----";
  static const String PKCS1_PUBLIC_FOOTER = "-----END RSA PUBLIC KEY-----";
  static const String PKCS8_PUBLIC_FOOTER = "-----END PUBLIC KEY-----";

  static const String PKCS1_PRIVATE_HEADER = "-----BEGIN RSA PRIVATE KEY-----";
  static const String PKCS8_PRIVATE_HEADER = "-----BEGIN PRIVATE KEY-----";
  static const String PKCS1_PRIVATE_FOOTER = "-----END RSA PRIVATE KEY-----";
  static const String PKCS8_PRIVATE_FOOTER = "-----END PRIVATE KEY-----";

  static const String PKCS8_PRIVATE_ENC_HEADER =
      "-----BEGIN ENCRYPTED PRIVATE KEY-----";
  static const String PKCS8_PRIVATE_ENC_FOOTER =
      "-----END ENCRYPTED PRIVATE KEY-----";

  RSAKeyPair parsePEM(String pem, {String password}) {
    List lines = pem
        .split("\n")
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .skipWhile((String line) => !line.startsWith(PKCS_HEADER))
        .toList();
    if (lines.isEmpty) this._error("format error");
    return new RSAKeyPair(_publicKey(lines), _privateKey(lines));
  }

  RSAPrivateKey _privateKey(List<String> lines, {String password}) {
    var header = lines.indexOf(PKCS1_PRIVATE_HEADER);

    var footer;
    if (header >= 0) {
      footer = lines.indexOf(PKCS1_PRIVATE_FOOTER);
    } else if ((header = lines.indexOf(PKCS8_PRIVATE_HEADER)) >= 0) {
      footer = lines.indexOf(PKCS8_PRIVATE_FOOTER);
    } else if ((header = lines.indexOf(PKCS8_PRIVATE_ENC_HEADER)) >= 0) {
      footer = lines.indexOf(PKCS8_PRIVATE_ENC_FOOTER);
    } else
      return null;
    if (footer < 0) this._error("format error : cannot find footer");

    var key = lines.sublist(header + 1, footer).join("");
    var keyBytes = base64.decode(key);
    var p = new ASN1Parser(keyBytes);

    ASN1Sequence seq = p.nextObject();

    if (lines[header] == PKCS1_PRIVATE_HEADER)
      return _pkcs1PrivateKey(seq);
    else if (lines[header] == PKCS8_PRIVATE_HEADER)
      return _pkcs8PrivateKey(seq);
    else
      return _pkcs8PrivateEncKey(seq, password);
  }

  RSAPrivateKey _pkcs8PrivateEncKey(ASN1Sequence seq, String password) {
    throw new UnimplementedError();
    // ASN1OctetString asnkey = (seq.elements[0] as ASN1Sequence).elements[2];
    // var bytes = asnkey.valueBytes();
    // final key = new Uint8List.fromList([
    //   0x00,
    //   0x11,
    //   0x22,
    //   0x33,
    //   0x44,
    //   0x55,
    //   0x66,
    //   0x77,
    //   0x88,
    //   0x99,
    //   0xAA,
    //   0xBB,
    //   0xCC,
    //   0xDD,
    //   0xEE,
    //   0xFF
    // ]);
    // final params = new KeyParameter(key);
    // BlockCipher bc = new BlockCipher("AES");

    // return null;
  }

  RSAPrivateKey _pkcs1PrivateKey(ASN1Sequence seq) {
    RSAPrivateKey key = new RSAPrivateKey();
    key.version = (seq.elements[0] as ASN1Integer).intValue;
    key.modulus = (seq.elements[1] as ASN1Integer).valueAsBigInteger;
    key.publicExponent = (seq.elements[2] as ASN1Integer).valueAsBigInteger;
    key.privateExponent = (seq.elements[3] as ASN1Integer).valueAsBigInteger;
    key.prime1 = (seq.elements[4] as ASN1Integer).valueAsBigInteger;
    key.prime2 = (seq.elements[5] as ASN1Integer).valueAsBigInteger;
    key.exponent1 = (seq.elements[6] as ASN1Integer).valueAsBigInteger;
    key.exponent2 = (seq.elements[7] as ASN1Integer).valueAsBigInteger;
    key.coefficient = (seq.elements[8] as ASN1Integer).valueAsBigInteger;
    return key;
  }

  RSAPrivateKey _pkcs8PrivateKey(ASN1Sequence seq) {
    ASN1OctetString os = seq.elements[2];
    ASN1Parser p = new ASN1Parser(os.valueBytes());
    return _pkcs1PrivateKey(p.nextObject());
  }

  RSAPublicKey _publicKey(List<String> lines) {
    var header = lines.indexOf(PKCS1_PUBLIC_HEADER);
    var footer;
    if (header >= 0) {
      footer = lines.indexOf(PKCS1_PUBLIC_FOOTER);
    } else if ((header = lines.indexOf(PKCS8_PUBLIC_HEADER)) >= 0) {
      footer = lines.indexOf(PKCS8_PUBLIC_FOOTER);
    } else
      return null;
    if (footer < 0) this._error("format error : cannot find footer");

    var key = lines.sublist(header + 1, footer).join("");
    var keyBytes = base64.decode(key);
    var p = new ASN1Parser(keyBytes);

    ASN1Sequence seq = p.nextObject();

    if (lines[header] == PKCS1_PUBLIC_HEADER)
      return _pkcs1PublicKey(seq);
    else
      return _pkcs8PublicKey(seq);
  }

  RSAPublicKey _pkcs1PublicKey(ASN1Sequence seq) {
    RSAPublicKey key = new RSAPublicKey();
    key.modulus = (seq.elements[0] as ASN1Integer).valueAsBigInteger;
    key.publicExponent = (seq.elements[1] as ASN1Integer).valueAsBigInteger;
    return key;
  }

  RSAPublicKey _pkcs8PublicKey(ASN1Sequence seq) {
    ASN1BitString os = seq.elements[1]; //ASN1OctetString or ASN1BitString
    var bytes = os.valueBytes().sublist(1);
    ASN1Parser p = new ASN1Parser(bytes);
    return _pkcs1PublicKey(p.nextObject());
  }

  void _error(String msg) {
    throw "${this.runtimeType} : $msg";
  }
}

class RSAKeyPair {
  RSAPublicKey public;
  RSAPrivateKey private;

  RSAKeyPair(this.public, this.private);
}

class RSAPublicKey {
  BigInt modulus;
  BigInt publicExponent;
}

class RSAPrivateKey {
  int version;
  BigInt modulus;
  BigInt publicExponent;
  BigInt privateExponent;
  BigInt prime1;
  BigInt prime2;
  BigInt exponent1;
  BigInt exponent2;
  BigInt coefficient;
}
