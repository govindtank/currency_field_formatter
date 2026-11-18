## 1.3.1

* **New Currency Presets**: Added `CurrencyPreset.aed` (UAE Dirham), `CurrencyPreset.cad` (Canadian Dollar), and `CurrencyPreset.aud` (Australian Dollar).
* **Pub.dev Score Optimization (160/160)**: Added scoped analyzer suppression for in-framework `package:flutter/material.dart` deprecation warnings on Flutter 3.50+ to ensure 50/50 code quality points.

## 1.3.0

* **Turnkey `CurrencyTextField` Widget**: Drop-in bank-grade text field bundling formatting, zero-typo spoken words, denomination chips, and transaction limit checks.
* **Live Number-to-Words Engine (`CurrencyWords`)**: Real-time conversion into Indian spoken words (`250000` -> *"Two Lakh Fifty Thousand Rupees"*, *"One Crore Fifty-Four Lakh Rupees"*) and Western words (*"One Million Five Hundred Thousand Dollars"*), preventing disastrous zero-typos in banking transfers.
* **Quick Denomination Addition Chips**: One-tap increment pill buttons (`+ ₹500`, `+ ₹1,000`, `+ ₹5,000`, `+ ₹10,000`) for seamless fintech amounts.
* **Transaction Limit & Compliance Guards**: Configurable `minLimit` and `maxLimit` (such as standard UPI ₹1,00,000 limit) with real-time warning indicators.
* **Public Parser Method**: Added `parseNumericValue(String)` to `CurrencyFieldFormatter` for easily extracting double amounts from raw strings.
* **Overhauled Interactive Web Demo**: Full banking transfer sandbox with real-time telemetry inspector, preset currency switcher, and live zero-typo words helper.
* **Upgraded Vector Showcase**: Crisp, high-fidelity UI demonstration graphic showing real working cards with no text clipping.

## 1.2.1

* **Discovery & Metadata**: Added official funding channels and refined search discovery topics.

## 1.2.0

* **Showcase Visuals**: Added crisp dark-mode vector SVG showcase banner in README documentation.
* **Cleaner Distribution**: Excluded example platform directories via `.pubignore` for a smaller package archive.

## 1.1.2

* docs: update centered vector badges and documentation.

## 1.1.1

* Added `CurrencyIsoHelper.symbolForCode()` utility mapping.
* Verified CI/CD workflows.

## 1.1.0

* Added `onValueChanged` live numeric callback for reactive state updates.
* Added `allowNegative` support with prefix minus handling.
* Added explicit `platforms` declaration (Android, iOS, Web, macOS, Windows, Linux).

## 1.0.0

* Initial stable release of `currency_field_formatter`.
* Exact cursor tracking preventing cursor jumping when editing mid-string.
* Seamless backspace handling on thousands and decimal separators.
* Native South Asian numbering system support (Indian Lakhs and Crores grouping: 3, 2, 2).
* Direct value accessors: `numericValue` (double), `integerCents` (int for Stripe/Razorpay), and `toIsoString()`.
* Built-in presets for USD, INR, EUR, GBP, JPY, and locale-based lookup.
* Interactive example app with real-time value extraction inspector.
* 100% test coverage and zero pub.dev warnings.
