import 'package:test/test.dart';
import 'package:ton_dart/src/boc/bit/builder.dart';
import 'package:ton_dart/src/boc/utils/utils.dart';

void main() {
  _test();
}

void _test() {
  const List<String> cases = [
    '123',
    '12345678901234567890123456789012345678901234567890123456789012345678901234567890',
    'привет мир 👀 привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀привет мир 👀'
  ];
  test('should serialize and parse strings', () {
    for (final i in cases) {
      final cell = BocUtils.stringToCell(i);
      expect(BocUtils.readString(cell.beginParse()), i);
    }
    for (final i in cases) {
      final cell = beginCell().storeUint(0, 32).storeStringTail(i).endCell();
      expect(BocUtils.readString(cell.beginParse().skip(32)), i);
    }
  });
}
