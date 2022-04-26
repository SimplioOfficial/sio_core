import 'dart:convert';

import 'package:sio_core/src/utils_internal.dart';

enum TxType {
  generate,
  send,
  receive,
}

class _Tx {
  final TxType? txType;
  final String? address;
  final String? amount;
  final String? txid;
  final String? networkFee;
  final int? unixTime;
  final bool? confirmed;
  final int? blockNumber;
  final String? txError;

  _Tx({
    this.txType,
    this.address,
    this.amount,
    this.txid,
    this.networkFee,
    this.unixTime,
    this.confirmed,
    this.blockNumber,
    this.txError,
  });

  Map<String, dynamic> toJson() {
    if (txError != null) {
      return {'txError': txError};
    } else {
      return {
        'txType': txType?.name,
        'address': address,
        'amount': amount,
        'txid': txid,
        'networkFee': networkFee,
        'unixTime': unixTime,
        'confirmed': confirmed,
        'blockNumber': blockNumber,
      };
    }
  }
}

/// Class that returns transaction object for different coins and tokens.
class GetTransactions {
  static Future<dynamic> litecoin({
    required String apiEndpoint,
    required String address,
  }) async {
    List<_Tx> txList = [];
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=txs');
    if (jsonDecode(request.body)['error'] != null) {
      final tx = _Tx(txError: jsonDecode(request.body)['error']);
      return tx;
    }
    if (jsonDecode(request.body)['txs'] == 0) {
      final tx = _Tx(txError: 'Address has no transactions');
      return tx;
    }

    if (jsonDecode(request.body)['transactions'] is List) {
      final List _txList = jsonDecode(request.body)['transactions'];
      for (var txIndex = 0; txIndex < _txList.length; txIndex++) {
        final tx = _Tx(
          txType: _txList[txIndex]['vin'][0]['isAddress'] == false
              ? TxType.generate
              : (_txList[txIndex]['vin'][0]['addresses'][0] == address
                  ? TxType.send
                  : TxType.receive),
          address: _txList[txIndex]['vin'][0]['isAddress'] == false
              ? _txList[txIndex]['vout'][0]['addresses'][0]
              : (_txList[txIndex]['vin'][0]['addresses'][0] == address
                  ? _txList[txIndex]['vout'][0]['addresses'][0]
                  : _txList[txIndex]['vin'][0]['addresses'][0]),
          amount: _txList[txIndex]['vout'][0]['value'],
          txid: _txList[txIndex]['txid'],
          unixTime: _txList[txIndex]['blockTime'],
          networkFee: _txList[txIndex]['fees'],
          blockNumber: _txList[txIndex]['blockHeight'],
          confirmed: _txList[txIndex]['confirmations'] > 0,
        );
        txList.add(tx);
      }
    }

    return txList;
  }
}
