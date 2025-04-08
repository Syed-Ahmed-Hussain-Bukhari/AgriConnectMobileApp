import 'package:agriconnect/constants/colors.dart';
import 'package:flutter/material.dart';

class MyElevatedBtn extends StatelessWidget {
  final String text;
  final VoidCallback operation;
  final bool colorInvert;

  const MyElevatedBtn(this.text, this.operation, {this.colorInvert=false,super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: operation,
      style: ElevatedButton.styleFrom(
        backgroundColor: !colorInvert ? MyColors.primaryColor : MyColors.secondaryColor, // Primary color
        foregroundColor: !colorInvert ? MyColors.secondaryColor : MyColors.primaryColor, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        elevation: 5, // Shadow effect
      ),
      child: Text(text),
    );
  }
}
