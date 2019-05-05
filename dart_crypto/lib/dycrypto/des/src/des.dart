import '../src/constants.dart';
import '../src/engine.dart';
import '../src/utils.dart';

class DESEngine extends BaseEngine {
  List<List<int>> _subKeys;
  int _lBlock;
  int _rBlock;

  String get algorithmName => "DES";

  int get blockSize => 64 ~/ 32;

  void init(bool forEncryption, List<int> key) {
    super.init(forEncryption, key);

    // Select 56 bits according to PC1
    var keyBits = new List<int>(56);
    for (var i = 0; i < 56; i++) {
      var keyBitPos = PC1[i] - 1;
      keyBits[i] = (rightShift32(
          this.key[rightShift32(keyBitPos, 5)], (31 - keyBitPos % 32))) &
      1;
    }

    // Assemble 16 subkeys
    var subKeys = this._subKeys = new List<List<int>>.generate(16, (_) => []);
    for (var nSubKey = 0; nSubKey < 16; nSubKey++) {
      // Create subkey
      var subKey = subKeys[nSubKey] = new List.generate(24, (_) => 0);

      // Shortcut
      var bitShift = BIT_SHIFTS[nSubKey];

      // Select 48 bits according to PC2
      for (var i = 0; i < 24; i++) {
        // Select from the left 28 key bits
        subKey[(i ~/ 6) | 0] |=
            leftShift32(keyBits[((PC2[i] - 1) + bitShift) % 28], (31 - i % 6));

        // Select from the right 28 key bits
        subKey[4 + ((i ~/ 6) | 0)] |= leftShift32(
            keyBits[28 + (((PC2[i + 24] - 1) + bitShift) % 28)], (31 - i % 6));
      }

      // Since each subkey is applied to an expanded 32-bit input,
      // the subkey can be broken into 8 values scaled to 32-bits,
      // which allows the key to be used without expansion
      subKey[0] = (subKey[0] << 1).toSigned(32) | rightShift32(subKey[0], 31);
      for (var i = 1; i < 7; i++) {
        subKey[i] = rightShift32(subKey[i], ((i - 1) * 4 + 3));
      }
      subKey[7] = (subKey[7] << 5).toSigned(32) | (rightShift32(subKey[7], 27));
    }
  }

  int processBlock(List<int> M, int offset) {
    List<List<int>> invSubKeys = new List(16);
    if (!forEncryption) {
      for (var i = 0; i < 16; i++) {
        invSubKeys[i] = _subKeys[15 - i];
      }
    }

    List<List<int>> subKeys = forEncryption ? _subKeys : invSubKeys;

    this._lBlock = M[offset].toSigned(32);
    this._rBlock = M[offset + 1].toSigned(32);
    // Initial permutation
    exchangeLR(4, 0x0f0f0f0f);
    exchangeLR(16, 0x0000ffff);
    exchangeRL(2, 0x33333333);
    exchangeRL(8, 0x00ff00ff);
    exchangeLR(1, 0x55555555);

    // Rounds
    for (var round = 0; round < 16; round++) {
      // Shortcuts
      var subKey = subKeys[round];
      var lBlock = this._lBlock;
      var rBlock = this._rBlock;

      // Feistel function
      var f = 0.toSigned(32);
      for (var i = 0; i < 8; i++) {
        (f |= (SBOX_P[i][((rBlock ^ subKey[i]).toSigned(32) & SBOX_MASK[i])
            .toUnsigned(32)])
            .toSigned(32))
            .toSigned(32);
      }
      this._lBlock = rBlock.toSigned(32);
      this._rBlock = (lBlock ^ f).toSigned(32);
    }

    // Undo swap from last round
    var t = this._lBlock;
    this._lBlock = this._rBlock;
    this._rBlock = t;

    // Final permutation
    exchangeLR(1, 0x55555555);
    exchangeRL(8, 0x00ff00ff);
    exchangeRL(2, 0x33333333);
    exchangeLR(16, 0x0000ffff);
    exchangeLR(4, 0x0f0f0f0f);

    // Set output
    M[offset] = this._lBlock;
    M[offset + 1] = this._rBlock;
    return blockSize;
  }

  void reset() {
    forEncryption = false;
    this.key = null;
    _subKeys = null;
    _lBlock = null;
    _rBlock = null;
  }

  // Swap bits across the left and right words
  void exchangeLR(offset, mask) {
    var t =
    (((rightShift32(this._lBlock, offset)).toSigned(32) ^ this._rBlock) &
    mask)
        .toSigned(32);
    (this._rBlock ^= t).toSigned(32);
    this._lBlock ^= (t << offset).toSigned(32);
  }

  void exchangeRL(offset, mask) {
    var t =
    (((rightShift32(this._rBlock, offset)).toSigned(32) ^ this._lBlock) &
    mask)
        .toSigned(32);
    (this._lBlock ^= t).toSigned(32);
    this._rBlock ^= (t << offset).toSigned(32);
  }
}



