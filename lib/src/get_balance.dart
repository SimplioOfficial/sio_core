import 'dart:convert';

import 'package:sio_core/src/utils_internal.dart';

<<<<<<< HEAD
/// Class that builds transactions and return OutputTx ready for broadcasting.
class GetBalance {
  /// Get ATOM, LUNA, OSMO balance from mainnet.
  ///
  /// Works with LCD api providers:
  /// * https://api.cosmos.network/
  /// * https://lcd.terra.dev/
  /// * https://lcd-osmosis.keplr.app/
  static Future<BigInt> cosmos({
=======
/// Class that returns the balance of different coins and tokens.
class GetBalance {
  /// Get Bitcoin balance from mainnet.
  /// Works with Blockbook.
  static Future<String> bitcoin({
    required String apiEndpoint,
    required String address,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    return request.body;
  }

  /// Get BNB Smart Chain balance from mainnet, testnet.
  /// Works with any rpc endpoints from
  /// https://docs.binance.org/smart-chain/developer/rpc.html
  static Future<String> bnbSmartChain({
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "eth_getBalance",
      "params": [address, "latest"]
    });
    return request.body;
  }

  /// Get BEP-20 Token balance from mainnet.
  /// Works with https://api.bscscan.com/
  /// Use apiEndpoint like "https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=YourApiKeyToken"
  static Future<String> bnbSmartChainBEP20Token({
    required String address,
    required String contractAddress,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(apiEndpoint
        .replaceFirst('<contractAddress>', contractAddress)
        .replaceFirst('<address>', address));
    return request.body;
  }

  /// Get Bitcoin Cash balance from mainnet.
  /// Works with Blockbook.
  static Future<String> bitcoinCash({
    required String apiEndpoint,
    required String address,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    return request.body;
  }

  /// Get Cosmos balance from mainnet.
  /// Works with LCD api providers.
  static Future<String> cosmos({
>>>>>>> fix: basic details in blockbook balance api
    required String address,
    required String apiEndpoint,
    required String denomination,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'cosmos/bank/v1beta1/balances/' + address);
<<<<<<< HEAD
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
=======
    return request.body;
  }

  /// Get Dash balance from mainnet.
  /// Works with Blockbook.
  static Future<String> dash({
    required String apiEndpoint,
    required String address,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    return request.body;
  }

  /// Get DigiByte balance from mainnet.
  /// Works with Blockbook.
  static Future<String> digibyte({
>>>>>>> fix: basic details in blockbook balance api
    required String apiEndpoint,
    required String address,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
<<<<<<< HEAD
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }

    return BigInt.parse(jsonDecode(request.body)['balance']);
=======
    return request.body;
  }

  /// Get Doge balance from mainnet.
  /// Works with Blockbook.
  static Future<String> doge({
    required String apiEndpoint,
    required String address,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    return request.body;
>>>>>>> fix: basic details in blockbook balance api
  }

  /// Get BNB (Smart Chain), ETC, ETH balance from mainnet, testnet.
  ///
  /// Works with any rpc endpoints from:
  /// * https://docs.binance.org/smart-chain/developer/rpc.html
  /// * https://www.ethercluster.com/etc
  /// * https://infura.io/
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

<<<<<<< HEAD
    return BigInt.parse(jsonDecode(request.body)['tokens'][0]['balance']);
=======
  /// Get Ethereum Classic balance from mainnet.
  /// Works with Blockbook.
  static Future<String> ethereumClassic({
    required String apiEndpoint,
    required String address,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    return request.body;
>>>>>>> fix: basic details in blockbook balance api
  }

  /// Get BEP-20 or ERC-20 Token balance from mainnet.
  /// Works with https://api.bscscan.com/ or https://api.etherscan.com/.
  ///
  /// Use apiEndpoint like:
  /// * "https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=YourApiKeyToken"
  /// * "https://api.etherscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=YourApiKeyToken"
  static Future<BigInt> ethereumERC20Scan({
    required String address,
    required String contractAddress,
    required String apiEndpoint,
  }) async {
<<<<<<< HEAD
    final request = await getRequest(apiEndpoint
        .replaceFirst('<contractAddress>', contractAddress)
        .replaceFirst('<address>', address));
    if (jsonDecode(request.body)['status'] == '0') {
      throw Exception(jsonDecode(request.body)['result']);
    }
=======
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    return request.body;
  }
>>>>>>> fix: basic details in blockbook balance api

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
    final List accounts = jsonDecode(request.body)['result']['value'];
    if (accounts.isEmpty) {
      return BigInt.zero;
    } else {
      return BigInt.parse(accounts[0]['account']['data']['parsed']['info']
          ['tokenAmount']['amount']);
    }
  }

  /// Get BTC, BCH, DASH, DGB, DOGE, LTC, ZEC balance from mainnet.
  ///
  /// Works with Blockbook:
  /// * https://btc1.simplio.io/
  /// * https://bch1.simplio.io/
  /// * https://dash1.simplio.io/
  /// * https://dgb1.simplio.io/
  /// * https://doge1.simplio.io/
  /// * https://ltc1.simplio.io/
  /// * https://zec1.simplio.io/
  static Future<BigInt> utxoCoinBlockbook({
    required String apiEndpoint,
    required String address,
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
    required String apiEndpoint,
    required String address,
  }) async {
<<<<<<< HEAD
    final request =
        await getRequest(apiEndpoint + 'api/addr/' + address + '/balance');

    return BigInt.parse(request.body);
=======
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    return request.body;
>>>>>>> fix: basic details in blockbook balance api
  }
}
