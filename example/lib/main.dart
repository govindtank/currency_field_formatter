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
      title:
          'currency_field_formatter — Bank-Grade Amount Input & Zero-Typo Words',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF10B981),
          secondary: Color(0xFF06B6D4),
          surface: Color(0xFF111827),
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

class _CurrencyDemoScreenState extends State<CurrencyDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  CurrencyPreset _selectedPreset = CurrencyPreset.inr;
  double _enteredAmount = 250000.0;
  String _enteredWords = 'Two Lakh Fifty Thousand Rupees';
  bool _enableUpiLimit = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withAlpha(40),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.currency_exchange_rounded,
                color: Color(0xFF10B981),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'currency_field_formatter',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Zero-Typo Currency Words · Quick Chips · Bank Limits',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'v1.3.0',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF10B981),
                ),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF10B981),
          indicatorWeight: 3,
          labelColor: const Color(0xFF10B981),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.send_rounded), text: 'Bank Transfer UI'),
            Tab(
                icon: Icon(Icons.public_rounded),
                text: 'Multi-Currency Comparison'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBankTransferTab(),
          _buildMultiCurrencyTab(),
        ],
      ),
    );
  }

  Widget _buildBankTransferTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1F2937)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ENTER TRANSFER AMOUNT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F2937),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF374151)),
                          ),
                          child: DropdownButton<CurrencyPreset>(
                            value: _selectedPreset,
                            dropdownColor: const Color(0xFF1E293B),
                            underline: const SizedBox(),
                            isDense: true,
                            items: const [
                              DropdownMenuItem(
                                  value: CurrencyPreset.inr,
                                  child: Text('INR (₹) Lakhs/Crores')),
                              DropdownMenuItem(
                                  value: CurrencyPreset.usd,
                                  child: Text('USD (\$) Millions')),
                              DropdownMenuItem(
                                  value: CurrencyPreset.eur,
                                  child: Text('EUR (€) Euro Space')),
                              DropdownMenuItem(
                                  value: CurrencyPreset.gbp,
                                  child: Text('GBP (£) British')),
                              DropdownMenuItem(
                                  value: CurrencyPreset.jpy,
                                  child: Text('JPY (¥) Zero Decimals')),
                            ],
                            onChanged: (p) =>
                                setState(() => _selectedPreset = p!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CurrencyTextField(
                      preset: _selectedPreset,
                      initialAmount: 250000,
                      maxLimit: _enableUpiLimit ? 100000 : null,
                      limitWarningMessage:
                          'Exceeds standard UPI transaction limit of ₹ 1,00,000.00',
                      quickAddAmounts: _selectedPreset == CurrencyPreset.inr
                          ? const [500, 1000, 2000, 5000, 10000]
                          : const [50, 100, 250, 500, 1000],
                      onAmountChanged: (amt, words) {
                        setState(() {
                          _enteredAmount = amt;
                          _enteredWords = words;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1F2937)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security_rounded,
                        color: Color(0xFF10B981), size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Regulatory UPI Limit Guard (₹ 1,00,000)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                          Text(
                            'Shows inline warning when amount exceeds per-transaction limit.',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _enableUpiLimit,
                      activeThumbColor: const Color(0xFF10B981),
                      onChanged: (v) => setState(() => _enableUpiLimit = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF030712),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1F2937)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.terminal_rounded,
                            size: 16, color: Color(0xFF10B981)),
                        SizedBox(width: 8),
                        Text(
                          'PARSED VALUE TELEMETRY',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF1F2937), height: 20),
                    _buildTelemetryRow('Numeric Double (amount)',
                        _enteredAmount.toStringAsFixed(2)),
                    _buildTelemetryRow('Spoken Words (anti-typo)',
                        _enteredWords.isEmpty ? 'Zero' : _enteredWords),
                    _buildTelemetryRow('Active Grouping System',
                        _selectedPreset.numberingSystem.name),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultiCurrencyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CurrencyTextField(
                preset: CurrencyPreset.inr,
                initialAmount: 1550000,
                label: 'Indian Rupees (Lakhs/Crores 3, 2, 2)',
                showQuickChips: false,
              ),
              SizedBox(height: 24),
              CurrencyTextField(
                preset: CurrencyPreset.usd,
                initialAmount: 2450.75,
                label: 'US Dollars (Western Millions)',
                showQuickChips: false,
              ),
              SizedBox(height: 24),
              CurrencyTextField(
                preset: CurrencyPreset.eur,
                initialAmount: 1250.50,
                label: 'Euro (Space Thousands, Comma Decimal)',
                showQuickChips: false,
              ),
              SizedBox(height: 24),
              CurrencyTextField(
                preset: CurrencyPreset.jpy,
                initialAmount: 45000,
                label: 'Japanese Yen (Zero Decimals)',
                showQuickChips: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTelemetryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 190,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF67E8F9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
