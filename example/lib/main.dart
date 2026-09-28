import 'package:flutter/material.dart';
import 'package:currency_field_formatter/currency_field_formatter.dart';

void main() {
  runApp(const CurrencyFormatterDemoApp());
}

class CurrencyFormatterDemoApp extends StatelessWidget {
  const CurrencyFormatterDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Field Formatter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B1120),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const CurrencyDemoScreen(),
    );
  }
}

class CurrencyDemoScreen extends StatefulWidget {
  const CurrencyDemoScreen({super.key});

  @override
  State<CurrencyDemoScreen> createState() => _CurrencyDemoScreenState();
}

class _CurrencyDemoScreenState extends State<CurrencyDemoScreen> {
  final _usdController = TextEditingController(text: r'$1,250.00');
  final _inrController = TextEditingController(text: '₹ 15,50,000');
  final _eurController = TextEditingController(text: '850,50 €');

  final _usdFormatter = CurrencyFieldFormatter.usd();
  final _inrFormatter = CurrencyFieldFormatter.inr();
  final _eurFormatter = CurrencyFieldFormatter.eur();

  @override
  void dispose() {
    _usdController.dispose();
    _inrController.dispose();
    _eurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency Field Formatter',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF0B1120),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Real-Time Currency Formatters',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Zero cursor jumps · Indian Lakhs/Crores · Minor cents extraction',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 24),

            // USD Card
            _buildCurrencyCard(
              title: 'US Dollar (USD)',
              subtitle: 'Prefix symbol, 3-digit grouping, cents',
              controller: _usdController,
              formatter: _usdFormatter,
              badgeColor: const Color(0xFF38BDF8),
            ),
            const SizedBox(height: 18),

            // INR Card (Indian Numbering)
            _buildCurrencyCard(
              title: 'Indian Rupee (INR)',
              subtitle: 'Indian 3, 2, 2 Lakhs & Crores grouping',
              controller: _inrController,
              formatter: _inrFormatter,
              badgeColor: const Color(0xFF34D399),
            ),
            const SizedBox(height: 18),

            // EUR Card
            _buildCurrencyCard(
              title: 'Euro (EUR)',
              subtitle: 'Suffix symbol, period thousands, comma decimals',
              controller: _eurController,
              formatter: _eurFormatter,
              badgeColor: const Color(0xFFFBBF24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyCard({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required CurrencyFieldFormatter formatter,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  formatter.symbol,
                  style: TextStyle(
                      color: badgeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          const SizedBox(height: 14),

          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [formatter],
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: badgeColor, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),

          // Output metrics
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(
                    'numericValue', formatter.numericValue.toStringAsFixed(2)),
                _buildMetric('integerCents', '${formatter.integerCents}'),
                _buildMetric('toIsoString', formatter.toIsoString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE2E8F0))),
      ],
    );
  }
}
