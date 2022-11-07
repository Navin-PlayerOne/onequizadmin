import 'package:flutter/cupertino.dart';

class Question {
  late int question_id;
  late int
      type; //1-> for single option select 2-> for multi select 3->type answers
  late int
      cat; //1-> show answer after completing the test 2-> Never show answers
  late TextEditingController Questions = TextEditingController();
  late List<TextEditingController> options = [];
  late List<bool> answers = []; //selected options
  //late List<int>selectedoptions;
}
