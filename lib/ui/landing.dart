import 'package:flutter/material.dart';
import 'package:flutter_template/data/session/api.dart';
import 'package:provider/provider.dart';

class LandingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<SessionRepository>(context, listen: false)
        .hasSession()
        .then((hasSession) => {
              if (hasSession)
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/main', (_) => false)
                }
            });
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Template'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Login')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Register')),
          ],
        ),
      ),
    );
  }
}
