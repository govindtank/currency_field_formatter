/// Placement of the currency symbol relative to the amount.
enum SymbolPosition {
  /// Symbol placed before the amount (e.g. `$ 1,234.50`).
  prefix,

  /// Symbol placed after the amount (e.g. `1 234,50 €`).
  suffix,
}

/// Number grouping rule system for thousands, lakhs, and crores.
enum NumberingSystem {
  /// Standard international thousands grouping: 3, 3, 3 (e.g. `1,000,000.00`).
  western,

  /// South Asian numbering system: 3, then 2, 2, 2 (e.g. `10,00,000.00` for 10 Lakhs).
  indianLakhCrore,

  /// European space separator system (e.g. `1 000 000,00`).
  europeanSpace,

  /// Swiss / Liechtenstein apostrophe separator system (e.g. `1'000'000.00`).
  swissApostrophe,
}

/// Pre-configured currency formatting configurations.
class CurrencyPreset {
  /// The currency symbol (e.g. `$` or `₹`).
  final String symbol;

  /// Prefix or suffix placement.
  final SymbolPosition symbolPosition;

  /// Separator between symbol and amount (e.g. `' '` or `''`).
  final String symbolSeparator;

  /// Thousands grouping separator.
  final String thousandSeparator;

  /// Decimal point separator.
  final String decimalSeparator;

  /// Standard decimal precision digits.
  final int decimalDigits;

  /// Grouping system (Western, Indian, European).
  final NumberingSystem numberingSystem;

  /// Creates a [CurrencyPreset].
  const CurrencyPreset({
    required this.symbol,
    this.symbolPosition = SymbolPosition.prefix,
    this.symbolSeparator = '',
    this.thousandSeparator = ',',
    this.decimalSeparator = '.',
    this.decimalDigits = 2,
    this.numberingSystem = NumberingSystem.western,
  });

  /// US Dollar preset (`$1,234.50`).
  static const CurrencyPreset usd = CurrencyPreset(
    symbol: r'$',
    symbolPosition: SymbolPosition.prefix,
    symbolSeparator: '',
    thousandSeparator: ',',
    decimalSeparator: '.',
    decimalDigits: 2,
    numberingSystem: NumberingSystem.western,
  );

  /// Indian Rupee preset (`₹ 1,23,456.75` with Lakh/Crore grouping).
  static const CurrencyPreset inr = CurrencyPreset(
    symbol: '₹',
    symbolPosition: SymbolPosition.prefix,
    symbolSeparator: ' ',
    thousandSeparator: ',',
    decimalSeparator: '.',
    decimalDigits: 2,
    numberingSystem: NumberingSystem.indianLakhCrore,
  );

  /// Euro preset (`1.234,50 €`).
  static const CurrencyPreset eur = CurrencyPreset(
    symbol: '€',
    symbolPosition: SymbolPosition.suffix,
    symbolSeparator: ' ',
    thousandSeparator: '.',
    decimalSeparator: ',',
    decimalDigits: 2,
    numberingSystem: NumberingSystem.western,
  );

  /// British Pound preset (`£1,234.50`).
  static const CurrencyPreset gbp = CurrencyPreset(
    symbol: '£',
    symbolPosition: SymbolPosition.prefix,
    symbolSeparator: '',
    thousandSeparator: ',',
    decimalSeparator: '.',
    decimalDigits: 2,
    numberingSystem: NumberingSystem.western,
  );

  /// Japanese Yen preset (`¥1,234` zero decimals).
  static const CurrencyPreset jpy = CurrencyPreset(
    symbol: '¥',
    symbolPosition: SymbolPosition.prefix,
    symbolSeparator: '',
    thousandSeparator: ',',
    decimalSeparator: '.',
    decimalDigits: 0,
    numberingSystem: NumberingSystem.western,
  );

  /// Resolves preset by common ISO 4217 code or locale.
  static CurrencyPreset fromLocaleOrCode(String code) {
    final normalized = code.trim().toUpperCase();
    if (normalized.contains('INR') || normalized.contains('IN')) return inr;
    if (normalized.contains('EUR') ||
        normalized.contains('DE') ||
        normalized.contains('FR')) return eur;
    if (normalized.contains('GBP') ||
        normalized.contains('GB') ||
        normalized.contains('UK')) return gbp;
    if (normalized.contains('JPY') || normalized.contains('JP')) return jpy;
    return usd;
  }
}
