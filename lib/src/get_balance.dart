import 'package:sio_core/src/utils_internal.dart';

class GetBalance {
  /// Get Bitcoin balance from mainnet
  /// Works with Blockbook
  static Future<String> bitcoin({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get Bitcoin balance from mainnet
  /// Works with Blockbook
  static Future<String> bitcoinCash({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get Bitcoin balance from mainnet
  /// Works with Blockbook
  static Future<String> dash({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get Bitcoin balance from mainnet
  /// Works with Blockbook
  static Future<String> digibyte({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get Bitcoin balance from mainnet
  /// Works with Blockbook
  static Future<String> doge({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get Bitcoin balance from mainnet
  /// Works with Insight
  // static Future<String> flux({
  //   required String apiEndpoint,
  //   required String address,
  // }) async {
  //   final response =
  //       await getRequest(apiEndpoint + 'api/v2/address/' + address);
  //   return response.body;
  // }

  /// Get Bitcoin balance from mainnet
  /// Works with Blockbook
  static Future<String> litecoin({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }

  /// Get Bitcoin balance from mainnet
  /// Works with Blockbook
  static Future<String> zcash({
    required String apiEndpoint,
    required String address,
  }) async {
    final response =
        await getRequest(apiEndpoint + 'api/v2/address/' + address);
    return response.body;
  }
}
