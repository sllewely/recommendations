import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mobile/auth.dart';
import 'package:http/http.dart' as http;


class AuthHelper extends ChangeNotifier {
  final AuthConfig authConfig;
  late UserStorage userStorage;
  late TokenStorage tokenStorage;

  BaseUser _user = AnonymousUser();
  BaseUser get currentUser => _user;
  Token _token = Token();
  Token get currentToken => _token;

  AuthHelper(this.authConfig, {userStorage, tokenStorage}) {
    this.userStorage = userStorage ?? UserStorage('user');
    this.tokenStorage = tokenStorage ?? TokenStorage(authConfig.tokenUrl);

    fetchUser();
    fetchToken();
  }

  Future<void> fetchUser() async {
    var newUser = await userStorage.get();
    if (newUser.isSignedIn() != _user.isSignedIn()) {
      _user = newUser;
      notifyListeners();
    }
  }

  Future<Token> fetchToken() async {
    Token token = currentToken.isEmpty() ? await tokenStorage.get() : currentToken;
    if (!token.isEmpty() && token.isRefreshNeeded()) {
      token = await fetchFromRefresh();
    }
    return token;
  }

  Future<Token> fetchFromRefresh() async {
    String refreshToken = _token.refreshToken!;

    final response = await http.post(Uri.parse(authConfig.tokenUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "grant_type": "refresh_token",
        "refresh_token": refreshToken,
      })
    );

    Map<String, dynamic> decodedResp = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _token = Token.fromHttp(decodedResp);
    } else if (response.statusCode > 500) {
      notifyListeners();
      throw Exception("Big fail ${decodedResp['error']} ${decodedResp['error_description']}");
    } else {
      logUserOut();
    }
    tokenStorage.insert(_token);
    return _token;
  }

  void logUserOut() {
    userStorage.remove();
    tokenStorage.remove();
    _user = AnonymousUser();
    _token = Token();
    notifyListeners();
  }

  Future<void> signUserUp(AnonymousUser user, Function onSuccess) async {
    final signUpResp = await http.post(Uri.parse(authConfig.signUpUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "user": {
          ...user.toHttpMap(),
        }
      })
    );
    Map<String, dynamic> decodedResp = jsonDecode(signUpResp.body);
    if (signUpResp.statusCode != 200) {
        _user.errors = decodedResp['error_description'];
        notifyListeners();
    } else {
      await signUserIn(user.email!, user.password!, onSuccess);
    }


  }

  Future<void> signUserIn(String email, String password, Function onLoginComplete) async {
    Map<String, String?> body = {
      "email": email,
      "password": password,
      "client_id": authConfig.clientId,
      "client_secret": authConfig.clientSecret,
      "grant_type": "password",
    };

    final response = await http.post(Uri.parse(authConfig.signInUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    Map<String, dynamic> decodedResp = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _user = User.fromMap({"email": email});
      _token = Token.fromHttp(decodedResp);
      onLoginComplete();
    } else if (response.statusCode > 500) {
      throw Exception("Big fail ${decodedResp['error']} ${decodedResp['error_description']}");
    } else {
      _token.errors = decodedResp['error_description'];
    }
    tokenStorage.insert(_token);
    userStorage.insert(_user);
    notifyListeners();
  }

  /// Performs a POST request to the specified [url], adding the authorization token.
  ///
  /// If no token already exists, or if it is expired, a new one is requested.
  Future<http.Response> post(String url,
      {Map<String, String>? headers,
        dynamic body,
        http.Client? httpClient}) async {
    return _request('POST', url,
        headers: headers, body: body, httpClient: httpClient);
  }

  /// Performs a PUT request to the specified [url], adding the authorization token.
  ///
  /// If no token already exists, or if it is expired, a new one is requested.
  Future<http.Response> put(String url,
      {Map<String, String>? headers,
        dynamic body,
        http.Client? httpClient}) async {
    return _request('PUT', url,
        headers: headers, body: body, httpClient: httpClient);
  }

  /// Performs a PATCH request to the specified [url], adding the authorization token.
  ///
  /// If no token already exists, or if it is expired, a new one is requested.
  Future<http.Response> patch(String url,
      {Map<String, String>? headers,
        dynamic body,
        http.Client? httpClient}) async {
    return _request('PATCH', url,
        headers: headers, body: body, httpClient: httpClient);
  }

  /// Performs a GET request to the specified [url], adding the authorization token.
  ///
  /// If no token already exists, or if it is expired, a new one is requested.
  Future<http.Response> get(String url,
      {Map<String, String>? headers, http.Client? httpClient}) async {
    return _request('GET', url, headers: headers, httpClient: httpClient);
  }

  /// Performs a DELETE request to the specified [url], adding the authorization token.
  ///
  /// If no token already exists, or if it is expired, a new one is requested.
  Future<http.Response> delete(String url,
      {Map<String, String>? headers, http.Client? httpClient}) async {
    return _request('DELETE', url, headers: headers, httpClient: httpClient);
  }

  /// Performs a HEAD request to the specified [url], adding the authorization token.
  ///
  /// If no token already exists, or if it is expired, a new one is requested.
  Future<http.Response> head(String url,
      {Map<String, String>? headers,
        dynamic body,
        http.Client? httpClient}) async {
    return _request('HEAD', url, headers: headers, httpClient: httpClient);
  }

  /// Common method for making http requests
  /// Tries to use a previously fetched token, otherwise fetches a new token by means of a refresh flow or by issuing a new authorization flow
  Future<http.Response> _request(String method, String url,
      {Map<String, String>? headers,
        dynamic body,
        http.Client? httpClient}) async {
    httpClient ??= http.Client();

    headers ??= {};

    sendRequest(accessToken) async {
      http.Response resp;

      headers!['Authorization'] = 'Bearer $accessToken';

      if (method == 'POST') {
        resp = await httpClient!
            .post(Uri.parse(url), body: body, headers: headers);
      } else if (method == 'PUT') {
        resp =
        await httpClient!.put(Uri.parse(url), body: body, headers: headers);
      } else if (method == 'PATCH') {
        resp = await httpClient!
            .patch(Uri.parse(url), body: body, headers: headers);
      } else if (method == 'GET') {
        resp = await httpClient!.get(Uri.parse(url), headers: headers);
      } else if (method == 'DELETE') {
        resp = await httpClient!.delete(Uri.parse(url), headers: headers);
      } else if (method == 'HEAD') {
        resp = await httpClient!.head(Uri.parse(url), headers: headers);
      } else {
        throw Exception('Unknown method $method!');
      }

      return resp;
    }

    http.Response resp;

    //Retrieve the current token, or fetches a new one if it is expired
    var tknResp = await fetchToken();

    try {
      resp = await sendRequest(tknResp.accessToken);

      if (resp.statusCode == 401) {
        //The token could have been invalidated on the server side
        //Try to fetch a new token...
        if (tknResp.isRefreshNeeded()) {
          tknResp = await fetchFromRefresh();
        } else {
          tknResp = await fetchToken();
        }

        if (tknResp.isValid()) {
          resp = await sendRequest(tknResp.accessToken);
        }
      }
    } catch (e) {
      rethrow;
    }
    return resp;
  }
}