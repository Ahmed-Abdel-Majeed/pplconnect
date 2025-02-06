import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback onActionPressed;
  final TextStyle? questionStyle;
  final TextStyle? actionStyle;

  const AuthFooter({
    super.key,
    this.questionText = "Don't have an account?  ",
    this.actionText = "Register",
    required this.onActionPressed,
    this.questionStyle,
    this.actionStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: questionText,
            style: questionStyle ?? _defaultQuestionStyle(),
          ),
          TextSpan(
            text: actionText,
            recognizer: TapGestureRecognizer()..onTap = onActionPressed,
            style: actionStyle ?? _defaultActionStyle(),
          ),
        ],
      ),
    );
  }

  TextStyle _defaultQuestionStyle() {
    return const TextStyle(
      fontSize: 15,
      color: Colors.black54,
    );
  }

  TextStyle _defaultActionStyle() {
    return const TextStyle(
      fontSize: 17,
      color: Color(0xFF4A90E2),
      fontWeight: FontWeight.bold,
    );
  }
}