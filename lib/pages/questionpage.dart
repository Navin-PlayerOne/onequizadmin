import 'package:flutter/material.dart';
import 'package:onequizadmin/models/question_model.dart';
import 'package:onequizadmin/templates/questionpage.dart';

class QuestionPageBuilder extends StatefulWidget {
  QuestionPageBuilder({super.key});

  @override
  State<QuestionPageBuilder> createState() => _QuestionPageBuilderState();
}

PageController _controller = PageController();
List<Question> questions = [Question()];
int currentIndex = 0;

class _QuestionPageBuilderState extends State<QuestionPageBuilder> {
  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    print("------------------------------------");
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {},
                child: const Text("Post Test"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (questions.length > 1) {
                        print("oiu");
                        print(currentIndex);
                        print(questions.length);
                        questions.removeAt(currentIndex);
                      }
                    });
                  },
                  icon: const Icon(Icons.delete)),
            )
          ],
          title: const Text("Question"),
        ),
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: questions.length,
          controller: _controller,
          itemBuilder: (context, index) {
            currentIndex = index;
            return QuestionPage(currentQuestion: questions[index]);
          },
        ),
        floatingActionButton: Visibility(
          visible: !keyboardIsOpen,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  child: MaterialButton(
                    onPressed: (() {
                      if (isValid(currentIndex)) {
                        previousPage();
                      }
                    }),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Text("Save & Previous"),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: MaterialButton(
                    onPressed: () {
                      print(isValid(currentIndex));
                      print(questions.length);
                      if (isValid(currentIndex)) {
                        setState(() {
                          questions.add(Question());
                        });
                        nextPage();
                      }
                    },
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Text("Save & Next"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void nextPage() {
    _controller.animateToPage(_controller.page!.toInt() + 1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void previousPage() {
    _controller.animateToPage(_controller.page!.toInt() - 1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}

bool isValid(int index) {
  print("index ${index}");
  print(questions[index].Questions.text.length);
  if (questions[index].Questions.text.isNotEmpty &&
      questions[index].options.isNotEmpty &&
      questions[index].answers.contains(true)) {
    for (var element in questions[index].options) {
      if (element.text.isEmpty) return false;
    }
    return true;
  } else {
    return false;
  }
}
