import 'dart:convert';

import 'package:http/http.dart';
import 'package:sio_core/src/utils_internal.dart';

enum TxType {
  generate,
  send,
  receive,
}

class _Tx {
  TxType? txType;
  String? address;
  String? amount;
  final String? txid;
  final String? networkFee;
  final int? unixTime;
  bool? confirmed;

  _Tx({
    this.txType,
    this.address,
    this.amount,
    this.txid,
    this.networkFee,
    this.unixTime,
    this.confirmed,
  });

  Map<String, dynamic> toJson() {
    return {
      'txType': txType?.name,
      'address': address,
      'amount': amount,
      'txid': txid,
      'networkFee': networkFee,
      'unixTime': unixTime,
      'confirmed': confirmed,
    };
  }
}

/// Class that returns transaction object for different coins and tokens.
class GetTransactions {
  /// Get Solana transactions from mainnet, testnet, devnet
  /// depending on whatever apiEndpoint is used:
  /// * https://api.mainnet-beta.solana.com/
  /// * https://api.devnet.solana.com/
  static Future<List<_Tx>> solana({
    required String address,
    required String apiEndpoint,
    int txLimit = 1000,
  }) async {
    List<_Tx> txList = [];
    final request = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": 1,
      "method": "getSignaturesForAddress",
      "params": [
        address,
        {"limit": txLimit}
      ]
    });
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }
    final _txList = jsonDecode(request.body)['result'];
    if (_txList.isEmpty) {
      return [];
    }
    for (var txIndex = 0; txIndex < _txList.length; txIndex++) {
      var tx = _Tx(
        txid: _txList[txIndex]['signature'],
        unixTime: _txList[txIndex]['blockTime'],
        confirmed: _txList[txIndex]['confirmationStatus'] == 'finalized' ||
            _txList[txIndex]['confirmationStatus'] == 'confirmed',
      );
      txList.add(tx);
    }

    return txList;
  }

  /// Get BTC, BCH, DASH, DGB, DOGE, LTC, ZEC transactions from mainnet.
  ///
  /// Works with Blockbook:
  /// * https://btc1.simplio.io/
  /// * https://bch1.simplio.io/
  /// * https://dash1.simplio.io/
  /// * https://dgb1.simplio.io/
  /// * https://doge1.simplio.io/
  /// * https://ltc1.simplio.io/
  /// * https://zec1.simplio.io/
  static Future<List<_Tx>> utxoCoinBlockbook({
    required String address,
    required String apiEndpoint,
    String page = '1',
    String transactions = '1000',
  }) async {
    List<_Tx> txList = [];
    final request = await getRequest(apiEndpoint +
        'api/v2/address/' +
        address +
        '?details=txs&page=' +
        page +
        '&pageSize=' +
        transactions);
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }
    if (jsonDecode(request.body)['txs'] == 0) {
      return [];
    }
    if (jsonDecode(request.body)['transactions'] is List) {
      final List _txList = jsonDecode(request.body)['transactions'];
      for (var txIndex = 0; txIndex < _txList.length; txIndex++) {
        var tx = _Tx(
          txid: _txList[txIndex]['txid'],
          networkFee: _txList[txIndex]['fees'],
          unixTime: _txList[txIndex]['blockTime'],
          confirmed: _txList[txIndex]['confirmations'] > 0,
        );
        if (_txList[txIndex]['vin'][0]['isAddress'] == false) {
          tx.txType = TxType.generate;
        } else {
          final List _vinAddrsList = _txList[txIndex]['vin'];
          final List _voutAddrsList = _txList[txIndex]['vout'];
          for (var i = 0; i < _vinAddrsList.length; i++) {
            if (_vinAddrsList[i]['addresses'][0] == address) {
              tx.txType = TxType.send;
            }
          }
          for (var i = 0; i < _voutAddrsList.length; i++) {
            if (_voutAddrsList[i]['addresses'][0] == address &&
                tx.txType == null) {
              tx.txType = TxType.receive;
            }
          }
        }
        if (tx.txType == TxType.generate || tx.txType == TxType.receive) {
          final List _voutAddrsList = _txList[txIndex]['vout'];
          var amount = 0;
          for (var i = 0; i < _voutAddrsList.length; i++) {
            if (_voutAddrsList[i]['addresses'][0] == address) {
              amount = amount + int.parse(_voutAddrsList[i]['value']);
            }
          }
          tx.amount = amount.toString();
        }

        if (tx.txType == TxType.send) {
          final List _voutAddrsList = _txList[txIndex]['vout'];
          final List _vinAddrsList = _txList[txIndex]['vin'];

          var amount = 0;
          for (var i = 0; i < _vinAddrsList.length; i++) {
            if (_vinAddrsList[i]['addresses'][0] == address) {
              amount = amount + int.parse(_vinAddrsList[i]['value']);
            }
          }
          for (var i = 0; i < _voutAddrsList.length; i++) {
            if (_voutAddrsList[i]['addresses'][0] == address) {
              amount = amount - int.parse(_voutAddrsList[i]['value']);
            }
          }
          amount = amount - int.parse(tx.networkFee ?? '0');
          tx.amount = amount.toString();
          for (var i = 0; i < _voutAddrsList.length; i++) {
            if (_voutAddrsList[i]['addresses'][0] != address) {
              tx.address = _voutAddrsList[i]['addresses'][0];
              break;
            } else {
              tx.address = address;
              tx.amount = _voutAddrsList[0]['value'];
            }
          }
        }

        if (tx.txType == TxType.receive) {
          final List _vinAddrsList = _txList[txIndex]['vin'];
          for (var i = 0; i < _vinAddrsList.length; i++) {
            if (_vinAddrsList[i]['addresses'][0] != address) {
              tx.address = _vinAddrsList[i]['addresses'][0];
              break;
            }
          }
        }

        if (tx.txType == TxType.generate) {
          tx.confirmed = _txList[txIndex]['confirmations'] > 100;
          tx.address = 'No Inputs (Newly Generated Coins)';
        }
        txList.add(tx);
      }
    }

    return txList;
  }

  /// Get FLUX balance from mainnet.
  ///
  /// Works with Insight:
  /// * https://explorer.runonflux.io/
  static Future<List<_Tx>> utxoCoinInsight({
    required String address,
    required String apiEndpoint,
    String fromTx = '0',
    String toTx = '10',
    String? customEndpoint,
  }) async {
    List<_Tx> txList = [];
    const satoshis = 100000000;
    late Response request;
    if (customEndpoint == null) {
      request = await getRequest(apiEndpoint +
          'api/addrs/' +
          address +
          '/txs/?from=' +
          fromTx +
          '&to=' +
          toTx);
    } else {
      request = await getRequest(customEndpoint);
    }
    if (jsonDecode(request.body)['totalItems'] == 0) {
      return [];
    }
    if (jsonDecode(request.body)['items'] is List) {
      final List _txList = jsonDecode(request.body)['items'];
      for (var txIndex = 0; txIndex < _txList.length; txIndex++) {
        var tx = _Tx(
          txid: _txList[txIndex]['txid'],
          networkFee: _txList[txIndex]['fees'] != null
              ? (_txList[txIndex]['fees'] * satoshis).round().toString()
              : '0',
          unixTime: _txList[txIndex]['time'],
          confirmed: _txList[txIndex]['confirmations'] > 0,
        );
        if (_txList[txIndex]['isCoinBase'] == true) {
          tx.txType = TxType.generate;
        } else {
          final List _vinAddrsList = _txList[txIndex]['vin'];
          final List _voutAddrsList = _txList[txIndex]['vout'];
          for (var i = 0; i < _vinAddrsList.length; i++) {
            if (_vinAddrsList[i]['addr'] == address) {
              tx.txType = TxType.send;
            }
          }
          for (var i = 0; i < _voutAddrsList.length; i++) {
            if (_voutAddrsList[i]['scriptPubKey']['addresses'] != null) {
              if (_voutAddrsList[i]['scriptPubKey']['addresses'][0] ==
                      address &&
                  tx.txType == null) {
                tx.txType = TxType.receive;
              }
            }
          }
        }
        if (tx.txType == TxType.generate || tx.txType == TxType.receive) {
          final List _voutAddrsList = _txList[txIndex]['vout'];
          var amount = 0;
          for (var i = 0; i < _voutAddrsList.length; i++) {
            if (_voutAddrsList[i]['scriptPubKey']['addresses'] != null) {
              if (_voutAddrsList[i]['scriptPubKey']['addresses'][0] ==
                  address) {
                amount = amount +
                    (double.parse(_voutAddrsList[i]['value']) * satoshis)
                        .round();
              }
            }
          }
          tx.amount = amount.toString();
        }
        if (tx.txType == TxType.send) {
          final List _voutAddrsList = _txList[txIndex]['vout'];
          final List _vinAddrsList = _txList[txIndex]['vin'];
          var amount = 0;
          for (var i = 0; i < _vinAddrsList.length; i++) {
            if (_vinAddrsList[i]['addr'] == address) {
              amount = amount + (_vinAddrsList[i]['valueSat'] as int);
            }
          }
          for (var i = 0; i < _voutAddrsList.length; i++) {
            if (_voutAddrsList[i]['scriptPubKey']['addresses'] != null) {
              if (_voutAddrsList[i]['scriptPubKey']['addresses'][0] ==
                  address) {
                amount = amount -
                    (double.parse(_voutAddrsList[i]['value']) * satoshis)
                        .round();
              }
            }
          }
          amount = amount - int.parse(tx.networkFee ?? '0');
          tx.amount = amount.toString();
          for (var i = 0; i < _voutAddrsList.length; i++) {
            if (_voutAddrsList[i]['scriptPubKey']['addresses'] != null) {
              if (_voutAddrsList[i]['scriptPubKey']['addresses'][0] !=
                  address) {
                tx.address = _voutAddrsList[i]['scriptPubKey']['addresses'][0];
                break;
              } else {
                tx.address = address;
                tx.amount =
                    (double.parse(_voutAddrsList[0]['value']) * satoshis)
                        .round()
                        .toString();
              }
            }
          }
        }
        if (tx.txType == TxType.receive) {
          final List _vinAddrsList = _txList[txIndex]['vin'];
          for (var i = 0; i < _vinAddrsList.length; i++) {
            if (_vinAddrsList[i]['addr'] != address) {
              tx.address = _vinAddrsList[i]['addr'];
              break;
            }
          }
        }
        if (tx.txType == TxType.generate) {
          tx.confirmed = _txList[txIndex]['confirmations'] > 100;
          tx.address = 'No Inputs (Newly Generated Coins)';
        }
        txList.add(tx);
      }
    }

    return txList;
  }
}
