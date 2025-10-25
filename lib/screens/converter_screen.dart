import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'package:work/models/history_item.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String fromCurrency = "USD";
  String toCurrency = "EUR";
  String result = "";
  final List<HistoryItem> history = [];

  final Map<String, double> currencyRates = {
    "USD": 1.0,
    "EUR": 0.93,
    "RUB": 91.2,
    "KZT": 486.5,
  };

  void convertCurrency() {
    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        result = "Введите корректную положительную сумму";
      });
      return;
    }

    double fromRate = currencyRates[fromCurrency]!;
    double toRate = currencyRates[toCurrency]!;
    double converted = amount * (toRate / fromRate);

    String conversionResult =
        "$amount $fromCurrency = ${converted.toStringAsFixed(2)} $toCurrency";

    setState(() {
      result = conversionResult;
      history.insert(
        0,
        HistoryItem(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          amount: amount,
          result: converted,
          date: DateTime.now(),
        ),
      );
      if (history.length > 20) history.removeLast();
    });

    _amountController.clear();
  }

  void openHistoryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          history: history,
          onDelete: (index) {
            setState(() {
              history.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Конвертер валют"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: openHistoryScreen,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Введите сумму",
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fromCurrency,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Из валюты",
                    ),
                    items: currencyRates.keys
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => fromCurrency = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: toCurrency,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "В валюту",
                    ),
                    items: currencyRates.keys
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => toCurrency = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: convertCurrency,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              child: const Text("Конвертировать"),
            ),
            const SizedBox(height: 16),
            Text(
              result,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
