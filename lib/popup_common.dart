import 'package:flutter/material.dart';

Future<void> showAlertDialog(
    {required BuildContext finalContext,
    required String title,
    required String message}) {
  return showDialog<void>(
    context: finalContext,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext _) {
      return AlertDialog(
        // <-- SEE HERE
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(finalContext).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(finalContext).pop();
            },
          ),
        ],
      );
    },
  );
}
