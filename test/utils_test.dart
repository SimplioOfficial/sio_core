import 'dart:convert';
import 'package:sio_core/sio_core.dart';
import 'package:sio_core/src/utils_internal.dart';
import 'package:test/test.dart';
import 'package:bs58/bs58.dart';

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
    final response = await latestBlockHashRequest(
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

  test('Create get nonce request', () async {
    final response = await getNonce(
      address: '0x6A86087Ee103DCC2494cA2804e4934b913df84E8',
      apiEndpoint: 'https://data-seed-prebsc-1-s1.binance.org:8545/',
    );
    expect(jsonDecode(response), isMap);
    expect(jsonDecode(response)['result'], '0xa');
  });
}
