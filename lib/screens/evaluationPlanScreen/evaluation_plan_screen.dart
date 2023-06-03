import 'package:flutter/material.dart';

class EvaluationPlanScreen extends StatefulWidget {
  const EvaluationPlanScreen({super.key});

  @override
  State<EvaluationPlanScreen> createState() => _EvaluationPlanScreenState();
}

class _EvaluationPlanScreenState extends State<EvaluationPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plan de Evaluacion"),
      ),
    );
  }
}
