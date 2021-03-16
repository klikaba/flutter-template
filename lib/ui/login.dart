import 'package:flutter/material.dart';
import 'package:flutter_template/data/auth/oauth2/api.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatelessWidget {
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
            Text('Welcome to login screen'),
            LoginFormWidget()
          ],
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class LoginFormWidget extends StatefulWidget {
  LoginFormWidget({Key key}) : super(key: key);

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _LoginFormWidgetState extends State<LoginFormWidget> {
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
                  Provider.of<OAuth2TokenApi>(context, listen: false)
                      .createToken(request)
                      .then((res) => Navigator.pushNamed(context, '/main'))
                      .catchError(
                          (error) => Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('An issue occurred.'),
                              )));
                }
              },
              child: Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
