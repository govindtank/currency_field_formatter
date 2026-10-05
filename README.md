# currency_field_formatter

[![Pub Version](https://img.shields.io/pub/v/currency_field_formatter.svg?style=flat-square&color=blue)](https://pub.dev/packages/currency_field_formatter)
[![Pub Points](https://img.shields.io/pub/points/currency_field_formatter?style=flat-square&color=2E8B57&label=pub%20points)](https://pub.dev/packages/currency_field_formatter/score)
[![Pub Likes](https://img.shields.io/pub/likes/currency_field_formatter?style=flat-square)](https://pub.dev/packages/currency_field_formatter)
[![CI](https://github.com/govindtank/currency_field_formatter/actions/workflows/ci.yml/badge.svg)](https://github.com/govindtank/currency_field_formatter/actions)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat-square)](LICENSE)

A bulletproof Flutter `TextInputFormatter` for financial, banking, and e-commerce inputs with **exact mathematical cursor tracking**, clean backspace handling on separators, **Indian Lakhs/Crores grouping**, and zero-rounding payment gateway integer accessors (Stripe / Razorpay).

<p align="center">
  <img src="https://raw.githubusercontent.com/govindtank/currency_field_formatter/main/screenshot.svg" width="750" alt="currency_field_formatter demo"/>
</p>

---

## ⚡ Why currency_field_formatter?

Most currency input formatters in the Flutter ecosystem suffer from frustrating production bugs:
1. **The Cursor-Jumping Bug**: Editing digits in the *middle* of an amount (e.g. `1,2[cursor]34,567`) throws the cursor to the end of the input string. `currency_field_formatter` calculates exact character deltas so mid-text editing stays locked to the user's cursor.
2. **Broken Backspace on Separators**: Hitting backspace directly on a comma or period separator either does nothing or breaks formatting. `currency_field_formatter` automatically detects separator deletion and removes the preceding digit cleanly.
3. **South Asian / Indian Numbering Support**: Western formatters hardcode 3-digit groups (`1,000,000`). `currency_field_formatter` natively supports Indian Lakhs & Crores grouping (`10,00,000.00`).
4. **Direct Minor Units (Cents)**: Get payment gateway amounts (e.g. `$12.34` -> `1234` integer cents) directly from `formatter.integerCents` without floating-point parsing errors.

---

## 📦 Installation

Add `currency_field_formatter` to your `pubspec.yaml`:

```yaml
dependencies:
  currency_field_formatter: ^1.1.1
```

Or run:

```bash
flutter pub add currency_field_formatter
```

---

## 🚀 Quick Start

### 1. US Dollar Input (`$1,234.50`)

```dart
import 'package:flutter/material.dart';
import 'package:currency_field_formatter/currency_field_formatter.dart';

final formatter = CurrencyFieldFormatter.usd();

TextField(
  keyboardType: const TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [formatter],
  onChanged: (text) {
    print('Raw Numeric Value: ${formatter.numericValue}'); // 1234.50 (double)
    print('Stripe Minor Cents: ${formatter.integerCents}');  // 123450 (int)
    print('ISO String: ${formatter.toIsoString()}');       // "1234.50"
  },
);
```

---

### 2. Indian Rupee with Lakhs & Crores (`₹ 15,50,000.00`)

```dart
final inrFormatter = CurrencyFieldFormatter.inr();

TextField(
  keyboardType: const TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [inrFormatter],
);
```

---

### 3. Euro with Suffix Symbol & Comma Decimals (`1.234,50 €`)

```dart
final eurFormatter = CurrencyFieldFormatter.eur();

TextField(
  keyboardType: const TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [eurFormatter],
);
```

---

### 4. Dynamic Formatting by Locale or Currency Code

```dart
final dynamicFormatter = CurrencyFieldFormatter.byLocale('en_IN'); // or 'USD', 'EUR', 'GBP', 'JPY'
```

---

## 🛠️ API Reference

### Formatter Accessors

| Property / Method | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `numericValue` | `double` | The parsed decimal amount. | `1234.50` |
| `integerCents` | `int` | Amount in minor units (zero-float precision for Stripe/Razorpay). | `123450` |
| `toIsoString()` | `String` | Standard ISO unformatted decimal string. | `"1234.50"` |

### Configuration Options

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `symbol` | `String` | `'$'` | Currency symbol (e.g. `$`, `₹`, `€`, `£`, `¥`). |
| `symbolPosition` | `SymbolPosition` | `prefix` | Place symbol before (`prefix`) or after (`suffix`) amount. |
| `symbolSeparator` | `String` | `''` | Spacing between symbol and amount (e.g. `' '`). |
| `thousandSeparator` | `String` | `','` | Grouping separator (e.g. `,` or `.`). |
| `decimalSeparator` | `String` | `'.'` | Decimal point character. |
| `allowDecimals` | `bool` | `true` | Whether fractional decimals are accepted. |
| `decimalDigits` | `int` | `2` | Maximum decimal digits allowed. |
| `maxIntegerDigits` | `int` | `14` | Maximum integer digits allowed. |
| `numberingSystem` | `NumberingSystem`| `western`| `western` (3, 3, 3) or `indianLakhCrore` (3, 2, 2). |

---

## 💖 Support the Project

If you find this project useful, consider supporting its active maintenance and future development:

<p align="left">
  <a href="https://buymeacoffee.com/govindtanko"><img src="https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee" /></a>
  <a href="https://github.com/sponsors/govindtank"><img src="https://img.shields.io/badge/GitHub%20Sponsors-EA4AAA?style=for-the-badge&logo=github&logoColor=white" alt="GitHub Sponsors" /></a>
  <a href="https://www.patreon.com/govindtank"><img src="https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white" alt="Patreon" /></a>
</p>

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

*Maintained with ❤️ by [Govind Tank](https://github.com/govindtank).*
