import '../src/des.dart';
import '../src/engine.dart';

class TripleDESEngine extends BaseEngine {
  String get algorithmName => "TripleDES";

  int get blockSize => 64 ~/ 32;

  int processBlock(List<int> M, int offset) {
    var des1 = new DESEngine();
    var des2 = new DESEngine();
    var des3 = new DESEngine();
    if (forEncryption) {
      des1.init(true, key.sublist(0, 2));
      des1.processBlock(M, offset);
      des2.init(false, key.sublist(2, 4));
      des2.processBlock(M, offset);
      des3.init(true, key.sublist(4, 6));
      des3.processBlock(M, offset);
    } else {
      des3.init(false, key.sublist(4, 6));
      des3.processBlock(M, offset);
      des2.init(true, key.sublist(2, 4));
      des2.processBlock(M, offset);
      des1.init(false, key.sublist(0, 2));
      des1.processBlock(M, offset);
    }
    return blockSize;
  }
}