import 'package:tsw/ecdsa/ecdsa_signature.dart';
import 'package:tsw/extensions/integer_list_extension.dart';
import 'package:tsw/extensions/string-extensions.dart';
import 'package:tsw/seed/mnemonic.dart';

import 'keys/child_key.dart';
import 'keys/derivation_path.dart';
import 'keys/master_key.dart';

void main() {
  // var ent = Entropy.generateEntropy();
  // var mnemonicGenerator = Mnemonic(dict: engDict, ent: ent);
  // String mnemonic = mnemonicGenerator.generate(24);
  // print(mnemonic);
  String wallet = "extra little brown creek replace pattern produce gravity second mad poverty october";
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

  var path = DerivationPath.fromPathString("m/44'/60'/0'/0/1");
  var pair = key.deriveChildKeyPairFromDerivationPath(path);

  print('-------------------------------------------------');
  print(pair.getPrivateKey.toRadixString(16).padLeft(64, '0'));
  print(pair.getPublicKey.toRadixString(16).padLeft(66, '0'));

  var msg = "56ba58370db772d848b55733f441aa2cec37820f8d689469a64f74a071d8095c".toUint8List();
  var signer = ECDSASignature(pair: pair);
  signer.signMessage(msg);
  print(signer.getDEREncodedSignature());
}
