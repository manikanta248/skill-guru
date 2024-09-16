import 'package:flutter/material.dart';
import 'package:pages/page/page1.dart'; // Or any other screen, like SelectRole

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue, // Set global background color
      ),
      home: const SelectRole(), // Or use SelectRole here
    );
  }
}
