import '../auth/oauth2/api.dart';
import '../auth/oauth2/token.dart';
import 'model.dart';

class SessionRepository {
  final OAuth2TokenApi _api;
  final OAuth2TokenStorage _tokenStorage;
  final OAuth2TokenRequestFactory _requestFactory;

  SessionRepository(this._api, this._tokenStorage, this._requestFactory);

  Future<void> logIn(Credentials credentials) async {
    final request = _requestFactory.makeCreateRequest(
        credentials.username, credentials.password);
    final token = await _api.createToken(request);
    _tokenStorage.saveToken(token);
    return null;
  }

  Future<void> logOut() async {
    _tokenStorage.clearToken();
    return null;
  }

  Future<bool> hasSession() async {
    return _tokenStorage.getToken() != null;
  }
}
