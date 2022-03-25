import 'dart:convert';
import 'package:test/test.dart';

// ignore: avoid_relative_lib_imports
import '../lib/src/utils.dart';

void main() {
  test('Create request', () async {
    final response =
        await createRequest('https://jsonplaceholder.typicode.com/todos/1', {});
    expect(response.body, '{}');
  });
  test('Create block hash request', () async {
    final response = await recentBlockHashRequest(
        apiEndpoint: 'https://api.devnet.solana.com');
    final String blockHash =
        jsonDecode(response.body)['result']['value']['blockhash'];
    expect(blockHash.length, 44);
  });
}
