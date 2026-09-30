## 1.1.0

* Added `onValueChanged` live numeric callback for reactive state updates.
* Added `allowNegative` support with prefix minus handling.
* Added explicit `platforms` declaration (Android, iOS, Web, macOS, Windows, Linux).

## 1.0.0 Added `platforms` declaration (android, ios, linux, macos, windows, web).

## 1.0.0

* Initial stable release of `currency_field_formatter`.
* Exact cursor tracking preventing cursor jumping when editing mid-string.
* Seamless backspace handling on thousands and decimal separators.
* Native South Asian numbering system support (Indian Lakhs and Crores grouping: 3, 2, 2).
* Direct value accessors: `numericValue` (double), `integerCents` (int for Stripe/Razorpay), and `toIsoString()`.
* Built-in presets for USD, INR, EUR, GBP, JPY, and locale-based lookup.
* Interactive example app with real-time value extraction inspector.
* 100% test coverage and zero pub.dev warnings.

## 1.1.1

* Added `CurrencyIsoHelper.symbolForCode()` utility mapping.
* Verified CI and automated pub.dev OIDC deployment.
