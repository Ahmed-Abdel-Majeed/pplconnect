import 'package:flutter/material.dart';
class PasswordStrengthIndicator extends StatelessWidget {
  final bool condition;
  final String label;

  const PasswordStrengthIndicator(
      {super.key, required this.condition, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row( 
      children: [
        Icon(
          Icons.circle,
          color: condition ? Colors.green : Colors.grey,
          size: 10,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: condition ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}