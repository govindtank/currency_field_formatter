import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:currency_field_formatter/currency_field_formatter.dart';

void main() {
  group('CurrencyFieldFormatter Unit Tests', () {
    test('Formats USD input properly', () {
      final formatter = CurrencyFieldFormatter.usd();

      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(
        text: '1234567',
        selection: TextSelection.collapsed(offset: 7),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, r'$1,234,567');
      expect(result.selection.baseOffset, 10);
      expect(formatter.numericValue, 1234567.0);
      expect(formatter.integerCents, 123456700);
    });

    test('Formats Indian Lakhs and Crores grouping (3, 2, 2)', () {
      final formatter = CurrencyFieldFormatter.inr();

      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(
        text: '10000000', // 1 Crore
        selection: TextSelection.collapsed(offset: 8),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '₹ 1,00,00,000');
      expect(formatter.numericValue, 10000000.0);
    });

    test('Formats Euro with suffix symbol and period thousands', () {
      final formatter = CurrencyFieldFormatter.eur();

      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(
        text: '1234567,89',
        selection: TextSelection.collapsed(offset: 10),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '1.234.567,89 €');
      expect(formatter.numericValue, 1234567.89);
      expect(formatter.integerCents, 123456789);
    });

    test('Mid-string insertion preserves exact cursor position', () {
      final formatter = CurrencyFieldFormatter.usd();

      // Start with $1,234
      const oldValue = TextEditingValue(
        text: r'$1,234',
        selection: TextSelection.collapsed(offset: 4), // After '2' ($1,2|34)
      );

      // User types '9' at offset 4 -> $1,2934
      const newValue = TextEditingValue(
        text: r'$1,2934',
        selection: TextSelection.collapsed(offset: 5),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, r'$12,934');
      // Cursor should land immediately after '9' -> offset 5 ($12,9|34)
      expect(result.selection.baseOffset, 5);
      expect(formatter.numericValue, 12934.0);
    });

    test('Backspace on comma separator deletes preceding digit cleanly', () {
      final formatter = CurrencyFieldFormatter.usd();

      // State: $1,234 with cursor after comma ($1,|234 -> offset 3)
      const oldValue = TextEditingValue(
        text: r'$1,234',
        selection: TextSelection.collapsed(offset: 3),
      );

      // User hits backspace on comma -> deletes comma ($1234 at offset 2)
      const newValue = TextEditingValue(
        text: r'$1234',
        selection: TextSelection.collapsed(offset: 2),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);
      // Deleting comma should remove '1' -> leaves 234 ($234)
      expect(result.text, r'$234');
      expect(formatter.numericValue, 234.0);
    });

    test('JPY zero-decimal formatting', () {
      final formatter = CurrencyFieldFormatter.jpy();

      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(
        text: '50000',
        selection: TextSelection.collapsed(offset: 5),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '¥50,000');
      expect(formatter.numericValue, 50000.0);
      expect(formatter.integerCents, 50000);
    });
  });
}
