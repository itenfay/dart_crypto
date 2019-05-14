import 'dart:math';
import '../src/utils.dart';

abstract class Engine {
  void init(bool forEncryption, List<int> key);
  List<int> process(List<int> dataWords);
  void reset();
}

/// BufferedBlockAlgorithm.process()
abstract class BaseEngine implements Engine {
  bool forEncryption;
  List<int> key;

  void init(bool forEncryption, List<int> key) {
    this.key = key;
    this.forEncryption = forEncryption;
  }

  void reset() {
    key = null;
    forEncryption = false;
  }

  int processBlock(List<int> M, int offset);

  List<int> process(List<int> dataWords) {
    var blockSize = 2;

    if (forEncryption) {
      pkcs7Pad(dataWords, blockSize);
    }

    var doFlush = false;
    var dataSigBytes = dataWords.length;
    var blockSizeBytes = blockSize * 4;
    var minBufferSize = 0;

    // Count blocks ready
    var nBlocksReady = dataSigBytes ~/ blockSizeBytes;
    if (doFlush) {
      // Round up to include partial blocks
      nBlocksReady = nBlocksReady.ceil();
    } else {
      // Round down to include only full blocks,
      // less the number of blocks that must remain in the buffer
      nBlocksReady = max((nBlocksReady | 0) - minBufferSize, 0);
    }

    // Count words ready
    var nWordsReady = nBlocksReady * blockSize;

    // Count bytes ready
    var nBytesReady = min(nWordsReady * 4, dataSigBytes);

    // Process blocks
    List<int> processedWords;
    if (nWordsReady != 0) {
      for (var offset = 0; offset < nWordsReady; offset += blockSize) {
        // Perform concrete-algorithm logic
        processBlock(dataWords, offset);
      }

      // Remove processed words
      processedWords = dataWords.getRange(0, nWordsReady).toList();
      dataWords.removeRange(0, nWordsReady);
    }

    var result = new List<int>.generate(nBytesReady, (i) {
      if (i < processedWords.length) {
        return processedWords[i];
      }
      return 0;
    });

    if (!forEncryption) {
      pkcs7Unpad(result, blockSize);
    }

    return result;
  }
}