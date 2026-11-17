import 'currency_options.dart';

/// Utility to convert numbers and currency amounts into spoken words.
/// Supports Indian numbering (Lakhs/Crores) and International (Millions/Billions).
class CurrencyWords {
  const CurrencyWords._();

  static const List<String> _ones = [
    '',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen',
  ];

  static const List<String> _tens = [
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety',
  ];

  /// Converts a numeric amount into words.
  ///
  /// Examples:
  /// - `250000` (Indian) -> `"Two Lakh Fifty Thousand Rupees"`
  /// - `10000000` (Indian) -> `"One Crore Rupees"`
  /// - `1500000.50` (Western) -> `"One Million Five Hundred Thousand Dollars and Fifty Cents"`
  static String convert(
    num amount, {
    NumberingSystem system = NumberingSystem.indianLakhCrore,
    String majorUnit = 'Rupees',
    String minorUnit = 'Paise',
    bool includeUnits = true,
  }) {
    if (amount == 0) {
      return includeUnits ? 'Zero $majorUnit' : 'Zero';
    }

    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final wholePart = absAmount.truncate();
    final fractionPart = ((absAmount - wholePart) * 100).round();

    String wholeWords;
    if (system == NumberingSystem.indianLakhCrore) {
      wholeWords = _convertIndian(wholePart);
    } else {
      wholeWords = _convertWestern(wholePart);
    }

    if (wholeWords.isEmpty) {
      wholeWords = 'Zero';
    }

    final buffer = StringBuffer();
    if (isNegative) {
      buffer.write('Minus ');
    }
    buffer.write(wholeWords);

    if (includeUnits && majorUnit.isNotEmpty) {
      buffer.write(' $majorUnit');
    }

    if (fractionPart > 0) {
      final fractionWords = _convertTwoDigits(fractionPart);
      if (includeUnits && minorUnit.isNotEmpty) {
        buffer.write(' and $fractionWords $minorUnit');
      } else {
        buffer.write(' Point $fractionWords');
      }
    }

    return buffer.toString().trim();
  }

  /// Converts whole number into Indian Lakhs and Crores system.
  static String _convertIndian(int n) {
    if (n == 0) return '';

    final parts = <String>[];

    // Crores (1,00,00,000)
    final crores = n ~/ 10000000;
    n %= 10000000;
    if (crores > 0) {
      parts.add('${_convertIndian(crores)} Crore');
    }

    // Lakhs (1,00,000)
    final lakhs = n ~/ 100000;
    n %= 100000;
    if (lakhs > 0) {
      parts.add('${_convertTwoDigits(lakhs)} Lakh');
    }

    // Thousands (1,000)
    final thousands = n ~/ 1000;
    n %= 1000;
    if (thousands > 0) {
      parts.add('${_convertTwoDigits(thousands)} Thousand');
    }

    // Hundreds (100)
    final hundreds = n ~/ 100;
    n %= 100;
    if (hundreds > 0) {
      parts.add('${_ones[hundreds]} Hundred');
    }

    // Remaining two digits (0-99)
    if (n > 0) {
      parts.add(_convertTwoDigits(n));
    }

    return parts.join(' ').trim();
  }

  /// Converts whole number into Western Millions/Billions system.
  static String _convertWestern(int n) {
    if (n == 0) return '';

    final parts = <String>[];

    final billions = n ~/ 1000000000;
    n %= 1000000000;
    if (billions > 0) {
      parts.add('${_convertWestern(billions)} Billion');
    }

    final millions = n ~/ 1000000;
    n %= 1000000;
    if (millions > 0) {
      parts.add('${_convertWestern(millions)} Million');
    }

    final thousands = n ~/ 1000;
    n %= 1000;
    if (thousands > 0) {
      parts.add('${_convertThreeDigits(thousands)} Thousand');
    }

    if (n > 0) {
      parts.add(_convertThreeDigits(n));
    }

    return parts.join(' ').trim();
  }

  static String _convertThreeDigits(int n) {
    final parts = <String>[];
    final hundreds = n ~/ 100;
    final remainder = n % 100;

    if (hundreds > 0) {
      parts.add('${_ones[hundreds]} Hundred');
    }
    if (remainder > 0) {
      parts.add(_convertTwoDigits(remainder));
    }
    return parts.join(' ');
  }

  static String _convertTwoDigits(int n) {
    if (n < 20) {
      return _ones[n];
    }
    final ten = n ~/ 10;
    final one = n % 10;
    if (one > 0) {
      return '${_tens[ten]}-${_ones[one]}';
    }
    return _tens[ten];
  }
}

/// Convenience extension on [num] to format directly into currency words.
extension CurrencyWordsExtension on num {
  /// Converts the number to currency words (e.g. `250000.toWords()` -> `"Two Lakh Fifty Thousand Rupees"`).
  String toCurrencyWords({
    NumberingSystem system = NumberingSystem.indianLakhCrore,
    String majorUnit = 'Rupees',
    String minorUnit = 'Paise',
    bool includeUnits = true,
  }) {
    return CurrencyWords.convert(
      this,
      system: system,
      majorUnit: majorUnit,
      minorUnit: minorUnit,
      includeUnits: includeUnits,
    );
  }
}
