import 'dart:math' as Math;

double log2(int number) => logn(number, 2);

double log256(int number) => logn(number, 256);

double logn(int number, int base) {
  var upper = Math.log(number);
  var lower = Math.log(base);
  return upper / lower;
}

int gcd(int a, int b) {
  a = a.abs();
  b = b.abs();
  if (b > a) {
    var temp = a;
    a = b;
    b = temp;
  }
  while (true) {
    a %= b;
    if (0 == a) return b;
    b %= a;
    if (b == 0) return a;
  }
}

int modPow(int base, int exponent, int modulus) {
  var result = 1;
  while (exponent > 0) {
    if ((exponent & 1) != 0) result = (base * result) % modulus;
    base = (base * base) % modulus;
    exponent >>= 1;
  }
  return result;
}

Math.Point egcd(int a, int b) {
  if (0 == a % b) return new Math.Point(0, 1);
  var p = egcd(b, a % b);
  return new Math.Point(p.y, p.x - p.y * (a / b));
}
