import 'package:flutter/material.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Question"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Question",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                autocorrect: true,
                maxLines: 8,
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.post_add_outlined),
                label: const Text("Options")),
          ],
        ),
      ),
    );
  }
}
