import 'package:agriconnect/constants/colors.dart';
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const MyCard({
    Key? key,
    required this.icon,
    required this.text,
    this.color = MyColors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(text),
      ),
    );
  }
}