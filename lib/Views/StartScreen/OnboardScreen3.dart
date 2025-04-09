import 'package:agriconnect/Controllers/LoginController.dart';
import 'package:flutter/material.dart';

class OnboardScreen3 extends StatefulWidget {
  const OnboardScreen3({Key? key}) : super(key: key);

  @override
  _OnboardScreen3State createState() => _OnboardScreen3State();
}

class _OnboardScreen3State extends State<OnboardScreen3> {
  final LoginController _authController = LoginController();

  @override
  void initState() {
    super.initState();
    _authController.checkLoginStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}