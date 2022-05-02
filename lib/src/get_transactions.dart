import 'dart:convert';

import 'package:sio_core/src/utils_internal.dart';

enum TxType {
  generate,
  send,
  receive,
}

class _Tx {
  TxType? txType;
  final String? address;
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
    required String apiEndpoint,
    required String address,
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
          address: _txList[txIndex]['vin'][0]['isAddress'] == false
              ? _txList[txIndex]['vout'][0]['addresses'][0]
              : (_txList[txIndex]['vin'][0]['addresses'][0] == address
                  ? _txList[txIndex]['vout'][0]['addresses'][0]
                  : _txList[txIndex]['vin'][0]['addresses'][0]),
          amount: _txList[txIndex]['vout'][0]['value'],
          txid: _txList[txIndex]['txid'],
          unixTime: _txList[txIndex]['blockTime'],
          networkFee: _txList[txIndex]['fees'],
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

        if (tx.txType == TxType.generate) {
          tx.confirmed = _txList[txIndex]['confirmations'] > 100;
          final List _voutAddrsList = _txList[txIndex]['vout'];
          for (var i = 0; i < _voutAddrsList.length; i++) {
            if (_voutAddrsList[i]['addresses'][0] == address) {
              tx.amount = _voutAddrsList[i]['value'];
            }
          }
        }

        txList.add(tx);
      }
    }

    return txList;
  }
}
