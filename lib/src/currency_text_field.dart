import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'currency_formatter.dart';
import 'currency_options.dart';
import 'currency_words.dart';

/// A production-ready, bank-grade currency input widget bundling formatted text input,
/// live number-to-words helper (to prevent zero-typos), quick addition denomination chips,
/// and transaction limit guards.
class CurrencyTextField extends StatefulWidget {
  const CurrencyTextField({
    super.key,
    this.controller,
    this.preset = CurrencyPreset.inr,
    this.initialAmount,
    this.label,
    this.hintText,
    this.showWordsHelper = true,
    this.quickAddAmounts = const [500, 1000, 2000, 5000],
    this.showQuickChips = true,
    this.minLimit,
    this.maxLimit,
    this.limitWarningMessage,
    this.onAmountChanged,
    this.textStyle,
    this.wordsStyle,
    this.chipDecoration,
    this.chipTextStyle,
    this.autofocus = false,
    this.readOnly = false,
  });

  /// Optional external controller. If null, an internal controller is managed.
  final TextEditingController? controller;

  /// Currency formatting preset (defaults to [CurrencyPreset.inr]).
  final CurrencyPreset preset;

  /// Optional initial amount to populate.
  final double? initialAmount;

  /// Optional label above the input field.
  final String? label;

  /// Hint text when field is empty.
  final String? hintText;

  /// Whether to display live spoken words below the amount (e.g. "Two Lakh Rupees").
  final bool showWordsHelper;

  /// Denominations for quick increment pill buttons (e.g. `[500, 1000, 2000, 5000]`).
  final List<num> quickAddAmounts;

  /// Whether to display the quick addition denomination chips.
  final bool showQuickChips;

  /// Minimum allowable amount before displaying a limit notice.
  final double? minLimit;

  /// Maximum allowable transaction limit (e.g. ₹1,00,000 for standard UPI).
  final double? maxLimit;

  /// Custom message when the amount exceeds [maxLimit] or is below [minLimit].
  final String? limitWarningMessage;

  /// Callback returning numeric amount and its words representation.
  final void Function(double amount, String words)? onAmountChanged;

  /// Text style for the large amount display.
  final TextStyle? textStyle;

  /// Text style for the live spoken words.
  final TextStyle? wordsStyle;

  /// Decoration for quick denomination chips.
  final BoxDecoration? chipDecoration;

  /// Text style for denomination chips.
  final TextStyle? chipTextStyle;

  /// Whether to autofocus the field on mount.
  final bool autofocus;

  /// Whether the field is read-only.
  final bool readOnly;

  @override
  State<CurrencyTextField> createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  late TextEditingController _controller;
  late CurrencyFieldFormatter _formatter;
  double _currentAmount = 0.0;
  String _currentWords = '';
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    _initFormatter();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _isInternalController = true;
      _controller = TextEditingController();
    }

    if (widget.initialAmount != null && widget.initialAmount! > 0) {
      _currentAmount = widget.initialAmount!;
      _controller.text = _formatRawNumber(_currentAmount);
      _updateWords(_currentAmount);
    }

    _controller.addListener(_onTextChanged);
  }

  void _initFormatter() {
    _formatter = CurrencyFieldFormatter.fromPreset(
      widget.preset,
      onValueChanged: (val) {
        if (mounted) {
          setState(() {
            _currentAmount = val;
            _updateWords(val);
          });
          widget.onAmountChanged?.call(val, _currentWords);
        }
      },
    );
  }

  @override
  void didUpdateWidget(CurrencyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preset != widget.preset) {
      _initFormatter();
      // Re-format current amount with new preset
      if (_currentAmount > 0) {
        _controller.text = _formatRawNumber(_currentAmount);
        _updateWords(_currentAmount);
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final raw = _controller.text;
    final parsed = _formatter.parseNumericValue(raw);
    if (parsed != _currentAmount) {
      setState(() {
        _currentAmount = parsed;
        _updateWords(parsed);
      });
      widget.onAmountChanged?.call(parsed, _currentWords);
    }
  }

  String _formatRawNumber(double val) {
    final simulated = TextEditingValue(
      text: val.toStringAsFixed(widget.preset.decimalDigits == 0 ? 0 : 2),
      selection: const TextSelection.collapsed(offset: 0),
    );
    final formatted =
        _formatter.formatEditUpdate(TextEditingValue.empty, simulated);
    return formatted.text;
  }

  void _updateWords(double val) {
    if (val <= 0) {
      _currentWords = '';
      return;
    }

    String majorUnit = 'Rupees';
    String minorUnit = 'Paise';

    if (widget.preset.symbol == r'$') {
      majorUnit = 'Dollars';
      minorUnit = 'Cents';
    } else if (widget.preset.symbol == '€') {
      majorUnit = 'Euros';
      minorUnit = 'Cents';
    } else if (widget.preset.symbol == '£') {
      majorUnit = 'Pounds';
      minorUnit = 'Pence';
    } else if (widget.preset.symbol == '¥') {
      majorUnit = 'Yen';
      minorUnit = '';
    }

    _currentWords = CurrencyWords.convert(
      val,
      system: widget.preset.numberingSystem,
      majorUnit: majorUnit,
      minorUnit: minorUnit,
    );
  }

  void _addQuickAmount(num delta) {
    HapticFeedback.lightImpact();
    final newAmount = _currentAmount + delta;
    _controller.text = _formatRawNumber(newAmount);
  }

  void _clearAmount() {
    HapticFeedback.lightImpact();
    _controller.clear();
    setState(() {
      _currentAmount = 0.0;
      _currentWords = '';
    });
    widget.onAmountChanged?.call(0.0, '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverLimit =
        widget.maxLimit != null && _currentAmount > widget.maxLimit!;
    final isUnderLimit = widget.minLimit != null &&
        _currentAmount > 0 &&
        _currentAmount < widget.minLimit!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withAlpha(180),
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Input Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isOverLimit
                  ? theme.colorScheme.error
                  : isUnderLimit
                      ? Colors.orange
                      : theme.colorScheme.outline.withAlpha(80),
              width: (isOverLimit || isUnderLimit) ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  inputFormatters: [_formatter],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  readOnly: widget.readOnly,
                  autofocus: widget.autofocus,
                  style: widget.textStyle ??
                      theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintText: widget.hintText ?? '${widget.preset.symbol} 0.00',
                    hintStyle:
                        (widget.textStyle ?? theme.textTheme.headlineMedium)
                            ?.copyWith(
                      color: theme.hintColor.withAlpha(100),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (_currentAmount > 0 && !widget.readOnly) ...[
                IconButton(
                  icon: const Icon(Icons.cancel_rounded, size: 20),
                  splashRadius: 18,
                  color: theme.hintColor,
                  onPressed: _clearAmount,
                  tooltip: 'Clear amount',
                ),
              ],
            ],
          ),
        ),

        // Live Spoken Words / Zero-Typo Prevention Helper
        if (widget.showWordsHelper && _currentWords.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.record_voice_over_outlined,
                size: 16,
                color: Color(0xFF10B981),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _currentWords,
                  style: widget.wordsStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF34D399),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.2,
                      ),
                ),
              ),
            ],
          ),
        ],

        // Limit Warnings
        if (isOverLimit) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  size: 16, color: theme.colorScheme.error),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.limitWarningMessage ??
                      'Exceeds maximum limit of ${widget.preset.symbol} ${_formatRawNumber(widget.maxLimit!)}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ] else if (isUnderLimit) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 16, color: Colors.orange),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Minimum transaction amount is ${widget.preset.symbol} ${_formatRawNumber(widget.minLimit!)}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],

        // Quick Addition Denomination Chips
        if (widget.showQuickChips &&
            widget.quickAddAmounts.isNotEmpty &&
            !widget.readOnly) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.quickAddAmounts.map((amount) {
              return InkWell(
                onTap: () => _addQuickAmount(amount),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: widget.chipDecoration ??
                      BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outline.withAlpha(60),
                        ),
                      ),
                  child: Text(
                    '+ ${widget.preset.symbol}$amount',
                    style: widget.chipTextStyle ??
                        theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                          fontSize: 12,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
