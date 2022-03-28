import 'dart:convert';
import 'package:test/test.dart';
import 'package:bs58/bs58.dart';

// ignore: avoid_relative_lib_imports
import '../lib/src/utils.dart';

void main() {
  test('Create request', () async {
    final response =
        await createRequest('https://jsonplaceholder.typicode.com/todos/1', {});
    expect(response.body, '{}');
  });
  test('Create recent block hash request', () async {
    final response = await recentBlockHashRequest(
        apiEndpoint: 'https://api.devnet.solana.com');
    final String blockHash =
        jsonDecode(response)['result']['value']['blockhash'];
    expect(base58.decode(blockHash).length, 32);
  });
}
