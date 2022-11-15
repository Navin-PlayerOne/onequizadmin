import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onequizadmin/models/test.dart';
import 'package:onequizadmin/services/authstate.dart';
import 'package:onequizadmin/services/database.dart';

import '../templates/homepagetestview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<Test> _test = [];
int count = 0;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('refreshing feeds...'),
        backgroundColor: Colors.green,
      ));
    });
    getTestMetaData();
  }

  @override
  Widget build(BuildContext context) {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('refreshing feeds...'),
    //     backgroundColor: Colors.green,
    //   ));
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('refreshing feeds...'),
    //     backgroundColor: Colors.green,
    //   ));
    // });
    //print(FirebaseAuth.instance.currentUser.toString());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text("One quiz Admin"),
        actions: [
          PopupMenuButton(
              color: Theme.of(context).colorScheme.background,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              elevation: 10,
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Icon(Icons.refresh), Text("refresh")],
                    ),
                  ),
                  PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.logout_rounded),
                          Text("logout")
                        ],
                      )),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  setState(() {
                    getTestMetaData();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('refreshing feeds...'),
                    backgroundColor: Colors.green,
                  ));
                } else if (value == 1) {
                  AuthService().signOut();
                }
              }),
        ],
      ),
      body: _test.isEmpty
          ? const Center(
              child: Text("Create new Test"),
            )
          : PageWidget(test: _test),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          Navigator.pushReplacementNamed(context, "/test");
        },
      ),
    );
  }

  void getTestMetaData() async {
    print("plz wait");
    try {
      List<Test> currentTestList =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .test_list;
      setState(() {
        if (currentTestList.isNotEmpty) {
          _test = currentTestList;
          print(currentTestList);
        } else {
          print("empty");
        }
      });
    } catch (e) {
      print("no data found");
    }
  }
}
