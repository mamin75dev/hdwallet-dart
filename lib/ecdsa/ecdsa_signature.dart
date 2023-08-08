import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:tsw/ecdsa/ecdsa_keypair.dart';
import 'package:tsw/extensions/integer_list_extension.dart';
import 'package:tsw/extensions/string-extensions.dart';
import 'package:tsw/secp256k1/secp256k1_curve.dart';

class ECDSASignature {
  ECDSAKeyPair _pair;
  Secp256K1Curve _curve;
  ECDSASigner _signer;
  ECSignature? _signature;

  ECDSASignature({required ECDSAKeyPair pair})
      : _curve = Secp256K1Curve(),
        _signer = ECDSASigner(null, HMac(SHA256Digest(), 64)),
        _pair = pair;

  ECDSAKeyPair get getPair => _pair;
  Secp256K1Curve get getCurve => _curve;
  ECSignature? get getSignature => _signature;

  void signMessage(Uint8List message) {
    var prvKey = ECPrivateKey(_pair.getPrivateKey, _curve.getParams);
    var params = PrivateKeyParameter(prvKey);
    _signer.init(true, params);
    _signature = _signer.generateSignature(message) as ECSignature;
  }

  String getDEREncodedSignature() {
    var rBytes = _signature?.r.toRadixString(16).padLeft(64, '0').toUint8List() ?? Uint8List(1);
    var sBytes = _signature?.s.toRadixString(16).padLeft(64, '0').toUint8List() ?? Uint8List(1);
    return Uint8List.fromList([
      0x30,
      2 + rBytes.length + 2 + sBytes.length,
      0x02,
      rBytes.length,
      ...rBytes,
      0x02,
      sBytes.length,
      ...sBytes,
    ]).toHex();
  }
}
