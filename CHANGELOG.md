## 1.0.0

* Initial stable release of `currency_field_formatter`.
* Exact cursor tracking preventing cursor jumping when editing mid-string.
* Seamless backspace handling on thousands and decimal separators.
* Native South Asian numbering system support (Indian Lakhs and Crores grouping: 3, 2, 2).
* Direct value accessors: `numericValue` (double), `integerCents` (int for Stripe/Razorpay), and `toIsoString()`.
* Built-in presets for USD, INR, EUR, GBP, JPY, and locale-based lookup.
* Interactive example app with real-time value extraction inspector.
* 100% test coverage and zero pub.dev warnings.
