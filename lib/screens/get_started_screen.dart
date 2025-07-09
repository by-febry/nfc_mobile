import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  final VoidCallback onContinue;
  const GetStartedScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add logo above the welcome text
            Image.asset(
              'assets/img/logo.png',
              width: 160,
              height: 160,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to OneTapp',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onContinue,
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
} 