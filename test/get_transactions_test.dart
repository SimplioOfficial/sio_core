import 'dart:convert';

import 'package:sio_core/sio_core.dart';
import 'package:sio_core/src/utils_internal.dart';
import 'package:test/test.dart';

void main() {
  group('Get transactions for Cosmos - ', () {
    group('Osmosis - ', () {
      test('Normal transactions - receive', () async {
        const address = 'osmo107tgltdk7gen60agckp7d44jvja84uxscppy4z';
        final transactions = await GetTransactions.cosmos(
          address: address,
          apiEndpoint: 'https://api-osmosis-chain.imperator.co/',
          denomination: 'uosmo',
        );
        var transactionsJson = transactions[transactions.length - 1].toJson();
        expect(transactionsJson, {
          'txType': 'receive',
          'address': 'osmo1ryfjy25gmqxkggyxjrz93lrv5tc9q3rz2dyua3',
          'amount': '94000000',
          'txid':
              '490D484B0F6C41BD6D4204AD729AAAD85AB189D87936F48A09BB0E46D29BAB01',
          'networkFee': '0',
          'unixTime': 1652075783,
          'confirmed': true
        });
      });
      test('Normal transactions - send', () async {
        const address = 'osmo1ryfjy25gmqxkggyxjrz93lrv5tc9q3rz2dyua3';
        final transactions = await GetTransactions.cosmos(
          address: address,
          apiEndpoint: 'https://api-osmosis-chain.imperator.co/',
          denomination: 'uosmo',
        );
        var transactionsJson = transactions[transactions.length - 1].toJson();
        expect(transactionsJson, {
          'txType': 'send',
          'address': 'osmo1rlwemt45ryzc8ynakzwgfkltm7jy8lswpnfswn',
          'amount': '10000',
          'txid':
              'CC98A4B664215BEA994C6677DC23A9F44CB21F97276E4E3E36367DCDC0C02E33',
          'networkFee': '0',
          'unixTime': 1649840292,
          'confirmed': true
        });
      });
      test('No transactions', () async {
        const address = 'osmo13tw489fdjvp4w0k5r6glq9uwqctfvgap6vhcs9';
        final transactions = await GetTransactions.cosmos(
          address: address,
          apiEndpoint: 'https://api-osmosis-chain.imperator.co/',
          denomination: 'uosmo',
        );
        expect(transactions, []);
      });
      test('Error', () async {
        const address = 'omo13tw489fdjvp4w0k5r6glq9uwqctfvgap6vhcs9';
        try {
          await GetTransactions.cosmos(
            address: address,
            apiEndpoint: 'https://api-osmosis-chain.imperator.co/',
            denomination: 'uosmo',
          );
        } catch (exception) {
          expect(exception, isA<Exception>());
        }
      });
    });
  });

  group('Get transactions for Ethereum - ', () {
    group('Blockbook - ', () {
      group('', () {
        test('Normal transactions', () async {
          const address = '0x7611615553cD85be3A3c86a1508b8437eFcD7193';
          final transactions = await GetTransactions.ethereumBlockbook(
            apiEndpoint: 'https://ethblockexplorer.org/',
            address: address,
          );
          var transactionsJson = transactions[transactions.length - 1].toJson();
          expect(transactionsJson, {
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
        test('Transaction to self', () async {
          const address = '0x3E26e7F73A80444e67b7bE654A38aB85ccb6ea47';
          final transactions = await GetTransactions.ethereumBlockbook(
            apiEndpoint: 'https://bscxplorer.com/',
            address: address,
          );
          var transactionsJson = transactions[transactions.length - 2].toJson();
          expect(transactionsJson, {
            'txType': 'send',
            'address': '0x3E26e7F73A80444e67b7bE654A38aB85ccb6ea47',
            'amount': '10000000000000000',
            'txid':
                '0x006869f07ce6f2abc462f400012a496f878371f54231e6098de8913b2063949a',
            'networkFee': '105000000000000',
            'unixTime': 1656573972,
            'confirmed': true
          });
        });
        test('No transactions', () async {
          const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
          final transactions = await GetTransactions.ethereumBlockbook(
            apiEndpoint: 'https://ethblockexplorer.org/',
            address: address,
            transactions: '1',
          );
          expect(transactions, []);
        });
        test('Error', () async {
          const address = '0x6A86087Ee103DCC2494cA2804e4934b913df';
          try {
            await GetTransactions.ethereumBlockbook(
              apiEndpoint: 'https://ethblockexplorer.org/',
              address: address,
            );
          } catch (exception) {
            expect(exception, isA<Exception>());
          }
        });
        group('ERC20 Tokens - ', () {
          test('Token transactions - receive', () async {
            const address = '0x734Ac651Dd95a339c633cdEd410228515F97fAfF';
            const contractAddress =
                '0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39';
            final transactions = await GetTransactions.ethereumERC20Blockbook(
              address: address,
              contractAddress: contractAddress,
              apiEndpoint: 'https://ethblockexplorer.org/',
            );
            var transactionsJson =
                transactions[transactions.length - 1].toJson();
            expect(transactionsJson, {
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
          test('Token transactions - send', () async {
            const address = '0x8022C6E37Dc45F3AB24c962F2D4E9B6F0d89e670';
            const contractAddress =
                '0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39';
            final transactions = await GetTransactions.ethereumERC20Blockbook(
              address: address,
              contractAddress: contractAddress,
              apiEndpoint: 'https://ethblockexplorer.org/',
            );
            var transactionsJson =
                transactions[transactions.length - 6].toJson();
            expect(transactionsJson, {
              'txType': 'send',
              'address': '0xA64916f1235455fB8b9b97a5a2CD9b3B48879629',
              'amount': '25000000000000',
              'txid':
                  '0xccd0d6b2bc9022647ea31064469aa578d9abe7386f4be9057a6952e0e8ce6af8',
              'networkFee': '2715054200000000',
              'unixTime': 1651409940,
              'confirmed': true
            });
          });
          test('No transactions', () async {
            const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
            const contractAddress =
                '0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39';
            final transactions = await GetTransactions.ethereumERC20Blockbook(
              address: address,
              contractAddress: contractAddress,
              apiEndpoint: 'https://ethblockexplorer.org/',
              transactions: '1',
            );
            expect(transactions, []);
          });
          test('Error', () async {
            const address = '0x6A86087Ee103DCC2494cA2804e4934b913df';
            const contractAddress =
                '0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39';
            try {
              await GetTransactions.ethereumERC20Blockbook(
                address: address,
                contractAddress: contractAddress,
                apiEndpoint: 'https://ethblockexplorer.org/',
              );
            } catch (exception) {
              expect(exception, isA<Exception>());
            }
          });
        });
      });
    });
    group('Scan - ', () {
      group('', () {
        test('Normal transactions - receive', () async {
          const address = '0x5C5Ac16E3A591FAFde543cbC51CF0C9256852255';
          final transactions = await GetTransactions.ethereumScan(
              apiEndpoint:
                  'https://api.polygonscan.com/api?module=account&action=txlist&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=$polygonScanToken1',
              address: address,
              transactions: '4');
          var transactionsJson = transactions[1].toJson();
          expect(transactionsJson, {
            'txType': 'receive',
            'address': '0x3e26e7f73a80444e67b7be654a38ab85ccb6ea47',
            'amount': '100000000000000000',
            'txid':
                '0x4e0e42cfb7bec59a99f9490e3838e82bf4d033b3d5d92a5d5b31eb2f9ea6ae6a',
            'networkFee': '757880332251000',
            'unixTime': 1655971047,
            'confirmed': true
          });
        });
        test('Normal transactions - send', () async {
          const address = '0x5C5Ac16E3A591FAFde543cbC51CF0C9256852255';
          final transactions = await GetTransactions.ethereumScan(
              apiEndpoint:
                  'https://api.polygonscan.com/api?module=account&action=txlist&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=$polygonScanToken1',
              address: address,
              transactions: '4');
          var transactionsJson = transactions[0].toJson();
          expect(transactionsJson, {
            'txType': 'send',
            'address': '0x3e26e7f73a80444e67b7be654a38ab85ccb6ea47',
            'amount': '99160000000000000',
            'txid':
                '0xf459c2571f9066f7fcdb9856a651660970e5a1fa3ea1e2f97778888de29e644a',
            'networkFee': '707207467932000',
            'unixTime': 1655971639,
            'confirmed': true
          });
        });
        test('No transactions', () async {
          const address = '0xcA9A1f26cb5F6DDdf7e03d3e66962299655096bB';
          final transactions = await GetTransactions.ethereumScan(
            apiEndpoint:
                'https://api.polygonscan.com/api?module=account&action=txlist&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=$polygonScanToken1',
            address: address,
            transactions: '1',
          );
          expect(transactions, []);
        });
        test('Error', () async {
          const address = '6A86087Ee103DCC2494cA2804e4934b913df84E8';
          try {
            await GetTransactions.ethereumScan(
              apiEndpoint:
                  'https://api.polygonscan.com/api?module=account&action=txlist&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=$polygonScanToken1',
              address: address,
            );
          } catch (exception) {
            expect(exception, isA<Exception>());
          }
        });
        test('Normal transactions - receive', () async {
          const address = '0x5C5Ac16E3A591FAFde543cbC51CF0C9256852255';
          final transactions = await GetTransactions.ethereumScan(
              apiEndpoint:
                  'https://api.snowtrace.io/api?module=account&action=txlist&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=$snowTraceToken',
              address: address,
              transactions: '4');
          var transactionsJson = transactions[transactions.length - 1].toJson();
          expect(transactionsJson, {
            'txType': 'receive',
            'address': '0x3e26e7f73a80444e67b7be654a38ab85ccb6ea47',
            'amount': '10000000000000000',
            'txid':
                '0xc2f639f0bf82731e43ce05e3f3788e0f738e44b3a281ae77634390e1b8cf5bf3',
            'networkFee': '577500000000000',
            'unixTime': 1657108396,
            'confirmed': true
          });
        });
      });
      group('ERC20 Tokens - ', () {
        test('Token transactions - receive', () async {
          const address = '0x6813ad11cca98e15ff181a257a3c2855d1eee69e';
          const contractAddress = '0x0d500b1d8e8ef31e21c99d1db9a6444d3adf1270';
          final transactions = await GetTransactions.ethereumERC20Scan(
            address: address,
            contractAddress: contractAddress,
            apiEndpoint:
                'https://api.polygonscan.com/api?module=account&action=tokentx&contractaddress=<contractAddress>&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=$polygonScanToken2',
            transactions: '4',
          );
          var transactionsJson = transactions[1].toJson();
          expect(transactionsJson, {
            'txType': 'receive',
            'address': '0x2bb25175d9b0f8965780209eb558cc3b56ca6d32',
            'amount': '10949780364609273272',
            'txid':
                '0x636b3dcf495774e3f84ab243ef119fb0cc31f5f1442d57b59f2e67725858d6cc',
            'networkFee': '328285707307276',
            'unixTime': 1643889382,
            'confirmed': true
          });
        });
        test('Token transactions - send', () async {
          const address = '0x6813ad11cca98e15ff181a257a3c2855d1eee69e';
          const contractAddress = '0x0d500b1d8e8ef31e21c99d1db9a6444d3adf1270';
          final transactions = await GetTransactions.ethereumERC20Scan(
            address: address,
            contractAddress: contractAddress,
            apiEndpoint:
                'https://api.polygonscan.com/api?module=account&action=tokentx&contractaddress=<contractAddress>&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=$polygonScanToken2',
            transactions: '4',
          );
          var transactionsJson = transactions[2].toJson();
          expect(transactionsJson, {
            'txType': 'send',
            'address': '0xdb6f1920a889355780af7570773609bd8cb1f498',
            'amount': '48115167258267691199',
            'txid':
                '0xf6074101a2759533652e0d857de0fd3bcbe8a8b589a0506159479568745dd628',
            'networkFee': '112617450000000000',
            'unixTime': 1641640298,
            'confirmed': true
          });
        });
        test('No transactions', () async {
          const address = '0x5C5Ac16E3A591FAFde543cbC51CF0C9256852255';
          const contractAddress = '0x0d500b1d8e8ef31e21c99d1db9a6444d3adf1270';
          final transactions = await GetTransactions.ethereumERC20Scan(
            address: address,
            contractAddress: contractAddress,
            apiEndpoint:
                'https://api.polygonscan.com/api?module=account&action=tokentx&contractaddress=<contractAddress>&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=$polygonScanToken2',
            transactions: '1',
          );
          expect(transactions, []);
        });
        test('Error', () async {
          const address = '5C5Ac16E3A591FAFde543cbC51CF0C9256852255';
          const contractAddress = '0x0d500b1d8e8ef31e21c99d1db9a6444d3adf1270';
          try {
            await GetTransactions.ethereumERC20Scan(
              address: address,
              contractAddress: contractAddress,
              apiEndpoint:
                  'https://api.polygonscan.com/api?module=account&action=tokentx&contractaddress=<contractAddress>&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=$polygonScanToken2',
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
        final transactions = await GetTransactions.solana(
          apiEndpoint: 'https://api.mainnet-beta.solana.com/',
          address: address,
          txLimit: 1000,
        );
        var transactionsJson = transactions[transactions.length - 1].toJson();
        expect(transactionsJson, {
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
        final transactions = await GetTransactions.solana(
          apiEndpoint: 'https://api.mainnet-beta.solana.com/',
          address: address,
          txLimit: 1,
        );
        expect(transactions, []);
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
        final transactions = await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://btc1.simplio.io/',
          address: address,
        );
        expect(transactions, []);
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
        final transactions = await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://ltc1.simplio.io/',
          address: address,
        );
        var transactionsJson = [...transactions.map((tx) => tx.toJson())];
        expect(transactionsJson, [
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
        final transactions = await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://ltc1.simplio.io/',
          address: address,
          transactions: '9',
        );
        var transactionsJson = transactions[transactions.length - 9].toJson();
        expect(transactionsJson, {
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
        final transactions = await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://ltc1.simplio.io/',
          address: address,
          page: '1000',
        );
        expect(transactions[transactions.length - 1].txid,
            '4eb47c6c53e4b4decb0ee36bfc928267de9a189f10359c8bfe495e57960f6762');
      });
      test('Dash - Composed transactions', () async {
        const address = 'XognSnGYoqaNiL2v24hRMwc6QdWfuRoQz7';
        final transactions = await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://dash1.trezor.io/',
          address: address,
        );
        expect(transactions[transactions.length - 1].txid,
            '24ba935d8ecd2d89873c9e23ea46581de950b14b8b23b1ef08ac6d000265d088');
      });
    });
    group('Insight - ', () {
      test('Flux - No transactions', () async {
        const address = 't1amMB14YTcUktfjHrz42XcDb2tdHmjgMQd';
        final transactions = await GetTransactions.utxoCoinInsight(
          apiEndpoint: 'https://explorer.runonflux.io/',
          address: address,
        );
        expect(transactions, []);
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
        final transactions = await GetTransactions.utxoCoinInsight(
          apiEndpoint: 'https://explorer.runonflux.io/',
          address: address,
        );
        var transactionsJson = [...transactions.map((tx) => tx.toJson())];
        expect(transactionsJson, [
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
        final transactions = await GetTransactions.utxoCoinInsight(
          apiEndpoint: 'https://explorer.runonflux.io/',
          address: address,
        );
        var transactionsJson = transactions[transactions.length - 2].toJson();
        expect(transactionsJson, {
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

        final transactions = await GetTransactions.utxoCoinInsight(
          apiEndpoint: 'https://explorer.runonflux.io/',
          address: address,
          fromTx: (totalItems - 8).toString(),
          toTx: (totalItems - 7).toString(),
        );
        var transactionsJson = [...transactions.map((tx) => tx.toJson())];
        expect(transactionsJson, [
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
        final transactions = await GetTransactions.utxoCoinInsight(
          apiEndpoint: 'https://dash1.trezor.io/',
          address: address,
          customEndpoint:
              'https://insight.dash.org/insight-api/addrs/XognSnGYoqaNiL2v24hRMwc6QdWfuRoQz7/txs',
        );
        var transactionsJson = [...transactions.map((tx) => tx.toJson())];
        expect(transactionsJson, [
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
