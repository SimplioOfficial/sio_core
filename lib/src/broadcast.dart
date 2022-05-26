import 'dart:convert';

import 'package:sio_core/src/utils_internal.dart';

/// Class that broadcast messages into different platforms.
class Broadcast {
  /// Broadcast ATOM, LUNA, OSMO transactions on mainnet.
  ///
  /// Works with LCD api providers:
  /// * https://api.cosmos.network/
  /// * https://lcd.terra.dev/
  /// * https://lcd-osmosis.keplr.app/
  static Future<String> cosmos({
    required String signedTxSerialized,
    required String apiEndpoint,
  }) async {
    final broadcast = await postRequest(
        apiEndpoint + 'cosmos/tx/v1beta1/txs', signedTxSerialized);

    if (jsonDecode(broadcast.body)['tx_response']['code'] != 0) {
      throw Exception(jsonDecode(broadcast.body)['tx_response']['raw_log']);
    }
    return jsonDecode(broadcast.body)['tx_response']['txhash'];
  }

  /// Broadcast BNB (Smart Chain), ETC or ETH transactions on mainnet.
  ///
  /// Works with Blockbook:
  /// * https://bscxplorer.com/
  /// * https://etcblockexplorer.com/ or https://etc1.trezor.io/
  /// * https://ethblockexplorer.org/ or https://eth1.trezor.io/
  static Future<String> ethereumBlockbook({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast =
        await getRequest(apiEndpoint + 'api/v2/sendtx/0x' + signedTxEncoded);

    if (jsonDecode(broadcast.body)['error'] != null) {
      throw Exception(jsonDecode(broadcast.body)['error']);
    }
    return jsonDecode(broadcast.body)['result'];
  }

  /// Broadcast BNB (Smart Chain), ETC, ETH transactions on mainnet, testnet.
  ///
  /// Works with any rpc endpoints from:
  /// * https://docs.binance.org/smart-chain/developer/rpc.html
  /// * https://www.ethercluster.com/etc
  /// * https://infura.io/
  static Future<String> ethereumRPC({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "eth_sendRawTransaction",
      "params": ["0x" + signedTxEncoded]
    });

    if (jsonDecode(broadcast.body)['error'] != null) {
      throw Exception(jsonDecode(broadcast.body)['error']);
    }
    return jsonDecode(broadcast.body)['result'];
  }

  /// Broadcast Solana and Solana Tokens transactions into mainnet, testnet,
  /// devnet depending on whatever apiEndpoint is used:
  /// * https://api.mainnet-beta.solana.com/
  /// * https://api.devnet.solana.com/
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

    if (jsonDecode(broadcast.body)['error'] != null) {
      throw Exception(jsonDecode(broadcast.body)['error']);
    }
    return jsonDecode(broadcast.body)['result'];
  }

  /// Broadcast BTC, BCH, DASH, DGB, DOGE, LTC, ZEC transactions on mainnet.
  ///
  /// Works with Blockbook.
  /// * https://btc1.simplio.io/ or https://btc1.trezor.io/
  /// * https://bch1.simplio.io/ or https://bch1.trezor.io/
  /// * https://dash1.simplio.io/ or https://dash1.trezor.io/
  /// * https://dgb1.simplio.io/ or https://dgb1.trezor.io/
  /// * https://doge1.simplio.io/ or https://doge1.trezor.io/
  /// * https://ltc1.simplio.io/ or https://ltc1.trezor.io/
  /// * https://zec1.simplio.io/ or https://zec1.trezor.io/
  static Future<String> utxoCoinBlockbook({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast =
        await postRequest(apiEndpoint + 'api/v2/sendtx/', signedTxEncoded);

    if (jsonDecode(broadcast.body)['error'] != null) {
      throw Exception(jsonDecode(broadcast.body)['error']);
    }
    return jsonDecode(broadcast.body)['result'];
  }

  /// Broadcast FLUX transactions on mainnet.
  ///
  /// Works with Insight:
  /// * https://explorer.runonflux.io/
  static Future<String> utxoCoinInsight({
    required String signedTxEncoded,
    required String apiEndpoint,
  }) async {
    final broadcast = await postEncodedRequest(apiEndpoint + 'api/tx/send/', {
      "rawtx": signedTxEncoded,
    });

    return jsonDecode(broadcast.body)['txid'];
  }
}
