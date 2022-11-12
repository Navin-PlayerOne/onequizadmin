import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onequizadmin/models/question_model.dart';
import 'package:onequizadmin/models/test.dart';
import 'package:onequizadmin/services/database.dart';
import 'package:onequizadmin/templates/questionwidget.dart';

import '../utils/utils.dart';

class QuestionPageBuilder extends StatefulWidget {
  const QuestionPageBuilder({super.key});

  @override
  State<QuestionPageBuilder> createState() => _QuestionPageBuilderState();
}

PageController _controller = PageController();
List<Question> questions = [Question()];
int currentIndex = 0;
Map<String, Test> testMap = {};

class _QuestionPageBuilderState extends State<QuestionPageBuilder> {
  @override
  Widget build(BuildContext context) {
    testMap = ModalRoute.of(context)!.settings.arguments as Map<String, Test>;
    Test test = testMap['test']!;
    print(testMap);
    print(test.testName);
    print(test.questionsCollectionId);
    print(test.testCode);
    print(test.testid);
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
                onPressed: () async {
                  if (isValid(currentIndex)) {
                    await postTest(test, questions);
                    questions.clear();
                    questions.add(Question());
                    //Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please fill all the fields'),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: const Text("Post Test"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (questions.length > 1) {
                        questions.removeAt(currentIndex);
                      } else if (questions.length == 1) {
                        questions.removeAt(currentIndex);
                        questions.add(Question());
                        Navigator.pushReplacementNamed(context, '/');
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
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please fill all the fields'),
                          backgroundColor: Colors.red,
                        ));
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
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please fill all the fields'),
                          backgroundColor: Colors.red,
                        ));
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

  Future postTest(Test test, List<Question> questions) async {
    DatabaseService _service =
        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    _service.postTestDetails(test).onError((error, stackTrace) {
      customDialog(context, false,
          title: 'failed', content: 'Upload interupted try again later');
    });
    int i = 0;
    for (var question in questions) {
      i++;
      customDialog(context, false,
          title: "Uploading ${i}/${questions.length}",
          content: "please dont quit or press back");
      await _service.postQuestion(test, question);
      Navigator.pop(context);
    }
    customDialog(context, true,
        title: 'Success', content: 'Questions successfully uploaded to server');
  }
}

bool isValid(int index) {
  questions.elementAt(index).question_id = index + 1;
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
