import 'package:flutter_test/flutter_test.dart';
import 'package:currency_field_formatter_example/main.dart';

void main() {
  testWidgets('Currency formatter example app mounts properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CurrencyFormatterDemoApp());
    await tester.pumpAndSettle();

    expect(find.text('Currency Field Formatter'), findsOneWidget);
    expect(find.text('US Dollar (USD)'), findsOneWidget);
    expect(find.text('Indian Rupee (INR)'), findsOneWidget);
  });
}
