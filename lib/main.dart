import 'package:flutter/material.dart';
import 'package:log/log.dart';
import 'listeners/console_log_listener.dart';
import 'views/content_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // LogManager 초기화
  LogManager().setMinimumLogLevel(LogLevel.debug);
  LogManager().addLogMessageListener(ConsoleLogListener());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grayscale Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ContentView(),
    );
  }
}
