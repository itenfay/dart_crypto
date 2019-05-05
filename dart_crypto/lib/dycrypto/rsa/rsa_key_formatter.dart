// Converts the key to the content of pem for RSA
class RSAKeyFormatter {
  static formatRSAPublicKey(String publicKey) {
    if (publicKey == null) return null;

    var buffer = new StringBuffer();
    buffer.write("-----BEGIN PUBLIC KEY-----\n");

    final length = publicKey.length;
    int count = 0;

    for (var i = 0; i < length; i++) {
      var c = publicKey.codeUnitAt(i);
      var s = String.fromCharCode(c);
      if (s == "\n" || s == "\r") {
        continue;
      }
      buffer.writeCharCode(c);
      if (++count == 64) {
        buffer.write("\n");
        count = 0;
      }
    }

    buffer.write("\n-----END PUBLIC KEY-----\n");

    return buffer.toString();
  }

  static formatRSAPrivateKey(String privateKey) {
    if (privateKey == null) return null;

    var buffer = new StringBuffer();
    buffer.write("-----BEGIN PRIVATE KEY-----\n");

    final length = privateKey.length;
    int count = 0;

    for (var i = 0; i < length; i++) {
      var c = privateKey.codeUnitAt(i);
      var s = String.fromCharCode(c);
      if (s == "\n" || s == "\r") {
        continue;
      }
      buffer.writeCharCode(c);
      if (++count == 64) {
        buffer.write("\n");
        count = 0;
      }
    }

    buffer.write("\n-----END PRIVATE KEY-----\n");

    return buffer.toString();
  }
}
