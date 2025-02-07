import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String buttonText;

  const ContinueButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.buttonText = "Log In",
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:Colors.black,
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(
              buttonText,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}