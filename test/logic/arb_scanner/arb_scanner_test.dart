import 'package:l10n_decompose/src/logic/scanner/arb_scanner.dart';
import 'package:test/test.dart';

void main() {
  group('ArbEntry', () {
    test('should parse valid file name with locale', () {
      expect(
        ArbEntry.parseArbFileName('home_ru.arb'),
        equals((name: 'home', locale: 'ru', country: null)),
      );
    });

    test('should parse valid file name with locale and country code', () {
      expect(
        ArbEntry.parseArbFileName('home_ru_RU.arb'),
        equals((name: 'home', locale: 'ru', country: 'RU')),
      );
    });

    test('should parse valid separated file name with locale', () {
      expect(
        ArbEntry.parseArbFileName('my_feature_ru.arb'),
        equals((name: 'my_feature', locale: 'ru', country: null)),
      );
    });

    test('should parse valid separated file name with locale and country code', () {
      expect(
        ArbEntry.parseArbFileName('my_feature_ru_RU.arb'),
        equals((name: 'my_feature', locale: 'ru', country: 'RU')),
      );
    });

    test('should return null if invalid file name', () {
      expect(ArbEntry.parseArbFileName('invalid.arb'), isNull);
    });

    test('should return null if locale code is incorrect', () {
      expect(ArbEntry.parseArbFileName('test_eng.arb'), isNull);
    });

    test('should return true for valid file name ', () {
      expect(
        ArbEntry.matches('home_ru.arb'),
        isTrue,
      );

      expect(
        ArbEntry.matches('home_ru_RU.arb'),
        isTrue,
      );

      expect(
        ArbEntry.matches('my_feature_ru.arb'),
        isTrue,
      );

      expect(
        ArbEntry.matches('my_feature_ru_RU.arb'),
        isTrue,
      );
    });

    test('should return false for invalid file name ', () {
      expect(
        ArbEntry.matches('invalid.arb'),
        isFalse,
      );

      expect(
        ArbEntry.matches('test_eng.arb'),
        isFalse,
      );
    });
  });
}
