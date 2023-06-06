import 'dart:convert';
import 'package:http/http.dart' as http;

class TestList {
  final List testList;

  const TestList({
    required this.testList,
  });

  factory TestList.fromJson(Map<String, dynamic> json) {
    return TestList(
      testList: json['data'],
    );
  }
}

Future<TestList> fetchTestList() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:3000/api/v1/tests'));
  if (response.statusCode == 200) {
    return TestList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('FAIL');
  }
}