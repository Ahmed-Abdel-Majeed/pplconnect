import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;

  const EmailField({
    super.key,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Your Email",
          hintStyle: TextStyle(color: Colors.grey),
        ),
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }
}