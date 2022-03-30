import 'dart:convert';
import 'package:test/test.dart';
import 'package:bs58/bs58.dart';

// ignore: avoid_relative_lib_imports
import '../lib/src/utils.dart';

void main() {
  test('Create get request', () async {
    final response =
        await getRequest('https://jsonplaceholder.typicode.com/todos/1');
    expect(jsonDecode(response.body)['id'], 1);
  });

  test('Create post request', () async {
    final response = await postEncodedRequest(
        'https://jsonplaceholder.typicode.com/todos', {});
    expect(jsonDecode(response.body)['id'], 201);
  });
  test('Create recent block hash request', () async {
    final response = await recentBlockHashRequest(
        apiEndpoint: 'https://api.devnet.solana.com');
    final String blockHash =
        jsonDecode(response)['result']['value']['blockhash'];
    expect(base58.decode(blockHash).length, 32);
  });

  test('Create get utxo request', () async {
    final response = await getUtxo(
        apiEndpoint: 'https://jsonplaceholder.typicode.com/todos/1');
    expect(jsonDecode(response)['id'], 1);
  });
}
