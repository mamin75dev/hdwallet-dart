class DerivationPath {
  int? _purpose;
  int? _coinType;
  int? _account;
  int? _change;
  int? _index;

  int get getPurpose => _purpose ?? 0;
  int get getCoinType => _coinType ?? 0;
  int get getAccount => _account ?? 0;
  int get getChange => _change ?? 0;
  int get getIndex => _index ?? 0;

  DerivationPath.fromPathString(String path) {
    List<String> keyPathArr = path.split("/");
    List<int> numbers = List<int>.filled(5, 0);

    for (int i = 1; i < keyPathArr.length; i++) {
      numbers[i - 1] = int.parse(keyPathArr[i].replaceAll("'", ""));
    }

    _purpose = numbers[0];
    _coinType = numbers[1];
    _account = numbers[2];
    _change = numbers[3];
    _index = numbers[4];
  }
}
