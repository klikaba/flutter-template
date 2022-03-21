import 'package:flutter_template/app.dart';
import 'package:flutter_template/config.dart';

void main() {
  Config.appFlavor = Flavor.DEVELOPMENT;
  Config.baseUrl = 'https://test.com';
  Config.clientId = 'abc';
  Config.clientSecret = 'def';
  Config.enableLogs = true;

  runTemplateApp();
}
