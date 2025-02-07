import 'package:flutter/material.dart';
import 'package:pplconnect/features/auth/presentation/pages/sign_in_page.dart';
import 'package:pplconnect/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  
      home: HomePage(),
    );
  }
}

