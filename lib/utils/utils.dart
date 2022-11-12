import 'package:flutter/material.dart';

void customDialog(context, bool val, {required title, required content}) {
  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            actions: [
              val
                  ? TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                        Navigator.of(context).pushNamed('/home');
                      },
                      child: const Text("ok"))
                  : Container()
            ],
            title: Text(title),
            content: Text(content),
          )),
      barrierDismissible: false);
}
