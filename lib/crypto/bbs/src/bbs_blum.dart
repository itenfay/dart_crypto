//
// Modified by dyf on 2018/8/31.
// Copyright (c) 2018 dyf.
//

import 'dart:math' show Random, log;
import 'bbs_primes.dart' as primes;

class BlumBlumShub implements Random {
  BigInt n;
  BigInt state;

  BlumBlumShub([int bits = 256, Random random]) {
    this.n = generateN(bits, random);
    var length = this.n.bitLength;
    this.seed = primes.getRandBits(length, random);
  }

  set seed(BigInt seed) => this.state = seed % this.n;

  static BigInt getPrime(int bits, [Random random]) {
    while (true) {
      var p = primes.bigPrime(bits, random);
      if (BigInt.from(3) == (p & BigInt.from(3))) return p;
    }
  }

  static BigInt generateN(int bits, [Random random]) {
    var p = getPrime(bits ~/ 2, random);
    while (true) {
      var q = getPrime(bits ~/ 2, random);

      if (p != q) return p * q;
    }
  }

  BigInt next(int numBits) {
    var result = BigInt.zero;

    for (int i = 0; i < numBits; i++) {
      this.state = this.state.modPow(BigInt.two, this.n);
      result = toBig((result << 1) | (toBig(this.state & BigInt.one)));
    }

    return result;
  }

  static BigInt toBig(n) {
    if (n is int) return new BigInt.from(n);
    if (n is BigInt) return n;
    throw new ArgumentError.value(n);
  }

  static int toInt(n) {
    if (n is int) return n;
    if (n is BigInt) return n.toInt();
    throw new ArgumentError.value(n);
  }

  double nextDouble() => throw new UnimplementedError();

  static int neededBits(int max) {
    if (0 == max || 1 == max) return 1;
    return (log(max + 1) / log(2))
        .ceil(); // +1 because max would be no of possibilites
  }

  bool nextBool() {
    return 1 == next(1).toInt() ? true : false;
  }

  int nextInt(int max) {
    var bits = neededBits(max);
    var _max = toBig(max);
    while (true) {
      var value = next(bits);
      if (value < _max) return toInt(value);
    }
  }
}
