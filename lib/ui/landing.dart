import 'package:flutter/material.dart';

class LandingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
