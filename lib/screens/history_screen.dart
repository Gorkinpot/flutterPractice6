import 'package:flutter/material.dart';
import 'package:work/models/history_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HistoryScreen extends StatelessWidget {
  final List<HistoryItem> history;
  final Function(int) onDelete;

  const HistoryScreen({super.key, required this.history, required this.onDelete});

  static const String historyIconUrl =
      'https://images.unsplash.com/photo-1526378720426-2b5d22f1db9b?auto=format&fit=crop&w=64&q=60';

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
              leading: CachedNetworkImage(
                imageUrl: historyIconUrl,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const SizedBox(width: 32, height: 32, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                errorWidget: (context, url, error) =>
                const SizedBox(width: 32, height: 32, child: Icon(Icons.history)),
              ),
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
