import 'dart:convert';

import 'package:sio_core/src/utils_internal.dart';

/// Class that returns decimals number for different coins and tokens.
class GetDecimals {
  /// Get ATOM, LUNA, OSMO decimals on mainnet.
  static int cosmos({
    required String ticker,
  }) {
    if (ticker == 'ATOM') return 6;
    if (ticker == 'LUNA') return 6;
    if (ticker == 'OSMO') return 6;
    throw Exception('coin TICKER is not supported');
  }

  /// Get BNB (Smart Chain - BSC), ETC or ETH decimals on mainnet.
  static int ethereum({
    required String ticker,
  }) {
    if (ticker == 'BSC') return 18;
    if (ticker == 'ETC') return 18;
    if (ticker == 'ETH') return 18;
    throw Exception('coin TICKER is not supported');
  }

  /// Get BEP-20, ETC-20 or ERC-20 Token decimals on mainnet.
  ///
  /// Works with Blockbook:
  /// * https://bscxplorer.com/
  /// * https://etcblockexplorer.com/ or https://etc1.trezor.io/
  /// * https://ethblockexplorer.org/ or https://eth1.trezor.io/
  static Future<int> ethereumERC20Blockbook({
    required String contractAddress,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(apiEndpoint +
        'api/v2/address/0xEA674fdDe714fd979de3EdF0F56AA9716B898ec8?details=tokens:basic&pageSize=1&contract=' +
        contractAddress);
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }
    if (jsonDecode(request.body)['tokens'][0]['decimals'] == null) {
      throw Exception(
          'contractAddress not recognized. Check if it is correct.');
    }
    return jsonDecode(request.body)['tokens'][0]['decimals'];
  }

  /// Get SOL decimals on mainnet, testnet, devnet.
  static int get solana {
    return 9;
  }

  /// Get SLP specific Token decimals on mainnet, testnet, devnet
  /// depending on whatever apiEndpoint is used:
  /// * https://api.mainnet-beta.solana.com/
  /// * https://api.devnet.solana.com/.
  static Future<int> solanaToken({
    required String tokenMintAddress,
    required String apiEndpoint,
  }) async {
    final request = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "getTokenSupply",
      "params": [tokenMintAddress],
    });
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }
    return jsonDecode(request.body)['result']['value']['decimals'];
  }

  /// Get BTC, BCH, DASH, DGB, DOGE, FLUX, LTC, ZEC balance from mainnet.
  static int utxoCoin({
    required String ticker,
  }) {
    if (ticker == 'BTC') return 8;
    if (ticker == 'BCH') return 8;
    if (ticker == 'DASH') return 8;
    if (ticker == 'DGB') return 8;
    if (ticker == 'DOGE') return 8;
    if (ticker == 'FLUX') return 8;
    if (ticker == 'LTC') return 8;
    if (ticker == 'ZEC') return 8;
    throw Exception('coin TICKER is not supported');
  }
}