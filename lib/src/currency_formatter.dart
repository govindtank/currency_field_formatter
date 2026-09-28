import 'package:flutter/services.dart';
import 'currency_options.dart';

/// A robust [TextInputFormatter] for currency input fields with exact cursor tracking,
/// backspace handling on separators, Indian numbering (Lakhs/Crores), and value accessors.
class CurrencyFieldFormatter extends TextInputFormatter {
  /// The currency symbol (e.g. `$`, `₹`, `€`).
  final String symbol;

  /// Whether the symbol is placed before or after the number.
  final SymbolPosition symbolPosition;

  /// Whitespace or character between the symbol and amount.
  final String symbolSeparator;

  /// Separator for thousands/lakhs (e.g. `,` or `.`).
  final String thousandSeparator;

  /// Separator for decimal fractions (e.g. `.` or `,`).
  final String decimalSeparator;

  /// Whether decimal fractions are permitted.
  final bool allowDecimals;

  /// Maximum number of decimal fractional digits allowed.
  final int decimalDigits;

  /// Maximum number of integer digits allowed.
  final int maxIntegerDigits;

  /// Numbering grouping system (Western vs Indian Lakhs/Crores).
  final NumberingSystem numberingSystem;

  // Cached parsed values from last format
  double _lastNumericValue = 0.0;
  String _lastIsoString = '0.0';

  /// Creates a [CurrencyFieldFormatter].
  CurrencyFieldFormatter({
    this.symbol = r'$',
    this.symbolPosition = SymbolPosition.prefix,
    this.symbolSeparator = '',
    this.thousandSeparator = ',',
    this.decimalSeparator = '.',
    this.allowDecimals = true,
    this.decimalDigits = 2,
    this.maxIntegerDigits = 14,
    this.numberingSystem = NumberingSystem.western,
  });

  /// Preset for US Dollars (`$1,234.50`).
  factory CurrencyFieldFormatter.usd({bool allowDecimals = true}) =>
      CurrencyFieldFormatter.fromPreset(CurrencyPreset.usd,
          allowDecimals: allowDecimals);

  /// Preset for Indian Rupees with Lakh/Crore grouping (`₹ 1,23,456.75`).
  factory CurrencyFieldFormatter.inr({bool allowDecimals = true}) =>
      CurrencyFieldFormatter.fromPreset(CurrencyPreset.inr,
          allowDecimals: allowDecimals);

  /// Preset for Euros (`1.234,50 €`).
  factory CurrencyFieldFormatter.eur({bool allowDecimals = true}) =>
      CurrencyFieldFormatter.fromPreset(CurrencyPreset.eur,
          allowDecimals: allowDecimals);

  /// Preset for British Pounds (`£1,234.50`).
  factory CurrencyFieldFormatter.gbp({bool allowDecimals = true}) =>
      CurrencyFieldFormatter.fromPreset(CurrencyPreset.gbp,
          allowDecimals: allowDecimals);

  /// Preset for Japanese Yen (`¥1,234` zero decimals).
  factory CurrencyFieldFormatter.jpy() =>
      CurrencyFieldFormatter.fromPreset(CurrencyPreset.jpy,
          allowDecimals: false);

  /// Creates formatter from a [CurrencyPreset].
  factory CurrencyFieldFormatter.fromPreset(
    CurrencyPreset preset, {
    bool? allowDecimals,
    int? maxIntegerDigits,
  }) {
    return CurrencyFieldFormatter(
      symbol: preset.symbol,
      symbolPosition: preset.symbolPosition,
      symbolSeparator: preset.symbolSeparator,
      thousandSeparator: preset.thousandSeparator,
      decimalSeparator: preset.decimalSeparator,
      allowDecimals: allowDecimals ?? (preset.decimalDigits > 0),
      decimalDigits: preset.decimalDigits,
      maxIntegerDigits: maxIntegerDigits ?? 14,
      numberingSystem: preset.numberingSystem,
    );
  }

  /// Creates formatter from locale or currency code string.
  factory CurrencyFieldFormatter.byLocale(
    String localeOrCode, {
    bool? allowDecimals,
  }) {
    final preset = CurrencyPreset.fromLocaleOrCode(localeOrCode);
    return CurrencyFieldFormatter.fromPreset(preset,
        allowDecimals: allowDecimals);
  }

  /// The parsed numeric value (e.g. `1234.50`).
  double get numericValue => _lastNumericValue;

  /// The amount in integer minor units / cents (e.g. `$12.34` -> `1234`), useful for Stripe/Razorpay.
  int get integerCents {
    final double multiplier = _powerOfTen(decimalDigits);
    return (_lastNumericValue * multiplier).round();
  }

  /// ISO standard decimal string (e.g. `"1234.50"`).
  String toIsoString() => _lastIsoString;

  static double _powerOfTen(int exp) {
    double res = 1.0;
    for (int i = 0; i < exp; i++) {
      res *= 10.0;
    }
    return res;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      _lastNumericValue = 0.0;
      _lastIsoString = '0.0';
      return newValue;
    }

    // 1. Detect if backspace was pressed immediately on a thousand separator
    String textToProcess = newValue.text;
    int cursorSelectionIndex = newValue.selection.baseOffset;

    if (oldValue.text.length > newValue.text.length) {
      // Deletion occurred
      final int oldOffset = oldValue.selection.baseOffset;
      if (oldOffset > 0 && oldOffset <= oldValue.text.length) {
        final String deletedChar = oldValue.text[oldOffset - 1];
        if (deletedChar == thousandSeparator ||
            deletedChar == symbolSeparator ||
            deletedChar == symbol) {
          // A separator was deleted; also remove the digit before it
          final int deletePos = oldOffset - 2;
          if (deletePos >= 0) {
            final buffer = StringBuffer();
            buffer.write(oldValue.text.substring(0, deletePos));
            buffer.write(oldValue.text.substring(oldOffset));
            textToProcess = buffer.toString();
            cursorSelectionIndex = deletePos;
          }
        }
      }
    }

    // 2. Count raw numeric digits before the cursor in the unformatted input
    int digitsBeforeCursor = 0;
    for (int i = 0; i < cursorSelectionIndex && i < textToProcess.length; i++) {
      final char = textToProcess[i];
      if (_isDigit(char) || (char == decimalSeparator && allowDecimals)) {
        digitsBeforeCursor++;
      }
    }

    // 3. Extract raw integer and decimal digit strings
    final StringBuffer intBuffer = StringBuffer();
    final StringBuffer decBuffer = StringBuffer();
    bool isParsingDecimals = false;

    for (int i = 0; i < textToProcess.length; i++) {
      final char = textToProcess[i];
      if (char == decimalSeparator && allowDecimals) {
        if (!isParsingDecimals) {
          isParsingDecimals = true;
        }
      } else if (_isDigit(char)) {
        if (!isParsingDecimals) {
          if (intBuffer.length < maxIntegerDigits) {
            intBuffer.write(char);
          }
        } else {
          if (decBuffer.length < decimalDigits) {
            decBuffer.write(char);
          }
        }
      }
    }

    String intStr = intBuffer.toString();
    // Strip leading zeros if more than 1 digit
    while (intStr.length > 1 && intStr.startsWith('0')) {
      intStr = intStr.substring(1);
    }
    if (intStr.isEmpty) {
      intStr = isParsingDecimals ? '0' : '';
    }

    // 4. Format integer part with appropriate grouping
    final String formattedInteger =
        _formatGrouping(intStr, thousandSeparator, numberingSystem);

    // 5. Construct formatted amount string
    final StringBuffer formattedAmount = StringBuffer();
    formattedAmount.write(formattedInteger);

    if (isParsingDecimals && allowDecimals) {
      formattedAmount.write(decimalSeparator);
      formattedAmount.write(decBuffer.toString());
    }

    final String amountText = formattedAmount.toString();
    if (amountText.isEmpty) {
      _lastNumericValue = 0.0;
      _lastIsoString = '0.0';
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // 6. Attach Symbol (Prefix / Suffix)
    final StringBuffer fullText = StringBuffer();
    if (symbolPosition == SymbolPosition.prefix) {
      fullText.write(symbol);
      fullText.write(symbolSeparator);
      fullText.write(amountText);
    } else {
      fullText.write(amountText);
      fullText.write(symbolSeparator);
      fullText.write(symbol);
    }

    final String resultString = fullText.toString();

    // 7. Recompute accurate cursor position based on raw digits count
    int newCursorOffset = 0;
    int digitsSeen = 0;

    for (int i = 0; i < resultString.length; i++) {
      if (digitsSeen >= digitsBeforeCursor) {
        newCursorOffset = i;
        break;
      }
      final char = resultString[i];
      if (_isDigit(char) || (char == decimalSeparator && allowDecimals)) {
        digitsSeen++;
      }
      newCursorOffset = i + 1;
    }

    // Edge check if symbol is prefix
    final int prefixLength = symbolPosition == SymbolPosition.prefix
        ? symbol.length + symbolSeparator.length
        : 0;
    if (newCursorOffset < prefixLength) {
      newCursorOffset = prefixLength;
    }

    // 8. Update cached numeric value
    final String parseableInt = intStr.isEmpty ? '0' : intStr;
    final String parseableDec =
        decBuffer.isNotEmpty ? decBuffer.toString() : '0';
    _lastIsoString = '$parseableInt.$parseableDec';
    _lastNumericValue = double.tryParse(_lastIsoString) ?? 0.0;

    return TextEditingValue(
      text: resultString,
      selection: TextSelection.collapsed(
          offset: newCursorOffset.clamp(0, resultString.length)),
    );
  }

  static bool _isDigit(String s) {
    if (s.isEmpty) {
      return false;
    }
    final code = s.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }

  static String _formatGrouping(
      String digits, String sep, NumberingSystem system) {
    if (digits.isEmpty) {
      return '';
    }
    if (digits.length <= 3) {
      return digits;
    }

    if (system == NumberingSystem.indianLakhCrore) {
      // Indian format: last 3 digits, then groups of 2 (e.g. 10,00,000)
      final String lastThree = digits.substring(digits.length - 3);
      String remaining = digits.substring(0, digits.length - 3);

      final List<String> groups = [];
      while (remaining.length > 2) {
        groups.insert(0, remaining.substring(remaining.length - 2));
        remaining = remaining.substring(0, remaining.length - 2);
      }
      if (remaining.isNotEmpty) {
        groups.insert(0, remaining);
      }
      return '${groups.join(sep)}$sep$lastThree';
    } else {
      // Standard 3-digit grouping
      final buffer = StringBuffer();
      final int remainder = digits.length % 3;

      if (remainder > 0) {
        buffer.write(digits.substring(0, remainder));
        if (digits.length > remainder) {
          buffer.write(sep);
        }
      }

      for (int i = remainder; i < digits.length; i += 3) {
        buffer.write(digits.substring(i, i + 3));
        if (i + 3 < digits.length) {
          buffer.write(sep);
        }
      }

      return buffer.toString();
    }
  }
}
