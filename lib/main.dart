import 'package:flutter/material.dart';
import 'package:onequizadmin/models/question_model.dart';
import 'package:onequizadmin/templates/question.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Question App',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: QuestionW(
        question: Question(),
      ),
    );
  }
}
