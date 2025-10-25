import 'package:flutter/material.dart';
import 'package:work/screens/history_screen.dart';
import 'package:work/screens/converter_screen.dart';
import 'package:work/models/history_item.dart';

class AppNavigation {
  static const String home = '/';
  static const String history = '/history';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => CurrencyConverterScreen());
      case history:
        final historyList = settings.arguments as List<HistoryItem>;
        final onDelete = settings.arguments is Map ? (settings.arguments as Map)['onDelete'] : null;
        return MaterialPageRoute(
          builder: (_) => HistoryScreen(
            history: historyList,
            onDelete: onDelete,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => CurrencyConverterScreen());
    }
  }
}
