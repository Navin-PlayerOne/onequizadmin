import 'package:flutter/material.dart';
import 'package:onequizadmin/models/question_model.dart';

class QuestionW extends StatefulWidget {
  Question question;
  QuestionW({super.key, required this.question});

  @override
  State<QuestionW> createState() => _QuestionWState();
}

class _QuestionWState extends State<QuestionW> {
  int cnt = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Question"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Question",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  autocorrect: true,
                  maxLines: 8,
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                  onPressed: () {
                    //addoptions();
                    setState(() {
                      cnt++;
                    });
                  },
                  icon: const Icon(Icons.post_add_outlined),
                  label: const Text("Options")),
              SizedBox(
                height: 200,
                width: 400,
                child: Container(
                  child: ListView.builder(
                    //itemCount: widget.question.options.length,
                    itemCount: cnt,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Row(
                            children: <Widget>[
                              //Expanded(child: Text('options')),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  )),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.chevron_right),
                            color: Colors.black26,
                            onPressed: () {},
                          ));
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addoptions() {}
}
