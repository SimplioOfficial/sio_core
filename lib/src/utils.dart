import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

@internal
Future<http.Response> createRequest(
    String apiEndpoint, Map<String, String> data) async {
  return http.post(
    Uri.parse(apiEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
}

@internal
Future<http.Response> recentBlockHashRequest(
    {required String apiEndpoint}) async {
  return http.post(
    Uri.parse(apiEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {
        "jsonrpc": "2.0",
        "id": "1",
        "method": "getRecentBlockhash",
      },
    ),
  );
}
