import 'package:flutter/material.dart';
import 'package:flutter_template/data/session/api.dart';
import 'package:provider/provider.dart';

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          FlatButton(
              child: Text('Log out'),
              onPressed: () => {
                    Provider.of<SessionRepository>(context, listen: false)
                        .logOut()
                        .then((_) => Navigator.pushNamedAndRemoveUntil(
                            context, '/', (_) => false))
                  })
        ]),
        body: Text('Welcome to main'));
  }
}
