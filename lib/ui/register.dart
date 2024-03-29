import 'package:flutter/material.dart';
import 'package:flutter_template/data/session/api.dart';
import 'package:flutter_template/data/session/model.dart';
import 'package:flutter_template/data/user/api.dart';
import 'package:provider/provider.dart';

class RegisterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Template'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('Welcome to register screen'),
            RegisterFormWidget(),
          ],
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({Key? key}) : super(key: key);

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
            decoration: const InputDecoration(hintText: 'Enter your email', labelText: 'Email'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: _username,
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter your password', labelText: 'Password'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: _password,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  Provider.of<UserRepository>(context, listen: false)
                      .create(
                        RegistrationInfo(email: _username.text, password: _password.text),
                      )
                      .then((res) => Provider.of<SessionRepository>(context, listen: false).logIn(Credentials(_username.text, _password.text)))
                      .then((res) => Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false))
                      .catchError(
                        (error) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('An issue occurred. $error'),
                          ),
                        ),
                      );
                }
              },
              child: const Text('Register'),
            ),
          ),
        ],
      ),
    );
  }
}
