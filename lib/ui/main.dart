import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_template/data/country/api.dart';
import 'package:flutter_template/data/country/model.dart';
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
        body: CountriesListWidget(
            Provider.of<CountriesRepository>(context, listen: false)));
  }
}

class CountriesListWidget extends StatefulWidget {
  final CountriesRepository _repository;

  CountriesListWidget(this._repository);

  @override
  _CountriesListWidgetState createState() =>
      _CountriesListWidgetState(_repository);
}

class _CountriesListWidgetState extends State<CountriesListWidget> {
  final List<Country> _countries = [];
  final CountriesRepository _repository;

  _CountriesListWidgetState(this._repository);

  @override
  void initState() {
    super.initState();
    _repository.getAll().listen((countries) {
      setState(() {
        _countries.clear();
        _countries.addAll(countries);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: max(_countries.length * 2 - 1, 0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          return _buildRow(_countries[index]);
        });
  }

  Widget _buildRow(Country country) {
    return ListTile(title: Text(country.name), subtitle: Text(country.code));
  }
}
