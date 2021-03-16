import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'ui/landing.dart';
import 'ui/login.dart';
import 'ui/main.dart';
import 'ui/register.dart';
import 'data/auth/config.dart';
import 'data/auth/oauth2/api.dart';
import 'data/auth/oauth2/interceptor.dart';
import 'data/auth/oauth2/token.dart';
import 'data/user/model.dart';
import 'data/user/api.dart';

class SimpleClientConfig implements ClientConfig {
  @override
  String get clientId => Config.clientId;

  @override
  String get clientSecret => Config.clientSecret;
}

void runTemplateApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// TODO create somewhere else?
  final dir = await getExternalStorageDirectory();
  Hive
    ..init(dir.path)
    ..registerAdapter(OAuth2TokenAdapter())
    ..registerAdapter(UserAdapter());

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
  if (Config.enableLogs) {
    final logInterceptor =
        LogInterceptor(requestBody: true, responseBody: true);
    httpClient.interceptors.add(logInterceptor);
    noAuthHttpClient.interceptors.add(logInterceptor);
  }

  final usersApi = UserApi(httpClient);
  final usersRepository = UserRepository(usersApi, await Hive.openBox('users'));

  runApp(MultiProvider(providers: [
    Provider(create: (context) => httpClient),
    Provider(create: (context) => tokenApi),
    Provider(create: (context) => tokenRequestFactory),
    Provider(create: (context) => usersRepository)
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
          '/main': (context) => MainWidget(),
        });
  }
}
