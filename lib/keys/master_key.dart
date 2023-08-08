import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:tsw/crypto/hmac_sha512.dart';
import 'package:tsw/extensions/ec_private_key_extensions.dart';
import 'package:tsw/extensions/integer_list_extension.dart';

class MasterKey {
  Uint8List? _masterExtendedPrivateKey;
  Uint8List? _masterExtendedPublicKey;
  Uint8List? _masterExtendedChainCode;

  Uint8List? get getMasterExtendedPrivateKey => _masterExtendedPrivateKey;
  Uint8List? get getMasterExtendedPublicKey => _masterExtendedPublicKey;
  Uint8List? get getMasterExtendedChainCode => _masterExtendedChainCode;

  MasterKey.generateMasterKey(Uint8List seed) {
    var calculated = HmacSHA512Calculator(key: Uint8List.fromList("Bitcoin seed".codeUnits), data: seed).process();
    getPrvKeyFromHMac(calculated);
    getChainCodeFromHMac(calculated);
    getPublicKeyFromPrivate();
  }

  void getPrvKeyFromHMac(Uint8List hmac) {
    _masterExtendedPrivateKey = Uint8List.sublistView(hmac, 0, 32);
  }

  void getChainCodeFromHMac(Uint8List hmac) {
    _masterExtendedChainCode = Uint8List.sublistView(hmac, 32);
  }

  void getPublicKeyFromPrivate() {
    ECDomainParameters params = ECDomainParameters("secp256k1");
    var privateKey = ECPrivateKey(BigInt.parse(_masterExtendedPrivateKey?.toHex() ?? "", radix: 16), params);
    _masterExtendedPublicKey = privateKey.getPublic();
  }
}
