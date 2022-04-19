import 'package:sio_core/src/utils_internal.dart';

class GetBalance {
  /// Get Bitcoin balance from mainnet.
  /// Works with Blockbook.
  static Future<String> bitcoin({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get BNB Smart Chain balance from mainnet, testnet.
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

  /// Get Bitcoin Cash balance from mainnet.
  /// Works with Blockbook.
  static Future<String> bitcoinCash({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
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
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get DigiByte balance from mainnet.
  /// Works with Blockbook.
  static Future<String> digibyte({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get Doge balance from mainnet.
  /// Works with Blockbook.
  static Future<String> doge({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get Ethereum balance from mainnet, testnet.
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

  /// Get Ethereum Classic balance from mainnet.
  /// Works with Blockbook.
  static Future<String> ethereumClassic({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get Flux balance from mainnet.
  /// Works with Insight.
  static Future<String> flux({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/addr/' + address + '/balance');
    return response.body;
  }

  /// Get Litecoin balance from mainnet.
  /// Works with Blockbook.
  static Future<String> litecoin({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
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
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }
}
