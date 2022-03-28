import 'utils.dart';

/// Class that broadcast messages into different platforms
class Broadcast {
  /// Send Solana and Solana Tokens into mainnet, testnet, devnet
  /// depending on whatever apiEndpoint is used.
  static Future<String> solana({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast = await createRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "sendTransaction",
      "params": [signedTxEncoded]
    });

    return broadcast.body;
  }
}
