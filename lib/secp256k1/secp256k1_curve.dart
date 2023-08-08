import 'package:pointycastle/ecc/api.dart';

class Secp256K1Curve {
  ECDomainParameters? _params;
  Secp256K1Curve() {
    _params = ECDomainParameters("secp256k1");
  }

  ECDomainParameters get getParams => _params ?? ECDomainParameters("");

  BigInt getOrder() {
    return _params?.n ?? BigInt.zero;
  }

  ECPoint? getGenerator() {
    return _params?.G;
  }
}
