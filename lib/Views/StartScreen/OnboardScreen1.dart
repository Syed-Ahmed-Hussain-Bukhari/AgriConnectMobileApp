import 'package:agriconnect/Views/StartScreen/OnboardScreen2.dart';
import 'package:flutter/material.dart';

class OnboardScreen1 extends StatelessWidget {
  const OnboardScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding Screen 1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OnboardScreen2()),
            );
          },
          child: const Text('Go to Onboarding Screen 2'),
        ),
      ),
    );
  }
}
