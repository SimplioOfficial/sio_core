import 'package:sio_core/src/utils_internal.dart';

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
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'cosmos/bank/v1beta1/balances/' + address);
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
    required String apiEndpoint,
    required String address,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
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
  }

  /// Get Ethereum balance from mainnet, testnet.
  /// Works with any RPC endpoint like
  /// https://infura.io/
  static Future<String> ethereum({
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

  /// Get ERC-20 Token balance from mainnet.
  /// Works with https://api.etherscan.com/
  /// Use apiEndpoint like "https://api.etherscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=YourApiKeyToken"
  static Future<String> ethereumERC20Token({
    required String address,
    required String contractAddress,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(apiEndpoint
        .replaceFirst('<contractAddress>', contractAddress)
        .replaceFirst('<address>', address));
    return request.body;
  }

  /// Get Ethereum Classic balance from mainnet.
  /// Works with Blockbook.
  static Future<String> ethereumClassic({
    required String apiEndpoint,
    required String address,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    return request.body;
  }

  /// Get Flux balance from mainnet.
  /// Works with Insight.
  static Future<String> flux({
    required String apiEndpoint,
    required String address,
  }) async {
    final request =
        await getRequest(apiEndpoint + 'api/addr/' + address + '/balance');
    return request.body;
  }

  /// Get Litecoin balance from mainnet.
  /// Works with Blockbook.
  static Future<String> litecoin({
    required String apiEndpoint,
    required String address,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    return request.body;
  }

  /// Get Osmosis balance from mainnet.
  /// Works with LCD api providers.
  static Future<String> osmosis({
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'cosmos/bank/v1beta1/balances/' + address);
    return request.body;
  }

  /// Get Solana balance from mainnet, testnet, devnet
  /// depending on whatever apiEndpoint is used.
  static Future<String> solana({
    required String address,
    required String apiEndpoint,
  }) async {
    final broadcast = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "getBalance",
      "params": [address]
    });

    return broadcast.body;
  }

  /// Get All Solana Tokens balance  for an address from
  /// mainnet, testnet, devnet depending on whatever apiEndpoint is used.
  static Future<String> solanaAllTokens({
    required String address,
    required String apiEndpoint,
  }) async {
    final broadcast = await postEncodedRequest(apiEndpoint, {
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

    return broadcast.body;
  }

  /// Get Solana specific Token balance for an address from
  /// mainnet, testnet, devnet depending on whatever apiEndpoint is used.
  static Future<String> solanaToken({
    required String address,
    required String tokenMintAddress,
    required String apiEndpoint,
  }) async {
    final broadcast = await postEncodedRequest(apiEndpoint, {
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

    return broadcast.body;
  }

  /// Get Terra balance from mainnet.
  /// Works with LCD api providers.
  static Future<String> terra({
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'cosmos/bank/v1beta1/balances/' + address);
    return request.body;
  }

  /// Get Zcash balance from mainnet.
  /// Works with Blockbook.
  static Future<String> zcash({
    required String apiEndpoint,
    required String address,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'api/v2/address/' + address + '?details=basic');
    return request.body;
  }
}
