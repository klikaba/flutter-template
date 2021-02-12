import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'ui/landing.dart';
import 'ui/login.dart';
import 'ui/register.dart';
import 'data/auth/config.dart';
import 'data/auth/oauth2/api.dart';
import 'data/auth/oauth2/interceptor.dart';
import 'data/auth/oauth2/token.dart';

class SimpleClientConfig implements ClientConfig {
  @override
  String get clientId => Config.clientId;

  @override
  String get clientSecret => Config.clientSecret;
}

void main() async {
  /// TODO create somewhere else?
  final httpClient = Dio(BaseOptions(baseUrl: Config.baseUrl));
  final clientConfig = SimpleClientConfig();
  final noAuthHttpClient = Dio();
  noAuthHttpClient.options = httpClient.options;
  final tokenApi = OAuth2TokenApi(noAuthHttpClient);
  final tokenStorage = OAuth2TokenStorage(await Hive.openBox('tokenStorage'));
  final tokenRequestFactory = OAuth2TokenRequestFactory(clientConfig);
  final tokenRefresher =
      OAuth2TokenRefresher(tokenApi, tokenStorage, tokenRequestFactory);
  final tokenInterceptor =
      OAuth2Interceptor(httpClient, tokenStorage, tokenRefresher);
  httpClient.interceptors.add(tokenInterceptor);

  runApp(MultiProvider(providers: [
    Provider(create: (context) => httpClient),
    Provider(create: (context) => tokenApi),
    Provider(create: (context) => tokenRequestFactory)
  ], child: MyApp()));
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
