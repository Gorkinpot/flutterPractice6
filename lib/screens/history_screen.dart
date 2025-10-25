import 'package:flutter/material.dart';
import 'package:work/models/history_item.dart';

class HistoryScreen extends StatelessWidget {
  final List<HistoryItem> history;
  final Function(int) onDelete;

  const HistoryScreen({super.key, required this.history, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("История конвертаций")),
      body: history.isEmpty
          ? const Center(child: Text("История пуста"))
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                  "${item.amount} ${item.fromCurrency} → ${item.result.toStringAsFixed(2)} ${item.toCurrency}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  onDelete(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
