class Question {
  late int question_id;
  late int type; //1-> for single option select 2-> for multi select 3->type answers
  late int cat; //1-> show answer after completing the test 2-> Never show answers
  late String Questions="";
  late Set<String> options={};
  late Set<String> answer={}; //selected options
  //late List<int>selectedoptions;

  int get questionId => question_id;
  set setquestionId(q) => question_id = q;
  set setType(t) => type = t;
  set setQuestion(q) => Questions = q;
  set setCat(c) => cat = c;
  set setOptions(opt) => options.add(opt);
  set delOptions(opt) => options.remove(opt);
  set setAnswer(opt) => answer.add(opt);
  set delAnswer(opt) => answer.remove(opt);
}
