import 'dart:math' show max, Random;
import 'dart:typed_data' show Uint8List;

import '../../bbs/bbs.dart' show BlumBlumShub;

const PKCS1Padding PKCS1_PADDING = const PKCS1Padding();

abstract class Padding {
  Uint8List apply(Uint8List input, int k);
  
  Uint8List strip(Uint8List padded);
}

class PKCS1Padding implements Padding {
  const PKCS1Padding();
  
  Uint8List apply(Uint8List input, int k) {
    var octets = randomOctets(k - input.length - 3);
    var padded = [0x00, 0x02]..addAll(octets)
                             ..add(0x00)
                             ..addAll(input);
    return new Uint8List.fromList(padded);
  }
  
  Uint8List strip(Uint8List bytes) {
    if (!_isValidSequence(bytes))
      throw new ArgumentError.value(bytes);
    var start = bytes.indexOf(0x00, 2);
    var m = bytes.sublist(start + 1);
    return m;
  }
  
  bool _isValidSequence(Uint8List bytes) {
    if (bytes[0] != 0x00) return false;
    if (bytes[1] != 0x02) return false;
    var index = bytes.indexOf(0x00, 2);
    if (-1 == index) return false;
    var ps = bytes.sublist(2, index);
    if (8 > ps.length) return false;
    return true;
  }
  
  List<int> randomOctets(int length, {Random random}) {
    if (null == random) random = new BlumBlumShub();
    length = max(8, length);
    var octets = new List.generate(length, (_) => random.nextInt(254) + 1);
    return octets;
  }
}