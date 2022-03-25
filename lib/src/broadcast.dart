import 'utils.dart';
import 'package:http/http.dart';

/// Class that broadcast messages into different platforms
class Broadcast {
  /// Send Solana and Solana Tokens into mainnet, testnet, devnet
  /// depending on whatever apiEndpoint is used.
  static Future<String> solana(
      {required String signedTxEncoded, required String apiEndpoint}) async {
    Response broadcast = await createRequest("https://api.devnet.solana.com", {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "sendTransaction",
      "params": [signedTxEncoded]
    });

    return broadcast.body;
  }
}
