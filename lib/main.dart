import 'package:flutter/material.dart';

import 'app.dart';
import 'config.dart';

void main() {
  Config.appFlavor = Flavor.PRODUCTION;
  Config.baseUrl = 'https://test.com';
  Config.clientId = 'abc';
  Config.clientSecret = 'def';
  runApp(MyApp());
}
