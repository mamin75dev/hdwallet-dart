import 'dart:math';
import 'dart:typed_data';

import 'package:tsw/extensions/integer_list_extension.dart';

class Entropy {
  static Uint8List generateEntropy() {
    var generator = Random.secure();
    var numbers = List.generate(32, (index) => generator.nextInt(256));
    var entropy = Uint8List.fromList(numbers);
    print("entropy string:: ${entropy.toBinaryString()}");
    print(entropy);
    print("entropy length:: ${entropy.toBinaryString().length}");
    return entropy;
  }
}
