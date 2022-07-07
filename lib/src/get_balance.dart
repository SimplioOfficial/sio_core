import 'dart:convert';

import 'package:sio_core/src/utils_internal.dart';

/// Class that builds transactions and return OutputTx ready for broadcasting.
class GetBalance {
  /// Get ATOM, LUNA, OSMO balance from mainnet.
  ///
  /// Works with LCD api providers:
  /// * https://api.cosmos.network/
  /// * https://lcd.terra.dev/
  /// * https://lcd-osmosis.keplr.app/
  static Future<BigInt> cosmos({
    required String address,
    required String apiEndpoint,
    required String denomination,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'cosmos/bank/v1beta1/balances/' + address);
    if (jsonDecode(request.body)['balances'] == null) {
      throw Exception(request.body);
    }
    final List balances = jsonDecode(request.body)['balances'];
    var balance = '0';
    if (balances.isEmpty) {
      return BigInt.zero;
    } else {
      for (var i = 0; i < balances.length; i++) {
        if (balances[i]['denom'] == denomination) {
          return BigInt.parse(
              jsonDecode(request.body)['balances'][i]['amount']);
        }
      }
    }

    return BigInt.parse(balance);
  }

  /// Get BNB (Smart Chain), ETC or ETH balance from mainnet.
  ///
  /// Works with Blockbook:
  /// * https://bscxplorer.com/
  /// * https://etcblockexplorer.com/ or https://etc1.trezor.io/
  /// * https://ethblockexplorer.org/ or https://eth1.trezor.io/
  static Future<BigInt> ethereumBlockbook({
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }

    return BigInt.parse(jsonDecode(request.body)['balance']);
  }

  /// Get AVAX (C-Chain), BNB (Smart Chain), ETC, ETH, MATIC balance from mainnet, testnet.
  ///
  /// Works with any rpc endpoints from:
  /// * https://api.avax.network/ext/bc/C/rpc
  /// * https://bsc-dataseed.binance.org/
  /// * https://www.ethercluster.com/etc
  /// * https://infura.io/
  /// * https://polygon-rpc.com/
  static Future<BigInt> ethereumRPC({
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "eth_getBalance",
      "params": [address, "latest"]
    });
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }

    return BigInt.parse(jsonDecode(request.body)['result']);
  }

  /// Get BEP-20, ETC-20 or ERC-20 Token balance from mainnet.
  ///
  /// Works with Blockbook:
  /// * https://bscxplorer.com/
  /// * https://etcblockexplorer.com/ or https://etc1.trezor.io/
  /// * https://ethblockexplorer.org/ or https://eth1.trezor.io/
  static Future<BigInt> ethereumERC20Blockbook({
    required String address,
    required String contractAddress,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(apiEndpoint +
        'api/v2/address/' +
        address +
        '?details=tokenBalances:basic&contract=' +
        contractAddress);
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }
    if (jsonDecode(request.body)['tokens'][0]['balance'] == null) {
      return BigInt.zero;
    }

    return BigInt.parse(jsonDecode(request.body)['tokens'][0]['balance']);
  }

  /// Get BEP-20 or ERC-20 Token balance from mainnet.
  /// Works with https://api.snowtrace.io/, https://api.bscscan.com/, https://api.etherscan.com/ or https://polygonscan.com/.
  ///
  /// Use apiEndpoint like:
  /// * "https://api.snowtrace.io/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=YourApiKeyToken"
  /// * "https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=YourApiKeyToken"
  /// * "https://api.etherscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=YourApiKeyToken"
  /// * "https://api.polygonscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=YourApiKeyToken"
  static Future<BigInt> ethereumERC20Scan({
    required String address,
    required String contractAddress,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(apiEndpoint
        .replaceFirst('<contractAddress>', contractAddress)
        .replaceFirst('<address>', address));
    if (jsonDecode(request.body)['status'] == '0') {
      throw Exception(jsonDecode(request.body)['result']);
    }

    return BigInt.parse(jsonDecode(request.body)['result']);
  }

  /// Get Solana balance from mainnet, testnet, devnet
  /// depending on whatever apiEndpoint is used:
  /// * https://api.mainnet-beta.solana.com/
  /// * https://api.devnet.solana.com/
  static Future<BigInt> solana({
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "getBalance",
      "params": [address]
    });
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }

    return BigInt.from(jsonDecode(request.body)['result']['value']);
  }

  /// Get All Solana Tokens balance  for an address from
  /// mainnet, testnet, devnet depending on whatever apiEndpoint is used.
  ///
  /// Returns the full object for the moment. Result will be parsed later
  /// after the scope is set.
  static Future<String> solanaAllTokens({
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "getTokenAccountsByOwner",
      "params": [
        address,
        {
          "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
        },
        {
          "encoding": "jsonParsed",
        },
      ],
    });

    return request.body;
  }

  /// Get Solana specific Token balance for an address from
  /// mainnet, testnet, devnet depending on whatever apiEndpoint is used:
  /// * https://api.mainnet-beta.solana.com/
  /// * https://api.devnet.solana.com/
  static Future<BigInt> solanaToken({
    required String address,
    required String tokenMintAddress,
    required String apiEndpoint,
  }) async {
    final request = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "getTokenAccountsByOwner",
      "params": [
        address,
        {
          "mint": tokenMintAddress,
        },
        {
          "encoding": "jsonParsed",
        },
      ],
    });

    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }
    final List account = jsonDecode(request.body)['result']['value'];
    if (account.isEmpty) {
      return BigInt.zero;
    } else {
      return BigInt.parse(account[0]['account']['data']['parsed']['info']
          ['tokenAmount']['amount']);
    }
  }

  /// Get BTC, BCH, DASH, DGB, DOGE, LTC, ZEC balance from mainnet.
  ///
  /// Works with Blockbook:
  /// * https://btc1.simplio.io/ or https://btc1.trezor.io/
  /// * https://bch1.simplio.io/ or https://bch1.trezor.io/
  /// * https://dash1.simplio.io/ or https://dash1.trezor.io/
  /// * https://dgb1.simplio.io/ or https://dgb1.trezor.io/
  /// * https://doge1.simplio.io/ or https://doge1.trezor.io/
  /// * https://ltc1.simplio.io/ or https://ltc1.trezor.io/
  /// * https://zec1.simplio.io/ or https://zec1.trezor.io/
  static Future<BigInt> utxoCoinBlockbook({
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }

    return BigInt.parse(jsonDecode(request.body)['balance']);
  }

  /// Get FLUX balance from mainnet.
  ///
  /// Works with Insight:
  /// * https://explorer.runonflux.io/
  static Future<BigInt> utxoCoinInsight({
    required String address,
    required String apiEndpoint,
  }) async {
    final request =
        await getRequest(apiEndpoint + 'api/addr/' + address + '/balance');

    return BigInt.parse(request.body);
  }
}
