//
// Modified by dyf on 2018/8/31.
// Copyright (c) 2018 dyf.
//

import 'dart:typed_data' show Uint8List;
import 'dart:math' show max;

import 'package:crypto/crypto.dart' as crypto;

const MD5Hash MD5 = const MD5Hash();
const SHA1Hash SHA1 = const SHA1Hash();
const SHA256Hash SHA256 = const SHA256Hash();

const Map<List<int>, HashFunction> HASHES = const {
  MD5Hash.ASN1CODE: MD5,
  SHA1Hash.ASN1CODE: SHA1,
  SHA256Hash.ASN1CODE: SHA256
};

abstract class HashFunction {
  List<int> get asn1code;
  List<int> hash(List<int> data);
  
  const HashFunction();
  
  List<int> digestInfo(Uint8List data) {
    // var info = []..addAll(asn1code)..addAll(hash(data)); //throws exception with this type.
    List<int> info = new List();
    
    info.addAll(asn1code);
    info.addAll(hash(data));

    return info;
  }
}

class MD5Hash extends HashFunction {
  static const List<int> ASN1CODE = const [0x30, 0x20, 0x30, 0x0c, 0x06, 0x08,
                                           0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d,
                                           0x02, 0x05, 0x05, 0x00, 0x04, 0x10];
  
  List<int> get asn1code => ASN1CODE;
  
  const MD5Hash();
  
  List<int> hash(List<int> data) {
    var md5 = crypto.md5;
    var digest = md5.convert(data);
    return digest.bytes;
  }
}

class SHA1Hash extends HashFunction {
  static const List<int> ASN1CODE = const [0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
                                           0x2b, 0x0e, 0x03, 0x02, 0x1a, 0x05,
                                           0x00, 0x04, 0x14];
  
  List<int> get asn1code => ASN1CODE;
  
  const SHA1Hash();
  
  List<int> hash(List<int> data) {
    var sha1 = crypto.sha1;
    var digest = sha1.convert(data);
    return digest.bytes;
  }
}

class SHA256Hash extends HashFunction {
  static const List<int> ASN1CODE = const [0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
                                           0x60, 0x86, 0x48, 0x01, 0x65, 0x03,
                                           0x04, 0x02, 0x01, 0x05, 0x00, 0x04,
                                           0x20];
  
  List<int> get asn1code => ASN1CODE;
  
  const SHA256Hash();
  
  List<int> hash(List<int> data) {
    var sha256 = crypto.sha256;
    var digest = sha256.convert(data);
    return digest.bytes;
  }
}

Uint8List emsaEncode(Uint8List data, int targetLength,
                     {HashFunction hashFunction: SHA256}) {
  var t = hashFunction.digestInfo(data);
  if (targetLength < t.length + 11)
    throw new ArgumentError.value(targetLength);
  var ps = new List.filled(max(targetLength - t.length - 3, 8), 0xff);
  var em = [0x00, 0x01]..addAll(ps)..add(0x00)..addAll(t);
  return new Uint8List.fromList(em);
}

bool startsWith(List<int> list, List<int> check) {
  for (int i = 0; i < check.length; i++) {
    if (list[i] != check[i]) return false;
  }
  return true;
}
