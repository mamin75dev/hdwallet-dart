import 'dart:typed_data';

import 'package:pointycastle/impl.dart';
import 'package:tsw/crypto/hmac_sha512.dart';
import 'package:tsw/ecdsa/ecdsa_keypair.dart';
import 'package:tsw/extensions/ec_private_key_extensions.dart';
import 'package:tsw/extensions/integer_extensions.dart';
import 'package:tsw/extensions/integer_list_extension.dart';
import 'package:tsw/extensions/string-extensions.dart';
import 'package:tsw/keys/derivation_path.dart';
import 'package:tsw/secp256k1/secp256k1_curve.dart';

class ChildKey {
  static const int START_INDEX = 2147483648;

  String _privateKey;
  String _chainCode;
  String _publicKey;
  Secp256K1Curve curve;

  ChildKey({required String prvKey, required String pubKey, required String chainCode})
      : curve = Secp256K1Curve(),
        _privateKey = prvKey,
        _publicKey = pubKey,
        _chainCode = chainCode;

  void _deriveChild(String input) {
    var data = input.toUint8List();
    var key = _chainCode.toUint8List();

    Uint8List hmac = HmacSHA512Calculator(key: key, data: data).process();
    var computedPrvKey = Uint8List.sublistView(hmac, 0, 32);
    var computedChainCode = Uint8List.sublistView(hmac, 32);

    if (BigInt.parse(computedChainCode.toHex(), radix: 16).compareTo(curve.getOrder()) < 0) {
      _chainCode = computedChainCode.toHex();
    } else {
      print("error");
      return;
    }

    var computedPrvKeyNumber = (BigInt.parse(computedPrvKey.toHex(), radix: 16) + BigInt.parse(_privateKey, radix: 16)) % curve.getOrder();
    var newPrvKey = computedPrvKeyNumber.toRadixString(16);
    if (newPrvKey.length == 63) {
      newPrvKey = "0$newPrvKey";
    }
    _privateKey = newPrvKey;
    var newPublicKey = ECPrivateKey(computedPrvKeyNumber, curve.getParams).getPublic()?.toHex();
    if (newPublicKey?.length == 65) {
      newPublicKey = "0$newPublicKey";
    }
    _publicKey = newPublicKey ?? "";
  }

  void _deriveNormalChild(int index) {
    String input = "$_publicKey${index.to4ByteHex()}";
    _deriveChild(input);
  }

  void _deriveHardenedChild(int index) {
    String input = "00$_privateKey${index.to4ByteHex()}";
    _deriveChild(input);
  }

  ECDSAKeyPair deriveChildKeyPairFromDerivationPath(DerivationPath path) {
    List<int> normalIndexes = [path.getChange, path.getIndex];
    List<int> hardenedIndexes = [START_INDEX + path.getPurpose, START_INDEX + path.getCoinType, START_INDEX + path.getAccount];

    for (var i in hardenedIndexes) {
      _deriveHardenedChild(i);
    }
    for (var i in normalIndexes) {
      _deriveNormalChild(i);
    }
    return ECDSAKeyPair(prvKey: getPrivateKey, pubKey: getPublicKey);
  }

  String get getPrivateKey => _privateKey;
  String get getChainCode => _chainCode;
  String get getPublicKey => _publicKey;
}
