import 'dart:math' show Point;

import '../../rsa_pkcs/rsa_pkcs.dart' show RSAPublicKey, RSAPrivateKey;

class Key {
  final BigInt modulus;
  final BigInt exponent;

  Key(this.modulus, this.exponent);

  Key.fromRSAPublicKey(RSAPublicKey pubKey)
      : modulus = pubKey.modulus,
        exponent = pubKey.publicExponent;

  Key.fromRSAPrivateKey(RSAPrivateKey privKey)
      : modulus = privKey.modulus,
        exponent = privKey.privateExponent;

  BigInt get n => modulus;
  BigInt get e => exponent;
  BigInt get d => exponent;

  bool get valid => true; // TODO: Validity checking

  int get modulusBytesize => modulus.bitLength ~/ 8;

  Point toPoint() => new Point(modulus.toInt(), exponent.toInt());
}
