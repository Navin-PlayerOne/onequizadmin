import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onequizadmin/models/test.dart';
import 'package:onequizadmin/services/database.dart';
import 'package:share_plus/share_plus.dart';

class PageWidget extends StatefulWidget {
  List<Test> test;
  PageWidget({super.key, required this.test});

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.test.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5.0,
          margin: const EdgeInsets.all(12),
          color: Theme.of(context).colorScheme.background,
          borderOnForeground: true,
          child: ListTile(
            title: Text(widget.test.elementAt(index).testName),
            subtitle: Text("test by ${widget.test.elementAt(index).name}"),
            onTap: () => print("selected ${index + 1}"),
            contentPadding: const EdgeInsets.all(10),
            leading: widget.test.elementAt(index).isOpen == 1
                ? const Icon(Icons.cell_tower, color: Colors.green)
                : const Icon(Icons.wifi_tethering_off, color: Colors.red),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${widget.test.elementAt(index).completedCount} "),
                const Icon(Icons.remove_red_eye_rounded),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    Test tmp = widget.test.elementAt(index);
                    setState(() {
                      widget.test.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('deleting...'),
                      backgroundColor: Colors.red,
                    ));
                    await DatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .deleteTest(tmp);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('deleted'),
                      backgroundColor: Colors.red,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('refreshing feeds...'),
                      backgroundColor: Colors.green,
                    ));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                        "Test code for the test ${widget.test.elementAt(index).testName} is :${widget.test.elementAt(index).testCode}",
                        subject: "Test code");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
