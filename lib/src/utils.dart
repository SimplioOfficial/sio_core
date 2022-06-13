import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:http/http.dart';
import 'package:sio_core/src/utils_internal.dart';

class _CosmosAccountDetails {
  final String? accountNumber;
  final String? sequence;

  _CosmosAccountDetails({
    this.accountNumber,
    this.sequence,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'sequence': sequence,
    };
  }
}

/// Converts BigInt numbers into list of bytes.
///
/// Example:
/// * `12345678910111213141516171819202122232425 is converted to
/// [36, 71, 219, 69, 9, 146, 148, 96, 119, 231, 69, 190, 155, 124, 198, 50, 105]`
List<int> bigIntToBytes(BigInt number) {
  var inHex = number.toRadixString(16);
  if (inHex.length % 2 == 1) {
    inHex = '0' + inHex;
  }
  return hex.decode(inHex);
}

/// Class that helps returning multiple arguments needed to build a cosmos
/// transaction.
class UtilsCosmos {
  /// Get ATOM, LUNA, OSMO minimal denomination on mainnet.
  static String cosmosDenomination({
    required String ticker,
  }) {
    if (ticker == 'ATOM') return 'uatom';
    if (ticker == 'LUNA') return 'uluna';
    if (ticker == 'OSMO') return 'uosmo';
    throw Exception('coin TICKER is not supported');
  }

  /// Get the account details from a cosmos ecosystem address.
  /// The result can be parsed to get the account number and the sequence.
  ///
  /// Example:
  /// * https://lcd-osmosis.keplr.app/cosmos/auth/v1beta1/accounts/osmo1rlwemt45ryzc8ynakzwgfkltm7jy8lswpnfswn
  /// ```
  /// final request = await getCosmosAccountDetails(
  ///   address: 'osmo1rlwemt45ryzc8ynakzwgfkltm7jy8lswpnfswn',
  ///   apiEndpoint: 'https://lcd-osmosis.keplr.app/',
  /// );
  /// ```
  static Future<_CosmosAccountDetails> getCosmosAccountDetails({
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await getRequest(
        apiEndpoint + 'cosmos/auth/v1beta1/accounts/' + address);
    if (jsonDecode(request.body)['account'] == null) {
      throw Exception(request.body);
    }
    final cosmosAccountDetails = _CosmosAccountDetails(
      accountNumber: jsonDecode(request.body)['account']['account_number'],
      sequence: jsonDecode(request.body)['account']['sequence'],
    );
    return cosmosAccountDetails;
  }
}

/// Class that helps returning multiple arguments needed to build a ethereum
/// transaction.
class UtilsEthereum {
  /// Get the nonce of the specified address.
  /// Used for ethereum chains type.
  static Future<String> getNonce({
    required String address,
    required String apiEndpoint,
  }) async {
    final request = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "eth_getTransactionCount",
      "params": [address, "latest"]
    });
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }
    return jsonDecode(request.body)['result'];
  }
}

/// Class that helps returning multiple arguments needed to build a solana
/// transaction.
class UtilsSolana {
  /// Get the latest blockhash for solana transactions signing.
  /// Find more details at
  /// https://docs.solana.com/developing/clients/jsonrpc-api#getlatestblockhash
  static Future<String> latestBlockHashRequest({
    required String apiEndpoint,
  }) async {
    final request = await postEncodedRequest(apiEndpoint, {
      "jsonrpc": "2.0",
      "id": "1",
      "method": "getLatestBlockhash",
      "params": [
        {
          "commitment": "confirmed",
        }
      ]
    });
    if (jsonDecode(request.body)['error'] != null) {
      throw Exception(jsonDecode(request.body)['error']);
    }
    return jsonDecode(request.body)['result']['value']['blockhash'];
  }
}

/// Class that helps returning multiple arguments needed to build a utxoCoin
/// transaction.
class UtilsUtxo {
  /// Get the list of utxo for utxoCoin for blockbook or insight explorers.
  ///
  /// Example:
  /// * `apiEndpoint` as `https://ltc1.simplio.io/` or `https://explorer.runonflux.io/`
  ///
  /// `explorerType` argument is:
  /// * implicit (`blockbook`) for blockbook explorers
  /// * `insight` for insight explorers
  static Future<String> getUtxo({
    required String address,
    required String apiEndpoint,
    String explorerType = 'blockbook',
  }) async {
    late final Response request;
    if (explorerType == 'blockbook') {
      request = await getRequest(apiEndpoint + 'api/v2/utxo/' + address);
    } else if (explorerType == 'insight') {
      request = await getRequest(apiEndpoint + 'api/addr/' + address + '/utxo');
    } else {
      throw Exception('Invalid explorerType');
    }
    if (jsonDecode(request.body) is! List) {
      throw Exception(request.body);
    }
    return request.body;
  }
}
