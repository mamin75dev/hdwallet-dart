import 'dart:typed_data';

import 'package:pointycastle/export.dart';

class HmacSHA512Calculator {
  Uint8List _key;
  Uint8List _data;

  HmacSHA512Calculator({required Uint8List key, required Uint8List data})
      : _key = key,
        _data = data;

  Uint8List process() {
    var param = KeyParameter(_key);
    var hmac = HMac(SHA512Digest(), 128);
    hmac.init(param);
    return hmac.process(_data);
  }
}
