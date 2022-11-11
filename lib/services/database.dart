import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/question_model.dart';
import '../models/test.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference testCollection =
      FirebaseFirestore.instance.collection('tests');

  final CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('admin');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference scoresCollection =
      FirebaseFirestore.instance.collection('scores');

  final CollectionReference questionsCollection =
      FirebaseFirestore.instance.collection('questions');

  // Stream<DocumentSnapshot<Object?>> get test {
  //   return testCollection.doc('gt').snapshots();
  // }

  Future postQuestion(Test test, Question question) async {
    await questionsCollection
        .doc(test.questionsCollectionId)
        .collection('questions')
        .doc("${question.question_id}")
        .set({
      'question': question.Questions.text,
      'options': question.options.map((e) => e.text).toList(),
      'answers': question.answers,
    });
  }

  Future registerUser() async {
    return await adminCollection.doc(uid).set({
      'testList': [],
      'Name': FirebaseAuth.instance.currentUser!.displayName
    });
  }

  Future postTestDetails(Test test) async {
    bool everythingOk = true;
    //adding testid to admin test list
    await adminCollection
        .doc(uid)
        .set({
          'testList': FieldValue.arrayUnion([test.testid])
        }, SetOptions(merge: true))
        .then((value) => everythingOk = true)
        .onError((error, stackTrace) => everythingOk = false);
    if (!everythingOk) return false;

    //adding scoreboard to collections
    await scoresCollection
        .doc(test.scoreBoardCollectionId)
        .set({'scores': {}})
        .then((value) => everythingOk = true)
        .onError((error, stackTrace) => everythingOk = false);
    if (!everythingOk) return false;

    //adding test meta data
    await testCollection
        .doc(test.testid)
        .set({
          'Name': FirebaseAuth.instance.currentUser!.displayName,
          'testName': test.testName,
          'supportMail': test.contactMail,
          'testCode': test.testCode,
          'isClosed': test.isOpen,
          'questionsCollectionId': test.questionsCollectionId,
          'scoreBoardCollectionId': test.scoreBoardCollectionId
        })
        .then((value) => everythingOk = true)
        .onError((error, stackTrace) => everythingOk = false);

    if (!everythingOk) return false;
    if (everythingOk) return true;
  }

  Future<List<Test>> _test_from_snapshot(DocumentSnapshot snapshot) async {
    Map<dynamic, dynamic> testListbuf = snapshot.data() as Map;
    List<dynamic> testIds = testListbuf['testList'];
    List<Test> testList = [];
    for (int i = 0; i < testIds.length; i++) {
      await testCollection.doc(testIds[i]).get().then((value) {
        Map<dynamic, dynamic> eachTest = value.data() as Map;
        print("------");
        print(eachTest['testName']);
        print("------");
        testList.add(Test(
          completedCount: 0,
          contactMail: eachTest['supportMail'],
          isOpen: eachTest['isClosed'],
          name: eachTest['Name'],
          questionsCollectionId: eachTest['questionsCollectionId'],
          scoreBoardCollectionId: eachTest['scoreBoardCollectionId'],
          testCode: eachTest['testCode'],
          testName: eachTest['testName'],
          testid: value.id,
        ));
      });
    }
    return testList;
  }

  Future<List<Test>> get test_list {
    return adminCollection
        .doc(uid)
        .get()
        .then((value) => _test_from_snapshot(value));
  }
}
