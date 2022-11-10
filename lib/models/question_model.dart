import 'package:flutter/cupertino.dart';

class Question {
  late int question_id;
  // late int
  //     type; //1-> for single option select 2-> for multi select 3->type answers
  //late int
  //cat; //1-> show answer after completing the test 2-> Never show answers
  late TextEditingController Questions = TextEditingController();
  late List<TextEditingController> options = [];
  late List<bool> answers = []; //selected options
  //late List<int>selectedoptions;

  // Question();

  // Question.fromJson(Map<String, dynamic> json) {
  //   question_id = json[QuestionFeild.question_id];
  //   type = json[QuestionFeild.type];
  //   Questions = json[QuestionFeild.Questions];
  //   int optionsLength = json[QuestionFeild.options].length;
  //   for (int i = 0; i < optionsLength; i++) {
  //     options.add(TextEditingController(text: json[QuestionFeild.options][i]));
  //   }
  //   int answerLength = json[QuestionFeild.options].length;
  //   for (int i = 0; i < answerLength; i++) {
  //     answers.add(json[QuestionFeild.answers][i]);
  //   }
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data[QuestionFeild.question_id] = question_id;
  //   data[QuestionFeild.type] = type;
  //   data[QuestionFeild.Questions] = Questions;
    
  // }
}

class QuestionFeild {
  static const String question_id = "question_id";
  static const String type = "type";
  static const String Questions = "Questions";
  static const String options = "options";
  static const String answers = "answers";
}
