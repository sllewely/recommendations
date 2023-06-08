import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:mobile/auth.dart';

class AuthHelper extends ChangeNotifier {
  final AuthConfig authConfig;
  late UserStorage userStorage;

  BaseUser _user = AnonymousUser();
  BaseUser get currentUser => _user;

  AuthHelper(this.authConfig, {userStorage}) {
    this.userStorage = userStorage ?? UserStorage(authConfig.tokenUrl);
    fetchUser();
  }

  Future<void> fetchUser() async {
    var newUser = await userStorage.getUser();
    if (newUser.isSignedIn() != _user.isSignedIn()) {
      _user = newUser;
      notifyListeners();
    }
  }

  void logUserOut() {
    userStorage.removeUser();
    _user = AnonymousUser();
    notifyListeners();
  }

  void logUserIn(User user) {
    if (_user.email != user.email) {
      _user = user;
    }
    notifyListeners();
    userStorage.insertUser(user);
  }
}