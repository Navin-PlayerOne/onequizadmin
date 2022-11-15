import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:onequizadmin/models/scoreboard.dart';
import 'package:onequizadmin/models/test.dart';
import 'package:onequizadmin/pages/testdetails.dart';
import 'package:onequizadmin/services/database.dart';
import 'package:provider/provider.dart';

class EachTestControllPannel extends StatefulWidget {
  const EachTestControllPannel({super.key});

  @override
  State<EachTestControllPannel> createState() => _EachTestControllPannelState();
}

Map<dynamic, dynamic> hashes = {};
late Test test;

//feilds
bool isClosed = test.isOpen == 1 ? true : false;

class _EachTestControllPannelState extends State<EachTestControllPannel> {
  @override
  Widget build(BuildContext context) {
    hashes = ModalRoute.of(context)!.settings.arguments as Map;
    test = hashes['test'];
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: Text(test.testName),
            bottom: const TabBar(tabs: [
              Tab(
                child: Image(
                  image: AssetImage('assets/settings.png'),
                  height: 40,
                  width: 40,
                ),
              ),
              Tab(
                child: Image(
                  image: AssetImage('assets/scores.png'),
                  height: 40,
                  width: 40,
                ),
              ),
            ]),
          ),
          body: const TabBarView(children: [Settings(), ScoreBoard()]),
        ));
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String random = test.testCode;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              isClosed ? "Test is live" : "Test is closed",
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(isClosed
                ? "click the button to turn off"
                : "click the button to turn on"),
            const SizedBox(
              height: 30,
            ),
            FlutterSwitch(
                activeColor: Colors.green,
                height: 50,
                width: 100,
                value: isClosed,
                onToggle: (val) async {
                  await DatabaseService(
                          uid: FirebaseAuth.instance.currentUser!.uid)
                      .toggleTest(val, test.testid);
                  setState(() {
                    isClosed = val;
                  });
                }),
            const SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    "Test Code : ${random}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: random));
                    },
                    icon: const Icon(Icons.copy)),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton.icon(
                onPressed: () async {
                  random = getRandomString(5);
                  await DatabaseService(
                          uid: FirebaseAuth.instance.currentUser!.uid)
                      .refreshTestToken(test.testCode, random, test.testid);
                  setState(() {});
                },
                icon: const Icon(Icons.refresh),
                label: const Text("reset testcode")),
          ],
        ),
      ),
    );
  }
}

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("created");
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ScoreBoardModal>>.value(
      value: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .getScoreBoardRealtime(test.scoreBoardCollectionId),
      initialData: [],
      child: const OK(),
    );
  }
}

class OK extends StatefulWidget {
  const OK({super.key});

  @override
  State<OK> createState() => _OKState();
}

class _OKState extends State<OK> {
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<List<ScoreBoardModal>>(context);

    // list.forEach((element) {
    //   print(element.mailId);
    //   print(element.name);
    //   print(element.photoUrl);
    //   print(element.score);
    //   print(element.userId);
    // });
    list.sort((b, a) => a.score.compareTo(b.score));
    return list.isEmpty
        ? const Center(
            child: Text("no one's here"),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0),
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0)),
                ),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  onLongPress: () async {
                    CoolAlert.show(
                        onConfirmBtnTap: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          await DatabaseService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .resetUserTest(test.scoreBoardCollectionId,
                                  list.elementAt(index).userId);
                        },
                        title: "Are you Sure want to reset ?",
                        text: "${list.elementAt(index).name}'s test",
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        confirmBtnText: "yes",
                        context: context,
                        type: CoolAlertType.confirm);
                  },
                  title: Text(
                    list.elementAt(index).name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    "Scores : ${list.elementAt(index).score.round()}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  leading: CachedNetworkImage(
                    imageUrl: list.elementAt(index).photoUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  trailing: Text(
                    "${index + 1}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },
          );
  }
}
