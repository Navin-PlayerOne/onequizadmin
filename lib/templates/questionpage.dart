import 'package:flutter/material.dart';

import '../models/question_model.dart';

class QuestionPage extends StatefulWidget {
  final Question currentQuestion;

  const QuestionPage({super.key, required this.currentQuestion});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: TextField(
                controller: widget.currentQuestion.Questions,
                decoration: InputDecoration(
                  labelText: "Question",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                autocorrect: true,
                maxLines: 9,
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
                onPressed: () {
                  //addoptions();
                  setState(() {
                    widget.currentQuestion.options.add(TextEditingController());
                    widget.currentQuestion.answers.add(false);
                  });
                },
                icon: const Icon(Icons.post_add_outlined),
                label: const Text("Options")),
            SizedBox(
              height: 300,
              width: width - 50,
              child: Container(
                child: ListView.builder(
                  //itemCount: widget.question.options.length,
                  itemCount: widget.currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text("${index + 1}"),
                      title: Row(
                        children: <Widget>[
                          Checkbox(
                              value: widget.currentQuestion.answers
                                  .elementAt(index),
                              onChanged: (value) {
                                setState(() {
                                  widget.currentQuestion.answers[index] =
                                      value!;
                                });
                              }),
                          Expanded(
                            child: TextField(
                              controller: widget.currentQuestion.options
                                  .elementAt(index),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.currentQuestion.options.removeAt(index);
                            widget.currentQuestion.answers.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}