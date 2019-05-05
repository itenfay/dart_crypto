// Calculates the number of block processing times.
class RSABlock {
  final data;
  final int size;

  RSABlock(this.data, this.size);

  get source => data;
  get blockSize => size;

  get blockCount {
    int dataLength = data.length;

    var result = dataLength / size;
    var count = dataLength ~/ size;

    if (result > count) {
      count += 1;
    }

    return count;
  }
}
