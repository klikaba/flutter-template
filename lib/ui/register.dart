import 'package:flutter/material.dart';
import 'package:flutter_template/data/auth/oauth2/api.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

import '../data/user/api.dart';

class RegisterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Template'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Welcome to register screen'), RegisterFormWidget()],
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class RegisterFormWidget extends StatefulWidget {
  RegisterFormWidget({Key key}) : super(key: key);

  @override
  _RegisterFormWidgetState createState() => _RegisterFormWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Enter your email', labelText: 'Email'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: _username),
          TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: 'Enter your password', labelText: 'Password'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: _password),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  final request = Provider.of<OAuth2TokenRequestFactory>(
                          context,
                          listen: false)
                      .makeCreateRequest(_username.text, _password.text);
                  Provider.of<UserRepository>(context, listen: false)
                      .create(RegistrationInfo(
                          email: _username.text, password: _password.text))
                      .then((res) =>
                          Provider.of<OAuth2TokenApi>(context, listen: false)
                              .createToken(request))
                      .then((res) => Navigator.pushNamed(context, '/main'))
                      .catchError(
                          (error) => Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('An issue occurred. $error'),
                              )));
                }
              },
              child: Text('Register'),
            ),
          ),
        ],
      ),
    );
  }
}
