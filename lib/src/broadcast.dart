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

  /// Send Bitcoin Cash on mainnet
  /// Works with Blockbook
  static Future<String> bitcoinCash({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast =
        await postRequest(apiEndpoint + 'api/v2/sendtx/', signedTxEncoded);

    return broadcast.body;
  }

  /// Send BNB Smart Chain on mainnet, testnet
  static Future<String> bnbSmartChain({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "eth_sendRawTransaction",
      "params": ["0x" + signedTxEncoded]
    });

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

  /// Send DigiByte on mainnet
  /// Works with Blockbook
  static Future<String> digibyte({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast =
        await postRequest(apiEndpoint + 'api/v2/sendtx/', signedTxEncoded);

    return broadcast.body;
  }

  /// Send Doge on mainnet
  /// Works with Blockbook
  static Future<String> doge({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast =
        await postRequest(apiEndpoint + 'api/v2/sendtx/', signedTxEncoded);

    return broadcast.body;
  }

  /// Send Flux on mainnet
  /// Works with Insight
  static Future<String> flux({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast = await postEncodedRequest(apiEndpoint + 'api/tx/send/', {
      "rawtx": signedTxEncoded,
    });

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

  /// Send Zcash on mainnet
  /// Works with Blockbook
  static Future<String> zcash({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast =
        await postRequest(apiEndpoint + 'api/v2/sendtx/', signedTxEncoded);

    return broadcast.body;
  }
}
