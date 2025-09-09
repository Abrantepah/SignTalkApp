import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Splash Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the Splash Screen!'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/homepage');
              },
              child: const Text('Go to Home Page'),
            ),
          ],
        ),
      ),
    );
  }
}
