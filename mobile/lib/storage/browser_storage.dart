// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'base_storage.dart';

BaseStorage createStorage() => WebStorage();

class WebStorage implements BaseStorage {
  WebStorage();

  @override
  Future<String?> read(String key) async {
    return html.window.localStorage[key];
  }

  @override
  Future<void> write(String key, String value) async {
    html.window.localStorage[key] = value;
  }
}