import 'dart:typed_data';

import 'package:tsw/extensions/integer_list_extension.dart';
import 'package:tsw/seed/dictionary/eng.dart';
import 'package:tsw/seed/entropy.dart';
import 'package:tsw/seed/mnemonic.dart';

import 'keys/child_key.dart';
import 'keys/derivation_path.dart';
import 'keys/master_key.dart';

void main() {
  // var ent = Entropy.generateEntropy();
  // var ent = Uint8List.fromList([
  //   42,
  //   179,
  //   204,
  //   229,
  //   102,
  //   154,
  //   109,
  //   16,
  //   181,
  //   89,
  //   235,
  //   147,
  //   131,
  //   177,
  //   190,
  //   3,
  //   158,
  //   69,
  //   19,
  //   108,
  //   91,
  //   124,
  //   150,
  //   201,
  //   139,
  //   167,
  //   32,
  //   74,
  //   58,
  //   46,
  //   88,
  //   217
  // ]);
  // var mnemonicGenerator = Mnemonic(dict: engDict, ent: ent);
  // String mnemonic = mnemonicGenerator.generate(24);
  // print(mnemonic);
  String wallet = "extra little brown creek replace pattern produce gravity second mad poverty october";
  print(wallet.trim());
  // print(mnemonicGenerator.toBinarySeed(mnemonic, "").toHex());
  var seed = Mnemonic.toBinarySeed(wallet, "");
  print(seed.toHex());

  var masterKey = MasterKey.generateMasterKey(seed);
  print(masterKey.getMasterExtendedPrivateKey?.toHex());
  print(masterKey.getMasterExtendedChainCode?.toHex());
  print(masterKey.getMasterExtendedPublicKey?.toHex());

  var key = ChildKey(
    prvKey: masterKey.getMasterExtendedPrivateKey?.toHex() ?? "",
    pubKey: masterKey.getMasterExtendedPublicKey?.toHex() ?? "",
    chainCode: masterKey.getMasterExtendedChainCode?.toHex() ?? "",
  );

  var path = DerivationPath.fromPathString("m/44'/60'/0'/0/0");
  var pair = key.deriveChildKeyPairFromDerivationPath(path);

  print('-------------------------------------------------');
  print(pair.getPrivateKey.toRadixString(16).padLeft(64, '0'));
  print(pair.getPublicKey.toRadixString(16).padLeft(66, '0'));
}


// 73603c66feae7d1099fcbead585cfa4e43e5d255cae4fcb836c206dd3c3c7937ca4e4a6d1755cf34f31c2674fd66411955807e920a35b672fa6d11a50eb26158e2c3d8307ab1c202e663688e62ecd16e9b7427a3e013a7ca3864274693577029af0dd87ee0ae9de071d1fc51b071e865837d669dac8c36cd1743437661694e41e12a1286f69301b71762bb9e702e7de3e0f5f44b88e6393bce0564252e7a8f3e4c96ab850e7e044075908fa494f478a1d634d4f33974ede38af556bb49b910f3a9c623207053e44b61827b830c47adf9e996e96f4f3a738c7f9c92aec1a338c51163a2e31a3807be5f798e723a5bc977e46f2b32e809ea3b7edbe3f79459d5c9155a89c047567b41dff5948a408a03bdc6c85a052ac281c74879b39d352c04ff28265316d7964f365c925e72bbd5e554e5502273f33adffcd2e006518d24c914a23d856f7e87ec7b8ed16878d39590e6346c6e988036ee9a41e5f3d5daa88fab1356f31281cf48ce283526ecf509b261874a16438e1e380c8e082bbf8fb8dd26a4a1ba6dab1cd3ade5e0866d681fc623e1936275822c7a9ad96edfcc83e13e2281e8cd527bc0ea43c62ebe696c46117bab8799cb69258e90326ac64432f53ea070a97711b6dae1d7139512bec2a39c1cdef90144920f549f61b426fc8c198c47f22b50d3c78543a9f2d6a0971a9caa7eb04f8d267c160f224affe337cd4dd22b
// 73603c66feae7d1099fcbead585cfa4e43e5d255cae4fcb836c206dd3c3c7937ca4e4a6d1755cf34f31c2674fd66411955807e920a35b672fa6d11a50eb26158