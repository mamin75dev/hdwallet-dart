import 'dart:typed_data';

import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';

class PBKDF2HMacSHA512Calculator {
  Uint8List _password;
  Uint8List _salt;

  PBKDF2HMacSHA512Calculator({required Uint8List password, required Uint8List salt})
      : _salt = salt,
        _password = password;

  Uint8List process() {
    var factory = PBKDF2KeyDerivator(HMac(SHA512Digest(), 128));
    var params = Pbkdf2Parameters(_salt, 2048, 64);
    factory.init(params);
    return factory.process(_password);
  }
}
