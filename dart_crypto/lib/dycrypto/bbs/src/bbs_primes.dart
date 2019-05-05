import 'dart:math' show Random;

// Copies bigInt, then judges whether a large number is prime or not.
class CopyBigInt {
  final BigInt a;
  final int _s = 100; // s is random

  CopyBigInt(this.a);

  BigInt get bigInt => a;

  // (a*b)%c a,b,c<2^63
  int modMult(int a, int b, int mod) {
    a = a % mod;
    b = b % mod;

    int ans = 0;

    while (b != 0) {
      if ((b & 1) != 0) {
        ans = ans + a;
        if (ans >= mod) ans = ans - mod;
      }
      a = a << 1;
      if (a >= mod) a = a - mod;
      b = b >> 1;
    }

    return ans;
  }

  // a^b%mod
  int modPow(int a, int b, int mod) {
    int ans = 1;
    a = a % mod;

    while (b != 0) {
      if ((b & 1) != 0) {
        ans = modMult(ans, a, mod);
      }
      a = modMult(a, a, mod);
      b = b >> 1;
    }

    return ans;
  }

  // Verifies wether n is composite number or not.
  // Return true, it must be.
  // Return false, it may be.
  // n-1=x*2^t, a^(n-1)=1(mod n)
  bool check(int a, int n, int x, int t) {
    int ret = modPow(a, x, n);
    int last = ret;

    for (int i = 1; i <= t; i++) {
      ret = modMult(ret, ret, n);
      if (ret == 1 && last != 1 && last != n - 1)
        return true; //composite number
      last = ret;
    }

    if (ret != 1)
      return true;
    else
      return false;
  }

  // Miller Rabin algorithm prime judging.
  // Return true, it may be pseudo prime, but the probability is minimal.
  // Return false, it is composite number.
  bool millerRabin(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if ((n & 1) == 0) return false; // even number

    int x = n - 1;
    int t = 0;

    while ((x & 1) == 0) {
      x >>= 1;
      t++;
    }

    // var max = 1 << 32;
    for (int i = 0; i < _s; i++) {
      // Random().nextInt(max) % (n - 1) + 1;
      int a = this.a.toInt() % (n - 1) + 1;
      if (check(a, n, x, t)) return false; //composite number
    }

    return true;
  }

  // Judges whether a large number is prime
  bool isProbablePrime(int s) {
    return millerRabin(s);
  }
}

BigInt bigPrime([int bits = 256, Random random]) {
  var candidate = getRandBits(bits, random);

  candidate = candidate | BigInt.one; // Ensure uneven

  while (true) {
    var cbi = new CopyBigInt(candidate);
    if (cbi.isProbablePrime(5)) return candidate;
    candidate = candidate + BigInt.two;
  }
}

BigInt getRandBits(int n, [Random random]) {
  if (0 >= n) throw new ArgumentError.value(n);
  if (null == random) random = new Random();

  var l = new List.generate(n, (_) => random.nextInt(2));
  var i = 0;
  return l.fold(BigInt.one, (BigInt acc, int c) {
    i++;
    if (0 == c) {
      return acc;
    }
    return acc + BigInt.two.pow(i - 1);
  });
}
