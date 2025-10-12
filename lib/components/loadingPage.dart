import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:signtalk/utils/constants.dart';

class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({super.key, this.message = "Loading SignTalk..."});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstant.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/loading.json',
              width: 200,
              height: 200,
              repeat: true,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: FontsConstant.headingMedium.copyWith(
                color: ColorsConstant.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
