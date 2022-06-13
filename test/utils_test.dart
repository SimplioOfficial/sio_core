import 'dart:convert';
import 'package:sio_core/sio_core.dart';
import 'package:sio_core/src/utils_internal.dart';
import 'package:test/test.dart';
import 'package:bs58/bs58.dart';

void main() {
  group('Utils internal - ', () {
    test('Create get request', () async {
      final request =
          await getRequest('https://jsonplaceholder.typicode.com/todos/1/');
      expect(jsonDecode(request.body)['id'], 1);
    });
    test('Create post request', () async {
      final request = await postEncodedRequest(
          'https://jsonplaceholder.typicode.com/todos/', {});
      expect(jsonDecode(request.body)['id'], 201);
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

    group('Cosmos - ', () {
      test('Cosmos Denomination', () {
        expect(UtilsCosmos.cosmosDenomination(ticker: 'ATOM'), 'uatom');
        expect(UtilsCosmos.cosmosDenomination(ticker: 'LUNA'), 'uluna');
        expect(UtilsCosmos.cosmosDenomination(ticker: 'OSMO'), 'uosmo');
        try {
          UtilsCosmos.cosmosDenomination(ticker: 'AMI');
        } catch (exception) {
          expect(exception, isA<Exception>());
        }
      });
      test('Create get cosmos account details request', () async {
        final cosmosAccountDetails = await UtilsCosmos.getCosmosAccountDetails(
          address: 'osmo1rlwemt45ryzc8ynakzwgfkltm7jy8lswpnfswn',
          apiEndpoint: 'https://lcd-osmosis.keplr.app/',
        );
        expect(cosmosAccountDetails.toJson()['accountNumber'], '456069');
      });
    });

    group('Ethereum - ', () {
      test('Create get nonce request', () async {
        final nonce = await UtilsEthereum.getNonce(
          address: '0x6A86087Ee103DCC2494cA2804e4934b913df84E8',
          apiEndpoint: 'https://bsc-dataseed.binance.org/',
        );
        expect(nonce, '0x0');
      });
    });

    group('Solana - ', () {
      test('Create latest block hash request', () async {
        final blockHash = await UtilsSolana.latestBlockHashRequest(
            apiEndpoint: 'https://api.mainnet-beta.solana.com/');
        expect(base58.decode(blockHash).length, 32);
      });
    });

    group('utxoCoin - ', () {
      test('Create get utxo request for blockbook', () async {
        final utxo = await UtilsUtxo.getUtxo(
          apiEndpoint: 'https://ltc1.trezor.io/',
          address: 'ltc1q4jd8494yun73v5ul2wcl5p32lcxm66afx4efr6',
        );
        expect(jsonDecode(utxo), []);
      });
      test('Create get utxo request for insight', () async {
        final utxo = await UtilsUtxo.getUtxo(
          apiEndpoint: 'https://explorer.runonflux.io/',
          address: 't1amMB14YTcUktfjHrz42XcDb2tdHmjgMQd',
          explorerType: 'insight',
        );
        expect(jsonDecode(utxo), []);
      });
    });
  });
}
