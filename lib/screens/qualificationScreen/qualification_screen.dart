import 'package:flutter/material.dart';

class QualificationScreen extends StatefulWidget {
  const QualificationScreen({super.key});

  @override
  State<QualificationScreen> createState() => _QualificationScreenState();
}

class _QualificationScreenState extends State<QualificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calificaciones"),
      ),
    );
  }
}
