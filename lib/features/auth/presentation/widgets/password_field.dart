import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final Function(String)? onChanged; // جعل onChanged اختيارياً

  const PasswordField({
    super.key,
    required this.passwordController,
    this.onChanged,
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
      child: TextField(
        controller: passwordController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Your Password",
          hintStyle: TextStyle(color: Colors.grey),
        ),
        obscureText: true,
        style: const TextStyle(color: Colors.black87),
        onChanged: onChanged, // تمرير onChanged إلى TextField
      ),
    );
  }
}
