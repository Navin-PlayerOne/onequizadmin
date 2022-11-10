import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:onequizadmin/models/test.dart';
import 'package:onequizadmin/pages/questionpage.dart';

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
            leading: widget.test.elementAt(index).isOpen
                ? const Icon(Icons.cell_tower, color: Colors.green)
                : const Icon(Icons.wifi_tethering_off, color: Colors.red),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${widget.test.elementAt(index).completedCount} "),
                const Icon(Icons.remove_red_eye_rounded),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
