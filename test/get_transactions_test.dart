import 'dart:convert';

import 'package:sio_core/src/get_transactions.dart';
import 'package:sio_core/src/utils_internal.dart';
import 'package:test/test.dart';

void main() {
  group('Get transactions for Ethereum - ', () {
    group('', () {
      test('Normal transactions', () async {
        const address = '0x7611615553cD85be3A3c86a1508b8437eFcD7193';
        final response = await GetTransactions.ethereumBlockbook(
          apiEndpoint: 'https://ethblockexplorer.org/',
          address: address,
        );
        var responseJson = response[response.length - 1].toJson();
        expect(responseJson, {
          'txType': 'receive',
          'address': '0x00192Fb10dF37c9FB26829eb2CC623cd1BF599E8',
          'amount': '50789876000000000',
          'txid':
              '0x0898bc3a1fffa2ef31eca1d82ddb4dbef9f1c3f9d0b84be7bc68c5111a107737',
          'networkFee': '809184238695000',
          'unixTime': 1647196886,
          'confirmed': true
        });
      });
      test('No transactions', () async {
        const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
        final response = await GetTransactions.ethereumBlockbook(
          apiEndpoint: 'https://eth2.trezor.io/',
          address: address,
          transactions: '1',
        );
        expect(response, []);
      });
      test('Error', () async {
        const address = '0x6A86087Ee103DCC2494cA2804e4934b913df';
        try {
          await GetTransactions.ethereumBlockbook(
            apiEndpoint: 'https://eth1.trezor.io/',
            address: address,
          );
        } catch (exception) {
          expect(exception, isA<Exception>());
        }
      });
      group('ERC20 Tokens - ', () {
        test('Normal transactions', () async {
          const address = '0x734Ac651Dd95a339c633cdEd410228515F97fAfF';
          const contractAddress = '0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39';
          final response = await GetTransactions.ethereumERC20Blockbook(
            address: address,
            contractAddress: contractAddress,
            apiEndpoint: 'https://ethblockexplorer.org/',
          );
          var responseJson = response[response.length - 1].toJson();
          expect(responseJson, {
            'txType': 'receive',
            'address': '0x0b795E585Ec0436E4572Cc9B24FC5DA1faf9cFC6',
            'amount': '10000000000',
            'txid':
                '0x8f09f5b0ae75e4b15fc36af09a1641733991d9054e1217db9a37d535056d34b3',
            'networkFee': '7014891000000000',
            'unixTime': 1585781289,
            'confirmed': true
          });
        });
        test('No transactions', () async {
          const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
          const contractAddress = '0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39';
          final response = await GetTransactions.ethereumERC20Blockbook(
            address: address,
            contractAddress: contractAddress,
            apiEndpoint: 'https://eth2.trezor.io/',
            transactions: '1',
          );
          expect(response, []);
        });
        test('Error', () async {
          const address = '0x6A86087Ee103DCC2494cA2804e4934b913df';
          const contractAddress = '0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39';
          try {
            await GetTransactions.ethereumERC20Blockbook(
              address: address,
              contractAddress: contractAddress,
              apiEndpoint: 'https://eth1.trezor.io/',
            );
          } catch (exception) {
            expect(exception, isA<Exception>());
          }
        });
      });
    });
  });
  group('Get transactions for Solana - ', () {
    group('', () {
      test('Normal transactions', () async {
        const address = '3fTR8GGL2mniGyHtd3Qy2KDVhZ9LHbW59rCc7A3RtBWk';
        final response = await GetTransactions.solana(
          apiEndpoint: 'https://api.mainnet-beta.solana.com/',
          address: address,
          txLimit: 1000,
        );
        var responseJson = response[response.length - 1].toJson();
        expect(responseJson, {
          "txType": null,
          "address": null,
          "amount": null,
          "txid":
              "24vwWYjCzUbCwW3LonCMyvtSpshumBoANLyo2GN8wshMWuzkkGxRuEoNHiVKxwAjBWJF7Yz2ceomjtNdwUF5dkjR",
          "networkFee": null,
          "unixTime": 1628684172,
          "confirmed": true
        });
      });
      test('No transactions', () async {
        const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJCu4f';
        final response = await GetTransactions.solana(
          apiEndpoint: 'https://api.mainnet-beta.solana.com/',
          address: address,
          txLimit: 1,
        );
        expect(response, []);
      });
      test('Error', () async {
        const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJ';
        try {
          await GetTransactions.solana(
            apiEndpoint: 'https://api.mainnet-beta.solana.com/',
            address: address,
          );
        } catch (exception) {
          expect(exception, isA<Exception>());
        }
      });
    });
  });

  group('Get transactions for utxoCoin - ', () {
    group('Blockbook - ', () {
      test('Bitcoin - No transactions', () async {
        const address = 'bc1qwquauyfgqgwh2gc9td8dhrf00432duh77wvxy5';
        final response = await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://btc1.simplio.io/',
          address: address,
        );
        expect(response, []);
      });

      test('Bitcoin - Error', () async {
        const address = 'ltc1q4jd8494yun73v5ul2wcl5p32lcxm66afx4efr6';
        try {
          await GetTransactions.utxoCoinBlockbook(
            apiEndpoint: 'https://btc1.simplio.io/',
            address: address,
          );
        } catch (exception) {
          expect(exception, isA<Exception>());
        }
      });
      test('Litecoin - Standard transactions', () async {
        const address = 'ltc1qulzv02h8nmsuqxaqas3dv22cl244r7vs0smssh';
        final response = await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://ltc1.simplio.io/',
          address: address,
        );
        var responseJson = [...response.map((tx) => tx.toJson())];
        expect(responseJson, [
          {
            "txType": "receive",
            "address": "ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z",
            "amount": "29169",
            "txid":
                "f873f455ded89ef7fc7eae62f9ef78c02814f28cf9501f871cbe576096ad9ef5",
            "networkFee": "705",
            "unixTime": 1651047441,
            "confirmed": true
          },
          {
            "txType": "receive",
            "address": "ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z",
            "amount": "10000",
            "txid":
                "6e5da8e54a0d785a9c3ec9eb0848d14a4011782cf93491404599e0a4cb5a1c67",
            "networkFee": "705",
            "unixTime": 1651047165,
            "confirmed": true
          }
        ]);
      });
      test('Litecoin - Send to self transaction', () async {
        const address = 'ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z';
        final response = await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://ltc1.simplio.io/',
          address: address,
          transactions: '9',
        );
        var responseJson = response[response.length - 9].toJson();
        expect(responseJson, {
          "txType": "send",
          "address": "ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z",
          "amount": "1915711",
          "txid":
              "4e2f538ffa7384c7600229f4398ce717cce2b6f5ba057dfaa2901cdb0e972b54",
          "networkFee": "890",
          "unixTime": 1651473147,
          "confirmed": true
        });
      });
      test('Litecoin - Generated coins', () async {
        const address = 'LfmssDyX6iZvbVqHv6t9P6JWXia2JG7mdb';
        final response = await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://ltc1.simplio.io/',
          address: address,
          page: '1000',
        );
        expect(response[response.length - 1].txid,
            '4eb47c6c53e4b4decb0ee36bfc928267de9a189f10359c8bfe495e57960f6762');
      });
      test('Dash - Composed transactions', () async {
        const address = 'XognSnGYoqaNiL2v24hRMwc6QdWfuRoQz7';
        final response = await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://dash1.trezor.io/',
          address: address,
        );
        expect(response[response.length - 1].txid,
            '24ba935d8ecd2d89873c9e23ea46581de950b14b8b23b1ef08ac6d000265d088');
      });
    });
    group('Insight - ', () {
      test('Flux - No transactions', () async {
        const address = 't1amMB14YTcUktfjHrz42XcDb2tdHmjgMQd';
        final response = await GetTransactions.utxoCoinInsight(
          apiEndpoint: 'https://explorer.runonflux.io/',
          address: address,
        );
        expect(response, []);
      });

      test('Flux - Error', () async {
        const address = 'ltc1q4jd8494yun73v5ul2wcl5p32lcxm66afx4efr6';
        try {
          await GetTransactions.utxoCoinInsight(
            apiEndpoint: 'https://explorer.runonflux.io/',
            address: address,
          );
        } catch (exception) {
          expect(exception, isA<Exception>());
        }
      });
      test('Flux - Standard transactions', () async {
        const address = 't1T7TSPDRrJ8aEvK17gyYMjJyWj6eJpD1de';
        final response = await GetTransactions.utxoCoinInsight(
          apiEndpoint: 'https://explorer.runonflux.io/',
          address: address,
        );
        var responseJson = [...response.map((tx) => tx.toJson())];
        expect(responseJson, [
          {
            "txType": "send",
            "address": "t1T7TSPDRrJ8aEvK17gyYMjJyWj6eJpD1de",
            "amount": "99980800",
            "txid":
                "b302b548c3df276dc88bd9a57a6281585a7ec2fdb7eac09e221292f6334a4291",
            "networkFee": "19200",
            "unixTime": 1652084859,
            "confirmed": true
          },
          {
            "txType": "receive",
            "address": "t1KePnYpakU4rvkhv5tp1VkhEVU1G1TV8i3",
            "amount": "100000000",
            "txid":
                "d41fa0bdf9c99265d9c0a62954a3f1cf858ad42ed0be75951caeb98beb35b1f6",
            "networkFee": "10000",
            "unixTime": 1652082995,
            "confirmed": true
          }
        ]);
      });
      test('Flux - Send to self transaction', () async {
        const address = 't1T7TSPDRrJ8aEvK17gyYMjJyWj6eJpD1de';
        final response = await GetTransactions.utxoCoinInsight(
          apiEndpoint: 'https://explorer.runonflux.io/',
          address: address,
        );
        var responseJson = response[response.length - 2].toJson();
        expect(responseJson, {
          "txType": "send",
          "address": "t1T7TSPDRrJ8aEvK17gyYMjJyWj6eJpD1de",
          "amount": "99980800",
          "txid":
              "b302b548c3df276dc88bd9a57a6281585a7ec2fdb7eac09e221292f6334a4291",
          "networkFee": "19200",
          "unixTime": 1652084859,
          "confirmed": true
        });
      });
      test('Flux - Generated coins', () async {
        const address = 't1fRRoTEWgoCUwSYSkFmr9V5mmTNRJedtUX';
        final tempResp = await getRequest(
            'https://explorer.runonflux.io/api/addrs/t1fRRoTEWgoCUwSYSkFmr9V5mmTNRJedtUX/txs?from=0&to=1');
        final int totalItems = jsonDecode(tempResp.body)['totalItems'];

        final response = await GetTransactions.utxoCoinInsight(
          apiEndpoint: 'https://explorer.runonflux.io/',
          address: address,
          fromTx: (totalItems - 8).toString(),
          toTx: (totalItems - 7).toString(),
        );
        var responseJson = [...response.map((tx) => tx.toJson())];
        expect(responseJson, [
          {
            "txType": "generate",
            "address": "No Inputs (Newly Generated Coins)",
            "amount": "937500000",
            "txid":
                "490653c7b86a46ebce25918a29bc3c7f9fcef685162fb8628449dea7db2a7b18",
            "networkFee": "0",
            "unixTime": 1637629607,
            "confirmed": true
          }
        ]);
      });
      test('Dash - Composed transactions', () async {
        const address = 'XognSnGYoqaNiL2v24hRMwc6QdWfuRoQz7';
        final response = await GetTransactions.utxoCoinInsight(
          apiEndpoint: 'https://dash1.trezor.io/',
          address: address,
          customEndpoint:
              'https://insight.dash.org/insight-api/addrs/XognSnGYoqaNiL2v24hRMwc6QdWfuRoQz7/txs',
        );
        var responseJson = [...response.map((tx) => tx.toJson())];
        expect(responseJson, [
          {
            "txType": "send",
            "address": "XbBoBA8uaKpoaMEDo6HARx7eScJCYuF6tE",
            "amount": "100001",
            "txid":
                "e76856db186e80d33a327532b4d64f3957569a386d10a704c90903604077e402",
            "networkFee": "0",
            "unixTime": 1628134906,
            "confirmed": true
          },
          {
            "txType": "receive",
            "address": "XgQRUeqj8VzeohTzG9h2rVZepSSwZD2uga",
            "amount": "100001",
            "txid":
                "24ba935d8ecd2d89873c9e23ea46581de950b14b8b23b1ef08ac6d000265d088",
            "networkFee": "0",
            "unixTime": 1628131587,
            "confirmed": true
          }
        ]);
      });
    });
  });
}
