import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart';

@internal
Future<Response> createRequest(String apiEndpoint, data) async {
  return post(
    Uri.parse(apiEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
}

@internal
Future<Response> recentBlockHashRequest({required String apiEndpoint}) async {
  return post(
    Uri.parse(apiEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {
        "jsonrpc": "2.0",
        "id": "1",
        "method": "getRecentBlockhash",
        "params": [
          {
            "commitment": "confirmed",
          }
        ]
      },
    ),
  );
}
