import 'package:flutter/foundation.dart';
import 'package:log/log.dart';

class ConsoleLogListener implements LogMessageListener {
  @override
  void onLogReport(List<Map<String, String>> logMessages) {
    for (final log in logMessages) {
      int mSec =
          int.tryParse(log['timestamp'] ?? "") ??
          DateTime.now().millisecondsSinceEpoch;
      String p = log['priority'] ?? "";
      String text = log['text'] ?? "";
      debugPrint(
        '[${DateTime.fromMillisecondsSinceEpoch(mSec).toIso8601String()}][$p]$text',
      );
    }
  }
}
