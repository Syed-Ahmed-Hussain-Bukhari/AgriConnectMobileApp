import 'package:agriconnect/Views/StartScreen/OnboardScreen3.dart';
import 'package:flutter/material.dart';

class OnboardScreen2 extends StatelessWidget {
  const OnboardScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding Screen 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OnboardScreen3()),
            );
          },
          child: const Text('Go to Onboarding Screen 3'),
        ),
      ),
    );
  }
}
