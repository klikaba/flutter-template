import 'package:flutter_template/data/auth/oauth2/api.dart';
import 'package:flutter_template/data/auth/oauth2/token.dart';
import 'package:flutter_template/data/session/model.dart';

class SessionRepository {
  final OAuth2TokenApi _api;
  final OAuth2TokenStorage _tokenStorage;
  final OAuth2TokenRequestFactory _requestFactory;

  SessionRepository(this._api, this._tokenStorage, this._requestFactory);

  Future<void> logIn(Credentials credentials) async {
    final request = _requestFactory.makeCreateRequest(credentials.username, credentials.password);
    final token = await _api.createToken(request);
    _tokenStorage.saveToken(token);
  }

  Future<void> logOut() async {
    _tokenStorage.clearToken();
  }

  Future<bool> hasSession() async {
    return _tokenStorage.getToken() != null;
  }
}
