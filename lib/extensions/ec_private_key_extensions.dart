import 'dart:typed_data';

import 'package:pointycastle/export.dart';

extension ECPrivateKeyExtension on ECPrivateKey {
  Uint8List? getPublic() {
    ECPoint? Q = parameters!.G * d;
    return ECPublicKey(Q, parameters).Q?.getEncoded();
  }
}
