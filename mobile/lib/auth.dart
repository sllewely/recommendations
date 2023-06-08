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

  const AuthConfig({
    required this.signInUrl,
    required this.signUpUrl,
    required this.tokenUrl
  });
}

abstract class BaseUser {
  String? firstName;
  String? lastName;
  String? email;

  bool isSignedIn();

  Map<String, String?> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}

class AnonymousUser extends BaseUser {

  @override
  bool isSignedIn() {
    return false;
  }
}

class User extends BaseUser {
  @override
  User({required firstName, required lastName, required email});

  @override
  bool isSignedIn() {
    return true;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        firstName: map['firstName'],
        lastName: map['lastName'],
        email: map['email']
    );
  }
}

class UserStorage {
  String key;

  BaseStorage storage = createStorage();

  UserStorage(this.key, {BaseStorage? storage}) {
    if (storage != null) this.storage = storage;
  }

  Future<BaseUser> getUser() async {
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

  Future<void> insertUser(User user) async {
    await storage.write(key, jsonEncode(user.toMap()));
  }

  Future<void> removeUser() async {
    await storage.write(key, '');
  }
}