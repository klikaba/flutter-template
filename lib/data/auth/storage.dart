import 'package:flutter/material.dart';
import 'token.dart';

abstract class TokenStorage<T extends AuthToken> extends ChangeNotifier {
  T get token;
  set token(T token);

  void clear();
}
