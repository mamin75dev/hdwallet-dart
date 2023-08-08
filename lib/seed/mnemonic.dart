import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:tsw/crypto/pbkdf2_hmac_sha512.dart';

class Mnemonic {
  List<String> dict;
  Uint8List ent;

  Mnemonic({required this.dict, required this.ent});

  String generate(int length) {
    var len = ent.length * 8;
    if (len < 128 || len > 256 || len % 32 != 0) {
      throw FormatException("Wrong entropy length");
    }
    var entHash = SHA256Digest().process(ent);
    Uint8List entWithChecksum = Uint8List(ent.length + 1);
    entWithChecksum.setAll(0, ent);
    entWithChecksum[entWithChecksum.length - 1] = entHash[0];
    print(entWithChecksum);
    String mnemonic = "";
    var cs = len / 32;
    for (int i = 0; i < len + cs; i += 11) {
      int wordIndex = _next11Bits(entWithChecksum, i);
      mnemonic += "${dict[wordIndex]} ";
    }
    return mnemonic.trim();
  }

  // List<String> _getWords() {}
  static Uint8List toBinarySeed(String mnemonic, String passPhrase) {
    return PBKDF2HMacSHA512Calculator(
            password: Uint8List.fromList(mnemonic.trim().codeUnits), salt: Uint8List.fromList("mnemonic$passPhrase".codeUnits))
        .process();
  }

  // bool validate() {}

  int _next11Bits(List<int> bytes, int offset) {
    int skip = offset ~/ 8;
    int lowerBitsToRemove = 13 - offset % 8;
    int value = ((bytes[skip] & 255) << 16) | ((bytes[skip + 1] & 255) << 8) | (lowerBitsToRemove < 8 ? (bytes[skip + 2] & 255) : 0);
    return (value >> lowerBitsToRemove) & 2047;
  }
}
