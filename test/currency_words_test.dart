import 'package:flutter_test/flutter_test.dart';
import 'package:currency_field_formatter/currency_field_formatter.dart';

void main() {
  group('CurrencyWords - Indian Numbering System (Lakhs & Crores)', () {
    test('converts zero properly', () {
      expect(CurrencyWords.convert(0), equals('Zero Rupees'));
    });

    test('converts small amounts', () {
      expect(CurrencyWords.convert(500), equals('Five Hundred Rupees'));
      expect(CurrencyWords.convert(1250),
          equals('One Thousand Two Hundred Fifty Rupees'));
    });

    test('converts Lakhs accurately', () {
      expect(CurrencyWords.convert(100000), equals('One Lakh Rupees'));
      expect(CurrencyWords.convert(250000),
          equals('Two Lakh Fifty Thousand Rupees'));
      expect(
          CurrencyWords.convert(9999999),
          equals(
              'Ninety-Nine Lakh Ninety-Nine Thousand Nine Hundred Ninety-Nine Rupees'));
    });

    test('converts Crores accurately', () {
      expect(CurrencyWords.convert(10000000), equals('One Crore Rupees'));
      expect(CurrencyWords.convert(15400000),
          equals('One Crore Fifty-Four Lakh Rupees'));
    });

    test('converts paise fractional amounts', () {
      expect(
        CurrencyWords.convert(100.50),
        equals('One Hundred Rupees and Fifty Paise'),
      );
    });

    test('num extension works identically', () {
      expect(
          250000.toCurrencyWords(), equals('Two Lakh Fifty Thousand Rupees'));
    });
  });

  group('CurrencyWords - Western Numbering System (Millions & Billions)', () {
    test('converts millions and billions with USD units', () {
      final words = CurrencyWords.convert(
        1500000,
        system: NumberingSystem.western,
        majorUnit: 'Dollars',
        minorUnit: 'Cents',
      );
      expect(words, equals('One Million Five Hundred Thousand Dollars'));
    });
  });
}
