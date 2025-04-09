import 'package:agriconnect/constants/colors.dart';
import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final VoidCallback operation;

  const MyTextButton(this.text, this.operation, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: operation,
      style: TextButton.styleFrom(
        foregroundColor: MyColors.primaryColor, // Text color
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
      child: Text(text),
    );
  }
}