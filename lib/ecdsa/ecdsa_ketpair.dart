class ECDSAKeyPair {
  final BigInt _privateKey;
  final BigInt _publicKey;

  ECDSAKeyPair({required String prvKey, required String pubKey})
      : _privateKey = BigInt.parse(prvKey, radix: 16),
        _publicKey = BigInt.parse(pubKey, radix: 16);

  BigInt get getPrivateKey => _privateKey;
  BigInt get getPublicKey => _publicKey;
}
