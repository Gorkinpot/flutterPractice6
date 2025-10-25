class HistoryItem {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double result;
  final DateTime date;

  HistoryItem({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.result,
    required this.date,
  });
}
