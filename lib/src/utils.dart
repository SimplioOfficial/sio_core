import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart';

@internal
Future<Response> getRequest(String apiEndpoint) async {
  return get(
    Uri.parse(apiEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

@internal
Future<Response> postRequest(String apiEndpoint, data) async {
  return post(
    Uri.parse(apiEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
}

@internal
Future<String> recentBlockHashRequest({
  required String apiEndpoint,
}) async {
  final request = await postRequest(apiEndpoint, {
    "jsonrpc": "2.0",
    "id": "1",
    "method": "getRecentBlockhash",
    "params": [
      {
        "commitment": "confirmed",
      }
    ]
  });
  return request.body;
}

@internal
Future<String> getUtxo({
  required String apiEndpoint,
}) async {
  final request = await getRequest(apiEndpoint);
  return request.body;
}
