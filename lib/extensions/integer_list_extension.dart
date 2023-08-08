import 'dart:typed_data';

extension IntegerList on Uint8List {
  String toBinaryString() {
    return map((number) => number.toRadixString(2).padLeft(8, '0')).join();
  }

  String toHex() {
    return map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }
}
