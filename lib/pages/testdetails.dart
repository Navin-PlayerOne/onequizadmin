import 'dart:math';

import 'package:flutter/material.dart';
import 'package:onequizadmin/models/test.dart';

class TestDetails extends StatelessWidget {
  TestDetails({super.key});
  final Test test = Test();
  final TextEditingController _testName = TextEditingController();
  final TextEditingController _contactMail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text("Test Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: _testName,
                decoration: InputDecoration(
                    label: const Text("Test Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              TextField(
                controller: _contactMail,
                decoration: InputDecoration(
                    label: const Text("contact Mail"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              )
            ],
          ),
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
                      Navigator.pushReplacementNamed(context, '/home');
                    }),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Text("Cancell"),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: MaterialButton(
                    onPressed: () {
                      if (isValid(_contactMail, _testName)) {
                        test.testName = _testName.text;
                        test.contactMail = _contactMail.text;
                        test.isOpen = true;
                        test.testCode = getRandomString(5);
                        test.questionsCollectionId = getRandomString(7);
                        test.testid = getRandomString(7);
                        test.scoreBoardCollectionId = getRandomString(8);
                        Navigator.pushReplacementNamed(context, '/question',
                            arguments: {'test': test});
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please fill all the fields'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Text("Continue"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

bool isValid(TextEditingController t1, TextEditingController t2) {
  if (t1.text.isNotEmpty && t2.text.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
