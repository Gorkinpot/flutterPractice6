import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'package:work/models/history_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  static const String flagUsd = 'https://flagcdn.com/w20/us.png';
  static const String flagEur = 'https://flagcdn.com/w20/eu.png';
  static const String flagRub = 'https://flagcdn.com/w20/ru.png';
  static const String flagKzt = 'https://flagcdn.com/w20/kz.png';
  static const String decorConvert =
      'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&w=64&q=60';

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

  Widget flagForCurrency(String cur) {
    String url;
    switch (cur) {
      case 'USD':
        url = flagUsd;
        break;
      case 'EUR':
        url = flagEur;
        break;
      case 'RUB':
        url = flagRub;
        break;
      case 'KZT':
        url = flagKzt;
        break;
      default:
        url = flagUsd;
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: 32,
      height: 32,
      fit: BoxFit.cover,
      placeholder: (context, url) => const SizedBox(
          width: 32,
          height: 32,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
      errorWidget: (context, url, error) =>
      const Icon(Icons.image, size: 32),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CachedNetworkImage(
              imageUrl: decorConvert,
              width: 32,
              height: 32,
              placeholder: (context, url) => const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) =>
              const Icon(Icons.currency_exchange),
            ),
            const SizedBox(width: 8),
            const Text("Конвертер валют"),
          ],
        ),
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
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fromCurrency,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Из валюты",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: flagForCurrency(fromCurrency),
                      ),
                    ),
                    items: currencyRates.keys
                        .map((e) => DropdownMenuItem(
                        value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => fromCurrency = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: toCurrency,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "В валюту",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: flagForCurrency(toCurrency),
                      ),
                    ),
                    items: currencyRates.keys
                        .map((e) => DropdownMenuItem(
                        value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => toCurrency = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: convertCurrency,
              icon: CachedNetworkImage(
                imageUrl: decorConvert,
                width: 24,
                height: 24,
                placeholder: (context, url) =>
                const CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) =>
                const Icon(Icons.sync),
              ),
              label: const Text("Конвертировать"),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 16),
            Text(
              result,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
