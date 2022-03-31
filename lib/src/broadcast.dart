import 'utils.dart';

/// Class that broadcast messages into different platforms
class Broadcast {
  /// Send Bitcoin on mainnet
  /// Works with Blockbook
  static Future<String> bitcoin({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast =
        await postRequest(apiEndpoint + 'api/v2/sendtx/', signedTxEncoded);

    return broadcast.body;
  }

  /// Send Dash on mainnet
  /// Works with Blockbook
  static Future<String> dash({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast =
        await postRequest(apiEndpoint + 'api/v2/sendtx/', signedTxEncoded);

    return broadcast.body;
  }

  /// Send Litecoin on mainnet
  /// Works with Blockbook
  static Future<String> litecoin({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast =
        await postRequest(apiEndpoint + 'api/v2/sendtx/', signedTxEncoded);

    return broadcast.body;
  }

  /// Send Solana and Solana Tokens into mainnet, testnet, devnet
  /// depending on whatever apiEndpoint is used.
  static Future<String> solana({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "sendTransaction",
      "params": [signedTxEncoded]
    });

    return broadcast.body;
  }
}
