import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/landing.dart';
import 'ui/login.dart';
import 'ui/register.dart';

void main() {
  runApp(MultiProvider(providers: [], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Template',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LandingWidget(),
          '/login': (context) => LoginWidget(),
          '/register': (context) => RegisterWidget(),
        });
  }
}
