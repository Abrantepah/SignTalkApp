import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signtalk/navigation%20pages/demoPage.dart';
import 'package:signtalk/navigation%20pages/healthWorker.dart';
import 'package:signtalk/navigation%20pages/home.dart';
import 'package:signtalk/navigation%20pages/hospitalListing.dart';
import 'package:signtalk/navigation%20pages/Translation.dart';
import 'package:signtalk/providers/sign2text.dart';
import 'package:signtalk/providers/text2sign.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TextToSignProvider()),
        ChangeNotifierProvider(create: (_) => SignToTextProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        '/translation': (context) => const Translation(), // ✅ No cameras passed
        '/healthWorker': (context) => Healthworker(),
        '/hospitalListing': (context) => const HospitalListing(),
        '/demoPage': (context) => const Demopage(),
        '/overview': (context) => const Home(),
        '/technology': (context) => const Placeholder(),
        '/useCases': (context) => const Placeholder(),
      },
    );
  }
}
