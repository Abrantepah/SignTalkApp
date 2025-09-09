import 'package:flutter/material.dart';
import 'package:signtalk/navigation%20pages/healthWorker.dart';
import 'package:signtalk/navigation%20pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignTalk',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/healthWorker': (context) => const Healthworker(),
        '/overview': (context) => const Home(),
        '/technology': (context) => const Placeholder(),
        '/useCases': (context) => const Placeholder(),
      },
    );
  }
}
