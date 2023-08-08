extension IntegerExtension on int {
  String to4ByteHex() {
    String hexNumber = toRadixString(16).padLeft(8, '0');
    return hexNumber;
  }
}
