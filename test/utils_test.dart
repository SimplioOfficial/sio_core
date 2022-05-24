import 'dart:convert';
import 'package:sio_core/sio_core.dart';
import 'package:sio_core/src/utils_internal.dart';
import 'package:test/test.dart';
import 'package:bs58/bs58.dart';

void main() {
  group('Utils internal - ', () {
    test('Create get request', () async {
      final response =
          await getRequest('https://jsonplaceholder.typicode.com/todos/1/');
      expect(jsonDecode(response.body)['id'], 1);
    });
    test('Create post request', () async {
      final response = await postEncodedRequest(
          'https://jsonplaceholder.typicode.com/todos/', {});
      expect(jsonDecode(response.body)['id'], 201);
    });
  });

  group('Utils - ', () {
    test('Test BigInt into list of bytes conversion', () async {
      expect(bigIntToBytes(BigInt.parse('100')), [100]);
      expect(bigIntToBytes(BigInt.parse('1000')), [3, 232]);
      expect(bigIntToBytes(BigInt.parse('10000')), [39, 16]);
      expect(bigIntToBytes(BigInt.parse('100000')), [1, 134, 160]);
      expect(bigIntToBytes(BigInt.parse('1000000')), [15, 66, 64]);
      expect(bigIntToBytes(BigInt.parse('10000000')), [152, 150, 128]);
      expect(bigIntToBytes(BigInt.parse('100000000')), [5, 245, 225, 0]);
      expect(bigIntToBytes(BigInt.parse('1000000000')), [59, 154, 202, 0]);
      expect(bigIntToBytes(BigInt.parse('10000000000')), [2, 84, 11, 228, 0]);
      expect(
          bigIntToBytes(BigInt.parse('100000000000')), [23, 72, 118, 232, 0]);
    });
    test('Cosmos Denomination', () {
      expect(cosmosDenomination(ticker: 'ATOM'), 'uatom');
      expect(cosmosDenomination(ticker: 'LUNA'), 'uluna');
      expect(cosmosDenomination(ticker: 'OSMO'), 'uosmo');
      try {
        cosmosDenomination(ticker: 'AMI');
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Create get cosmos account details request', () async {
      final response = await getCosmosAccountDetails(
        address: 'osmo1rlwemt45ryzc8ynakzwgfkltm7jy8lswpnfswn',
        apiEndpoint: 'https://lcd-osmosis.keplr.app/',
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['account']['account_number'], '456069');
    });
    test('Create get nonce request', () async {
      final response = await getNonce(
        address: '0x6A86087Ee103DCC2494cA2804e4934b913df84E8',
        apiEndpoint: 'https://data-seed-prebsc-1-s1.binance.org:8545/',
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['result'], '0xa');
    });
    test('Create get utxo request', () async {
      final response = await getUtxo(
          apiEndpoint: 'https://jsonplaceholder.typicode.com/todos/1/');
      expect(jsonDecode(response)['id'], 1);
    });
    test('Create latest block hash request', () async {
      final response = await latestBlockHashRequest(
          apiEndpoint: 'https://api.devnet.solana.com/');
      final String blockHash =
          jsonDecode(response)['result']['value']['blockhash'];
      expect(base58.decode(blockHash).length, 32);
    });
  });
}
