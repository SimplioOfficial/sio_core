import 'utils.dart';
import 'package:http/http.dart';

class Broadcast {
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
