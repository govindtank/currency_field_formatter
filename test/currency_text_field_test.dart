import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:currency_field_formatter/currency_field_formatter.dart';

void main() {
  group('CurrencyTextField Widget Tests', () {
    testWidgets('renders CurrencyTextField with initial amount and live words',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              preset: CurrencyPreset.inr,
              initialAmount: 250000,
              label: 'Transfer Amount',
            ),
          ),
        ),
      );

      expect(find.text('Transfer Amount'), findsOneWidget);
      expect(find.text('Two Lakh Fifty Thousand Rupees'), findsOneWidget);
      expect(find.text('+ ₹500'), findsOneWidget);
      expect(find.text('+ ₹1000'), findsOneWidget);
    });

    testWidgets(
        'tapping quick addition chip increments amount and updates words',
        (tester) async {
      double? updatedAmount;
      String? updatedWords;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              preset: CurrencyPreset.inr,
              initialAmount: 1000,
              onAmountChanged: (amount, words) {
                updatedAmount = amount;
                updatedWords = words;
              },
            ),
          ),
        ),
      );

      expect(find.text('One Thousand Rupees'), findsOneWidget);

      // Tap the + ₹500 chip
      await tester.tap(find.text('+ ₹500'));
      await tester.pumpAndSettle();

      expect(find.text('One Thousand Five Hundred Rupees'), findsOneWidget);
      expect(updatedAmount, equals(1500.0));
      expect(updatedWords, equals('One Thousand Five Hundred Rupees'));
    });

    testWidgets('shows warning message when exceeding maxLimit',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              preset: CurrencyPreset.inr,
              initialAmount: 150000,
              maxLimit: 100000,
              limitWarningMessage:
                  'Exceeds standard UPI transaction limit of ₹ 1,00,000.00',
            ),
          ),
        ),
      );

      expect(
        find.text('Exceeds standard UPI transaction limit of ₹ 1,00,000.00'),
        findsOneWidget,
      );
    });
  });
}
