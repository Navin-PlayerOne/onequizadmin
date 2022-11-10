import 'package:flutter/material.dart';
import 'package:onequizadmin/models/test.dart';
import 'package:onequizadmin/services/authstate.dart';

import '../templates/homepagetestview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<Test> _test = [Test(), Test()];

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    getTestMetaData();
  }

  @override
  Widget build(BuildContext context) {
    _test.first.contactMail = "playerone@gmail.com";
    _test.first.isOpen = true;
    _test.first.testCode = "1234";
    _test.first.testName = "Natural by Belivers";
    _test.first.name = "PlayerOne";
    _test.first.completedCount = 7;
    _test.last.contactMail = "playerone@gmail.com";
    _test.last.isOpen = false;
    _test.last.testCode = "1234";
    _test.last.testName = "Unstopable";
    _test.last.name = "Parzival";
    _test.last.completedCount = 69;
    //print(FirebaseAuth.instance.currentUser.toString());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
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
                  print("My account menu is selected.");
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
  
  void getTestMetaData() async{
    
  }
}
