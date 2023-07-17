import 'dart:convert';

import 'package:mobile/storage/base_storage.dart';

import 'storage/storage.dart'
// ignore: uri_does_not_exist
if (dart.library.io) 'storage/secure_storage.dart'
// ignore: uri_does_not_exist
if (dart.library.html) 'storage/browser_storage.dart';



class AuthConfig {
  final String signInUrl;
  final String signUpUrl;
  final String tokenUrl;
  final String clientId;
  final String clientSecret;

  const AuthConfig({
    required this.signInUrl,
    required this.signUpUrl,
    required this.tokenUrl,
    required this.clientId,
    required this.clientSecret,
  });
}

abstract class BaseUser {
  String? firstName;
  String? lastName;
  String? email;
  String? errors;
  bool isSignedIn() => false;
  bool hasErrors() => errors != null;
  
  BaseUser({this.firstName, this.lastName, this.email});
  Map<String, String?> toMap() {
    Map<String, dynamic> map = {};
    if (firstName != null) {
      map['firstName'] = firstName;
    }
    if (lastName != null) {
      map['lastName'] = lastName;
    }
    return {
      ...map,
      'email': email,
    };
  }

  Map<String, String?> toHttpMap() {
    Map<String, dynamic> map = {};
    if (firstName != null) {
      map['first_name'] = firstName;
    }
    if (lastName != null) {
      map['last_name'] = lastName;
    }
    return {
      ...map,
      'email': email,
    };
  }
}

class AnonymousUser extends BaseUser {
  String? password;

  AnonymousUser ({this.password, email, firstName, lastName});
  @override
  bool isSignedIn() {
    return false;
  }

  @override
  Map<String, String?> toMap() {
    return {
      ...super.toMap(),
      'password': password,
    };
  }

  @override
  Map<String, String?> toHttpMap() {
    return {
      ...super.toHttpMap(),
      'password': password,
    };
  }
}

class User extends BaseUser {
  @override
  User({firstName, lastName, required email});

  @override
  bool isSignedIn() {
    return true;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        firstName: map.containsKey('firstName') ? map['firstName'] : null,
        lastName: map.containsKey('lastName') ? map['lastName'] : null,
        email: map['email']
    );
  }
}

class LocalStorage {
  String key;

  BaseStorage storage = createStorage();

  LocalStorage(this.key, {BaseStorage? storage}) {
    if (storage != null) this.storage = storage;
  }

  Future<void> insert(obj) async {
    await storage.write(key, jsonEncode(obj.toMap()));
  }

  Future<void> remove() async {
    await storage.write(key, '');
  }
}

class UserStorage extends LocalStorage {
  UserStorage(super.key);


  Future<BaseUser> get() async {
    BaseUser user = AnonymousUser();
    final serializedStoredUser = await storage.read(key);

    if (serializedStoredUser != null) {
      final storedUser = jsonDecode(serializedStoredUser);
      if (storedUser != null) {
        user = User.fromMap(storedUser);
      }
    }
    return user;
  }
}

class Token {
  String? accessToken;
  String? tokenType;
  String? refreshToken;
  int? expirationMs;
  String? errors;

  bool hasErrors() {
    return errors != null;
  }

  Token({this.accessToken, this.tokenType, this.refreshToken, this.expirationMs});

  DateTime? get expirationDate {
    DateTime? expirationDt;
    if (expirationMs != null) {
      expirationDt = DateTime.fromMillisecondsSinceEpoch(expirationMs!);
    }
    return expirationDt;
  }

  bool isRefreshNeeded({secondsToExpiration = 30}) {
    bool needsRefresh = false;

    if (expirationDate != null) {
      DateTime now = DateTime.now();
      needsRefresh = expirationDate!.difference(now).inSeconds < secondsToExpiration;
    }

    return needsRefresh;
  }

  bool isEmpty() {
    return refreshToken == null;
  }

  bool isValid() {
    return !isEmpty() && !isRefreshNeeded();
  }

  Map<String, dynamic> toMap() {
    return {
      "accessToken": accessToken,
      "tokenType": tokenType,
      "refreshToken": refreshToken,
      "expirationMs": expirationMs,
    };
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      accessToken: map['accessToken'],
      tokenType: map['tokenType'],
      refreshToken: map['refreshToken'],
      expirationMs: map['expirationMs'],
    );
  }

  factory Token.fromHttp(Map<String, dynamic> map) {
    return Token.fromMap({
      'accessToken': map['access_token'],
      'tokenType': map['token_type'],
      'refreshToken': map['refresh_token'],
      'expirationMs': map['created_at']*1000 + map['expires_in']*1000,
    });
  }
}

class TokenStorage extends LocalStorage {
  Token token = Token();
  TokenStorage(super.key);

  Future<Token> get() async {
    final serializedStoredToken = await storage.read(key);

    if (serializedStoredToken != null) {
      final storedToken = jsonDecode(serializedStoredToken);
      if (storedToken != null) {
        token = Token.fromMap(storedToken);
      }
    }
    return token;
  }

}