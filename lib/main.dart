import 'package:flutter/material.dart';
import 'package:work/screens/converter_screen.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Конвертер валют',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CurrencyConverterScreen(),
    );
  }
}
