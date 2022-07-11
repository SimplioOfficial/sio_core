import 'dart:convert';

import 'package:http/http.dart';
import 'package:sio_core/src/utils_internal.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

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
  /// Get ATOM, LUNA, OSMO balance from mainnet.
  ///
  /// Works with REST api providers:
  /// * https://api-osmosis-chain.imperator.co/ for OSMO
  /// * did not find for the moment providers for LUNA and ATOM
  static Future<List<_Tx>> cosmos({
    required String address,
    required String apiEndpoint,
    required String denomination,
    String limit = '100',
    String offset = '0',
  }) async {
    const milliseconds = 1000;
    List<_Tx> txList = [];
    final request = await getRequest(apiEndpoint +
        'txs/v1/tx/address/' +
        address +
        '?type=cosmos.bank.v1beta1.MsgSend&limit=' +
        limit +
        '&offset=' +
        offset +
        '&decode=false');
    if (jsonDecode(request.body).runtimeType != List) {
      throw Exception(request.body);
    }
    final List _txList = jsonDecode(request.body);
    if (_txList.isEmpty) {
      return [];
    }
    for (var txIndex = 0; txIndex < _txList.length; txIndex++) {
      final Map<String, dynamic> _tx = _txList[txIndex]['tx_response'];
      var tx = _Tx(
        amount: _tx['tx']['body']['messages'][0]['amount'][0]['denom'] ==
                denomination
            ? _tx['tx']['body']['messages'][0]['amount'][0]['amount']
            : '0',
        txid: _tx['txhash'],
        networkFee:
            _tx['tx']['auth_info']['fee']['amount'][0]['denom'] == denomination
                ? _tx['tx']['auth_info']['fee']['amount'][0]['amount']
                : null,
        unixTime: (DateTime.parse(_tx['timestamp']).millisecondsSinceEpoch /
                milliseconds)
            .round(),
        confirmed: _tx['code'] == 0 ? true : false,
      );
      if (_tx['tx']['body']['messages'][0]['from_address'] == address) {
        tx.txType = TxType.send;
        tx.address = _tx['tx']['body']['messages'][0]['to_address'];
      }
      if (_tx['tx']['body']['messages'][0]['to_address'] == address &&
          tx.txType == null) {
        tx.txType = TxType.receive;
        tx.address = _tx['tx']['body']['messages'][0]['from_address'];
      }
      txList.add(tx);
    }
    return txList;
  }

  /// Get BNB (Smart Chain), ETC or ETH transactions from mainnet.
  ///
  /// Works with Blockbook:
  /// * https://bscxplorer.com/
  /// * https://etcblockexplorer.com/ or https://etc1.trezor.io/
  /// * https://ethblockexplorer.org/ or https://eth1.trezor.io/
  static Future<List<_Tx>> ethereumBlockbook({
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
          amount: _txList[txIndex]['vout'][0]['value'],
          txid: _txList[txIndex]['txid'],
          networkFee: _txList[txIndex]['fees'],
          unixTime: _txList[txIndex]['blockTime'],
          confirmed: _txList[txIndex]['confirmations'] > 0,
        );

        final List _vinAddrsList = _txList[txIndex]['vin'];
        final List _voutAddrsList = _txList[txIndex]['vout'];
        if (_vinAddrsList[0]['addresses'][0] == address) {
          tx.txType = TxType.send;
        }
        if (_voutAddrsList[0]['addresses'][0] == address && tx.txType == null) {
          tx.txType = TxType.receive;
        }

        if (tx.txType == TxType.send) {
          if (_voutAddrsList[0]['addresses'][0] != address) {
            tx.address = _voutAddrsList[0]['addresses'][0];
          } else {
            tx.address = address;
          }
        }
        if (tx.txType == TxType.receive) {
          if (_vinAddrsList[0]['addresses'][0] != address) {
            tx.address = _vinAddrsList[0]['addresses'][0];
          }
        }
        if (tx.txType != null) {
          txList.add(tx);
        }
      }
    }

    return txList;
  }

  /// Get BEP-20, ETC-20 or ERC-20 Token transactions from mainnet.
  ///
  /// Works with Blockbook:
  /// * https://bscxplorer.com/
  /// * https://etcblockexplorer.com/ or https://etc1.trezor.io/
  /// * https://ethblockexplorer.org/ or https://eth1.trezor.io/
  static Future<List<_Tx>> ethereumERC20Blockbook({
    required String address,
    required String contractAddress,
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
        transactions +
        '&contract=' +
        contractAddress);
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

        final List _tokenTransfers = _txList[txIndex]['tokenTransfers'];
        for (var tokenTxIndex = 0;
            tokenTxIndex < _tokenTransfers.length;
            tokenTxIndex++) {
          if (_tokenTransfers[tokenTxIndex]['token'] == contractAddress) {
            if (_tokenTransfers[tokenTxIndex]['from'] == address) {
              tx.txType = TxType.send;
              tx.amount = _tokenTransfers[tokenTxIndex]['value'];
              tx.address = _tokenTransfers[tokenTxIndex]['to'];
              break;
            }
            if (_tokenTransfers[tokenTxIndex]['to'] == address &&
                tx.txType == null) {
              tx.txType = TxType.receive;
              tx.amount = _tokenTransfers[tokenTxIndex]['value'];
              tx.address = _tokenTransfers[tokenTxIndex]['from'];
              break;
            }
          }
        }

        if (tx.txType != null) {
          txList.add(tx);
        }
      }
    }

    return txList;
  }

  /// Get AVAX (C-Chain), BNB (Smart Chain), ETH or MATIC transactions from mainnet.
  /// Works with https://api.snowtrace.io/, https://api.bscscan.com/, https://api.etherscan.com/ or https://polygonscan.com/.
  ///
  /// Use apiEndpoint like:
  /// * "https://api.snowtrace.io/api?module=account&action=txlist&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=YourApiKeyToken"
  /// * "https://api.bscscan.com/api?module=account&action=txlist&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=YourApiKeyToken"
  /// * "https://api.etherscan.com/api?module=account&action=txlist&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=YourApiKeyToken"
  /// * "https://api.polygonscan.com/api?module=account&action=txlist&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=YourApiKeyToken"
  static Future<List<_Tx>> ethereumScan({
    required String address,
    required String apiEndpoint,
    String startblock = '0',
    String endblock = '99999999',
    String page = '1',
    String transactions = '20',
  }) async {
    List<_Tx> txList = [];
    final request = await getRequest(
      apiEndpoint
          .replaceFirst('<address>', address)
          .replaceFirst('<startblock>', startblock)
          .replaceFirst('<endblock>', endblock)
          .replaceFirst('<page>', page)
          .replaceFirst('<transactions>', transactions),
    );
    if (jsonDecode(request.body)['status'] == '0' &&
        jsonDecode(request.body)['message'] == 'No transactions found') {
      return [];
    }
    if (jsonDecode(request.body)['status'] == '0') {
      throw Exception(jsonDecode(request.body)['result']);
    }

    if (jsonDecode(request.body)['result'] is List) {
      final List _txList = jsonDecode(request.body)['result'];
      for (var txIndex = 0; txIndex < _txList.length; txIndex++) {
        var tx = _Tx(
          txType: (_txList[txIndex]['from'] as String).toLowerCase() ==
                  address.toLowerCase()
              ? TxType.send
              : TxType.receive,
          amount: _txList[txIndex]['value'],
          txid: _txList[txIndex]['hash'],
          networkFee: (BigInt.parse(_txList[txIndex]['gasUsed']) *
                  BigInt.parse(_txList[txIndex]['gasPrice']))
              .toString(),
          unixTime: int.parse(_txList[txIndex]['timeStamp']),
          confirmed: int.parse(_txList[txIndex]['confirmations']) > 0,
        );

        if (tx.txType == TxType.send) {
          tx.address = _txList[txIndex]['to'];
        }
        if (tx.txType == TxType.receive) {
          tx.address = _txList[txIndex]['from'];
        }
        txList.add(tx);
      }
    }

    return txList;
  }

  /// Get BEP-20 or ERC-20 Token transactions from mainnet.
  /// Works with https://api.snowtrace.io/, https://api.bscscan.com/, https://api.etherscan.com/ or https://polygonscan.com/.
  ///
  /// Use apiEndpoint like:
  /// * "https://api.snowtrace.io/api?module=account&action=tokentx&contractaddress=<contractAddress>&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=YourApiKeyToken"
  /// * "https://api.bscscan.com/api?module=account&action=tokentx&contractaddress=<contractAddress>&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=YourApiKeyToken"
  /// * "https://api.etherscan.com/api?module=account&action=tokentx&contractaddress=<contractAddress>&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=YourApiKeyToken"
  /// * "https://api.polygonscan.com/api?module=account&action=tokentx&contractaddress=<contractAddress>&address=<address>&startblock=<startblock>&endblock=<endblock>&page=<page>&offset=<transactions>&sort=desc&apikey=YourApiKeyToken"
  static Future<List<_Tx>> ethereumERC20Scan({
    required String address,
    required String contractAddress,
    required String apiEndpoint,
    String startblock = '0',
    String endblock = '99999999',
    String page = '1',
    String transactions = '20',
  }) async {
    List<_Tx> txList = [];
    final request = await getRequest(
      apiEndpoint
          .replaceFirst('<address>', address)
          .replaceFirst('<contractAddress>', contractAddress)
          .replaceFirst('<startblock>', startblock)
          .replaceFirst('<endblock>', endblock)
          .replaceFirst('<page>', page)
          .replaceFirst('<transactions>', transactions),
    );
    if (jsonDecode(request.body)['status'] == '0' &&
        jsonDecode(request.body)['message'] == 'No transactions found') {
      return [];
    }
    if (jsonDecode(request.body)['status'] == '0') {
      throw Exception(jsonDecode(request.body)['result']);
    }

    if (jsonDecode(request.body)['result'] is List) {
      final List _txList = jsonDecode(request.body)['result'];
      for (var txIndex = 0; txIndex < _txList.length; txIndex++) {
        var tx = _Tx(
          txType: (_txList[txIndex]['from'] as String).toLowerCase() ==
                  address.toLowerCase()
              ? TxType.send
              : TxType.receive,
          amount: _txList[txIndex]['value'],
          txid: _txList[txIndex]['hash'],
          networkFee: (BigInt.parse(_txList[txIndex]['gasUsed']) *
                  BigInt.parse(_txList[txIndex]['gasPrice']))
              .toString(),
          unixTime: int.parse(_txList[txIndex]['timeStamp']),
          confirmed: int.parse(_txList[txIndex]['confirmations']) > 0,
        );

        if (tx.txType == TxType.send) {
          tx.address = _txList[txIndex]['to'];
        }
        if (tx.txType == TxType.receive) {
          tx.address = _txList[txIndex]['from'];
        }
        txList.add(tx);
      }
    }

    return txList;
  }

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
            // coverage:ignore-line
            _txList[txIndex]['confirmationStatus'] == 'confirmed',
      );
      txList.add(tx);
    }

    return txList;
  }

  /// Get Solana token transactions from mainnet, testnet, devnet
  /// depending on whatever apiEndpoint is used:
  /// * https://api.mainnet-beta.solana.com/
  /// * https://api.devnet.solana.com/
  static Future<List<_Tx>> solanaToken({
    required String address,
    required String tokenMintAddress,
    required String apiEndpoint,
    int txLimit = 1000,
  }) async {
    List<_Tx> txList = [];
    final solanaAddress = SolanaAddress.createWithString(address);
    final tokenAddress = solanaAddress.defaultTokenAddress(tokenMintAddress);
    final request = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": 1,
      "method": "getSignaturesForAddress",
      "params": [
        tokenAddress,
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
            // coverage:ignore-line
            _txList[txIndex]['confirmationStatus'] == 'confirmed',
      );
      txList.add(tx);
    }
    return txList;
  }

  /// Get BTC, BCH, DASH, DGB, DOGE, LTC, ZEC transactions from mainnet.
  ///
  /// Works with Blockbook:
  /// * https://btc1.simplio.io/ or https://btc1.trezor.io/
  /// * https://bch1.simplio.io/ or https://bch1.trezor.io/
  /// * https://dash1.simplio.io/ or https://dash1.trezor.io/
  /// * https://dgb1.simplio.io/ or https://dgb1.trezor.io/
  /// * https://doge1.simplio.io/ or https://doge1.trezor.io/
  /// * https://ltc1.simplio.io/ or https://ltc1.trezor.io/
  /// * https://zec1.simplio.io/ or https://zec1.trezor.io/
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
