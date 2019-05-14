import 'dart:math' show pow, max;
import 'dart:typed_data' show Uint8List;

import 'rsa_key.dart';

int _bigIntToInt(BigInt big) {
  return big.toInt();
}

Uint8List i2osp(BigInt x, int len) {
  if (null != len && x >= new BigInt.from(256).pow(len))
    throw new ArgumentError("integer too large");

  var b;
  var buffer = new List<int>();
  while (x > new BigInt.from(0)) {
    b = x & (new BigInt.from(0xFF));
    x = x >> 8;
    buffer.add(_bigIntToInt(b));
  }

  var difference = max(0, len - buffer.length);
  buffer.addAll(new List.filled(difference, 0));
  buffer = buffer.reversed.toList();
  return new Uint8List.fromList(buffer);
}

BigInt os2ip(Uint8List x) {
  return x.fold(new BigInt.from(0), (BigInt n, b) => (n << 8) + new BigInt.from(b));
}

BigInt rsaep(Key k, BigInt m) {
  if (m < new BigInt.from(0) || m >= k.n)
    throw new ArgumentError("message representative out of range");
  var c = m.modPow(k.e, k.n);
  return c;
}

BigInt rsadp(Key k, BigInt c) {
  if (c < new BigInt.from(0) || c >= k.n)
    throw new ArgumentError("ciphertext representative out of range");
  var s = c.modPow(k.d, k.n);
  return s;
}

BigInt rsasp1(Key k, BigInt m) {
  if (m < new BigInt.from(0) || m >= k.n)
    throw new ArgumentError("message representative out of range");
  var s = m.modPow(k.d, k.n);
  return s;
}

BigInt rsavp1(Key k, BigInt s) {
  if (s < new BigInt.from(0) || s >= k.n)
    throw new ArgumentError("signature representative out of range");
  var m = s.modPow(k.e, k.n);
  return m;
}
