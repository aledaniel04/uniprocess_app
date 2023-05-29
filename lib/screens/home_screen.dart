import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String name = "Home_Screen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("hola mundo"),
      ),
    );
  }
}
