import 'package:flutter/material.dart';

import '../intro_flip_flop_game.dart';

extension NotificationGame on ItemBoxState {
  Future<void> noticeChangePikaPosition() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('No more pair Pikachus'),
                Text(
                    '''Would you like to minus one turn to change Pikachus's position ?'''),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Oke'),
              onPressed: () {
                Navigator.of(context).pop();
                // shuffleMatrix();
              },
            ),
            // TextButton(
            //   child: const Text('No'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        );
      },
    );
  }

  Future<void> noticeWinGame() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notice'),
          content: SingleChildScrollView(
            child: ListBody(children: const <Widget>[
              Text('You WIN WIN WIN'),
            ]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Oke'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> noticeSamePikachu() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Dont pick same pikachu'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Oke'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
