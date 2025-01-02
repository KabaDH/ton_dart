import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:test/test.dart';
import 'package:ton_dart/src/address/address/address.dart';
import 'package:ton_dart/src/boc/bit/bit_builder.dart';
import 'package:ton_dart/src/boc/cell/cell.dart';
import 'dart:math' show Random;

final _random = Random.secure();

int _generateRandom() {
  final len = _random.nextInt(6) + 1;
  assert(len > 0 && len <= 6);
  final rand = QuickCrypto.generateRandom(len);
  return IntUtils.fromBytes(rand);
}

int _generateRandomSign() {
  final len = _random.nextInt(6) + 1;
  assert(len > 0 && len <= 6);
  final rand = QuickCrypto.generateRandom(len);
  final sign = _random.nextBool();
  final num = IntUtils.fromBytes(rand);
  if (sign) return -num;
  return num;
}

void main() {
  group('slice', () => _test());
}

void _test() {
  test('should read uints from slice', () {
    for (int i = 0; i < 1000; i++) {
      final a = _generateRandom();
      final b = _generateRandom();
      final builder = BitBuilder();
      builder.writeUint(a, 48);
      builder.writeUint(b, 48);
      final bits = builder.build();

      {
        final reader = Cell(bits: bits).beginParse();
        expect(reader.preloadUint(48), a);
        expect(reader.loadUint(48), a);
        expect(reader.preloadUint(48), b);
        expect(reader.loadUint(48), b);
      }

      {
        final reader = Cell(bits: bits).beginParse();
        expect(reader.preloadUintBig(48).toInt(), a);
        expect(reader.loadUintBig(48).toInt(), a);
        expect(reader.preloadUintBig(48).toInt(), b);
        expect(reader.loadUintBig(48).toInt(), b);
      }
    }
  });
  test('should read ints from slice', () {
    for (int i = 0; i < 1000; i++) {
      final a = _generateRandomSign();
      final b = _generateRandomSign();
      final builder = BitBuilder();
      builder.writeInt(a, 49);
      builder.writeInt(b, 49);
      final bits = builder.build();

      {
        final reader = Cell(bits: bits).beginParse();
        expect(reader.preloadInt(49), a);
        expect(reader.loadInt(49), a);
        expect(reader.preloadInt(49), b);
        expect(reader.loadInt(49), b);
      }

      {
        final reader = Cell(bits: bits).beginParse();
        expect(reader.preloadIntBig(49).toInt(), a);
        expect(reader.loadIntBig(49).toInt(), a);
        expect(reader.preloadIntBig(49).toInt(), b);
        expect(reader.loadIntBig(49).toInt(), b);
      }
    }
  });
  test('should read var uints from slice', () {
    for (int i = 0; i < 1000; i++) {
      final sizeBits = _random.nextInt(4) + 4;
      final a = _generateRandom();
      final b = _generateRandom();
      final builder = BitBuilder();
      builder.writeVarUint(a, sizeBits);
      builder.writeVarUint(b, sizeBits);
      final bits = builder.build();

      {
        final reader = Cell(bits: bits).beginParse();
        expect(reader.preloadVarUint(sizeBits), a);
        expect(reader.loadVarUint(sizeBits), a);
        expect(reader.preloadVarUint(sizeBits), b);
        expect(reader.loadVarUint(sizeBits), b);
      }

      {
        final reader = Cell(bits: bits).beginParse();
        expect(reader.preloadVarUintBig(sizeBits).toInt(), a);
        expect(reader.loadVarUintBig(sizeBits).toInt(), a);
        expect(reader.preloadVarUintBig(sizeBits).toInt(), b);
        expect(reader.loadVarUintBig(sizeBits).toInt(), b);
      }
    }
  });
  test('should read var ints from slice', () {
    for (int i = 0; i < 1000; i++) {
      final sizeBits = _random.nextInt(4) + 4;
      final a = _generateRandomSign();
      final b = _generateRandomSign();
      final builder = BitBuilder();
      builder.writeVarInt(a, sizeBits);
      builder.writeVarInt(b, sizeBits);
      final bits = builder.build();

      {
        final reader = Cell(bits: bits).beginParse();
        expect(reader.preloadVarInt(sizeBits), a);
        expect(reader.loadVarInt(sizeBits), a);
        expect(reader.preloadVarInt(sizeBits), b);
        expect(reader.loadVarInt(sizeBits), b);
      }

      {
        final reader = Cell(bits: bits).beginParse();
        expect(reader.preloadVarIntBig(sizeBits).toInt(), a);
        expect(reader.loadVarIntBig(sizeBits).toInt(), a);
        expect(reader.preloadVarIntBig(sizeBits).toInt(), b);
        expect(reader.loadVarIntBig(sizeBits).toInt(), b);
      }
    }
  });
  test('should read coins from slice', () {
    for (int i = 0; i < 1000; i++) {
      final a = _generateRandom();
      final b = _generateRandom();
      final builder = BitBuilder();
      builder.writeCoins(a);
      builder.writeCoins(b);
      final bits = builder.build();
      final reader = Cell(bits: bits).beginParse();
      expect(reader.preloadCoins().toInt(), a);
      expect(reader.loadCoins().toInt(), a);
      expect(reader.preloadCoins().toInt(), b);
      expect(reader.loadCoins().toInt(), b);
    }
  });

  test('should read address from slice', () {
    for (int i = 0; i < 1000; i++) {
      final a = i.isEven
          ? null
          : TonAddress.fromBytes(-1, QuickCrypto.generateRandom());
      final b = TonAddress.fromBytes(0, QuickCrypto.generateRandom());
      final builder = BitBuilder();
      builder.writeAddress(a);
      builder.writeAddress(b);
      final bits = builder.build();
      final reader = Cell(bits: bits).beginParse();
      expect(reader.loadMaybeAddress()?.toString(), a?.toString());
      expect(reader.loadAddress().toString(), b.toString());
    }
  });
}
