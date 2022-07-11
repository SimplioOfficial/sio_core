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

class _CosmosFeeDetails {
  final String? chainId;
  final String? gas;
  final String? minFee;

  _CosmosFeeDetails({
    this.chainId,
    this.gas,
    this.minFee,
  });

  Map<String, dynamic> toJson() {
    return {
      'chainId': chainId,
      'gas': gas,
      'minFee': minFee,
    };
  }
}

class _EthereumFeeDetails {
  final String? safeGasPrice;
  final String? proposeGasPrice;
  final String? fastGasPrice;
  final String? safeMaxInclusionFeePerGas;
  final String? proposeMaxInclusionFeePerGas;
  final String? fastMaxInclusionFeePerGas;
  final String? safeMaxFeePerGas;
  final String? proposeMaxFeePerGas;
  final String? fastMaxFeePerGas;
  final String? gasLimit;

  _EthereumFeeDetails({
    this.safeGasPrice,
    this.proposeGasPrice,
    this.fastGasPrice,
    this.safeMaxInclusionFeePerGas,
    this.proposeMaxInclusionFeePerGas,
    this.fastMaxInclusionFeePerGas,
    this.safeMaxFeePerGas,
    this.proposeMaxFeePerGas,
    this.fastMaxFeePerGas,
    this.gasLimit,
  });

  Map<String, dynamic> toJson() {
    return {
      'safeGasPrice': safeGasPrice,
      'proposeGasPrice': proposeGasPrice,
      'fastGasPrice': fastGasPrice,
      'safeMaxInclusionFeePerGas': safeMaxInclusionFeePerGas,
      'proposeMaxInclusionFeePerGas': proposeMaxInclusionFeePerGas,
      'fastMaxInclusionFeePerGas': fastMaxInclusionFeePerGas,
      'safeMaxFeePerGas': safeMaxFeePerGas,
      'proposeMaxFeePerGas': proposeMaxFeePerGas,
      'fastMaxFeePerGas': fastMaxFeePerGas,
      'gasLimit': gasLimit,
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
    if (ticker == 'atom') return 'uatom';
    if (ticker == 'luna') return 'uluna';
    if (ticker == 'osmo') return 'uosmo';
    throw Exception('coin ticker is not supported');
  }

  /// Get the account details for a cosmos ecosystem address.
  /// The result is an object that contains `accountNumber` and `sequence`.
  ///
  /// Example:
  /// * https://lcd-osmosis.keplr.app/cosmos/auth/v1beta1/accounts/osmo1rlwemt45ryzc8ynakzwgfkltm7jy8lswpnfswn
  /// ```
  /// final request = await UtilsCosmos.getCosmosAccountDetails(
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

  /// Get the fee details for a cosmos ecosystem blockchain.
  /// The result is an object that contains the `chainId`, `minFee` and `gas`.
  ///
  /// Example:
  /// * http://fees.amitabha.xyz/cosmos
  /// ```
  /// final request = await UtilsCosmos.getCosmosFeeDetails(
  ///   apiEndpoint: 'http://fees.amitabha.xyz/',
  ///   ticker: 'atom',
  /// );
  /// ```
  static Future<_CosmosFeeDetails> getCosmosFeeDetails({
    required String apiEndpoint,
    required String ticker,
  }) async {
    final request = await getRequest(apiEndpoint + 'cosmos');
    if (jsonDecode(request.body)[ticker] == null) {
      throw Exception('Ticker not supported! Details:' + request.body);
    }
    final cosmosFeeDetails = _CosmosFeeDetails(
      chainId: jsonDecode(request.body)[ticker]['chainId'],
      gas: jsonDecode(request.body)[ticker]['gas'],
      minFee: jsonDecode(request.body)[ticker]['minFee'],
    );
    return cosmosFeeDetails;
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

  /// Get the legacy fee details for an ethereum type blockchain.
  /// The result is an object that contains the `safeGasPrice`,
  /// `proposeGasPrice`, `fastGasPrice` and `gasLimit`.
  ///
  /// Legacy chains supported: BSC, ETC
  ///
  /// Example:
  /// * http://fees.amitabha.xyz/ethereum
  /// ```
  /// final request = await UtilsEthereum.getEthereumFeeDetails(
  ///   apiEndpoint: 'http://fees.amitabha.xyz/',
  ///   ticker: 'bsc',
  /// );
  /// ```
  static Future<_EthereumFeeDetails> getEthereumFeeDetailsLegacy({
    required String apiEndpoint,
    required String ticker,
  }) async {
    final request = await getRequest(apiEndpoint + 'ethereum');
    if (jsonDecode(request.body)[ticker] == null) {
      throw Exception('Ticker not supported! Details:' + request.body);
    }
    final ethereumFeeDetails = _EthereumFeeDetails(
      safeGasPrice: jsonDecode(request.body)[ticker]['safeGasPrice'],
      proposeGasPrice: jsonDecode(request.body)[ticker]['proposeGasPrice'],
      fastGasPrice: jsonDecode(request.body)[ticker]['fastGasPrice'],
      gasLimit: jsonDecode(request.body)[ticker]['gasLimit'],
    );
    return ethereumFeeDetails;
  }

  /// Get the EIP-1559 fee details for an ethereum type blockchain.
  /// The result is an object that contains the `safeMaxInclusionFeePerGas`,
  /// `proposeMaxInclusionFeePerGas`, `fastMaxInclusionFeePerGas`,
  /// `safeMaxFeePerGas`, `proposeMaxFeePerGas`, `fastMaxFeePerGas`
  /// and `gasLimit`.
  ///
  /// EIP-1559 chains supported: AVAX, ETH, MATIC
  ///
  /// Example:
  /// * http://fees.amitabha.xyz/ethereum
  /// ```
  /// final request = await UtilsEthereum.getEthereumFeeDetails(
  ///   apiEndpoint: 'http://fees.amitabha.xyz/',
  ///   ticker: 'eth',
  /// );
  /// ```
  static Future<_EthereumFeeDetails> getEthereumFeeDetailsEIP1559({
    required String apiEndpoint,
    required String ticker,
  }) async {
    final request = await getRequest(apiEndpoint + 'ethereum');
    if (jsonDecode(request.body)[ticker] == null) {
      throw Exception('Ticker not supported! Details:' + request.body);
    }
    final ethereumFeeDetails = _EthereumFeeDetails(
      safeMaxInclusionFeePerGas: jsonDecode(request.body)[ticker]
          ['safeMaxInclusionFeePerGas'],
      proposeMaxInclusionFeePerGas: jsonDecode(request.body)[ticker]
          ['proposeMaxInclusionFeePerGas'],
      fastMaxInclusionFeePerGas: jsonDecode(request.body)[ticker]
          ['fastMaxInclusionFeePerGas'],
      safeMaxFeePerGas: jsonDecode(request.body)[ticker]['safeMaxFeePerGas'],
      proposeMaxFeePerGas: jsonDecode(request.body)[ticker]
          ['proposeMaxFeePerGas'],
      fastMaxFeePerGas: jsonDecode(request.body)[ticker]['fastMaxFeePerGas'],
      gasLimit: jsonDecode(request.body)[ticker]['gasLimit'],
    );
    return ethereumFeeDetails;
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

  /// Get the `fee` for solana blockchain.
  ///
  /// Example:
  /// * http://fees.amitabha.xyz/solana
  /// ```
  /// final request = await UtilsSolana.getSolanaFee(
  ///   apiEndpoint: 'http://fees.amitabha.xyz/',
  /// );
  /// ```
  static Future<String> getSolanaFee(
      {required String apiEndpoint,
      String ending = 'solana' // used for tests and coverage only.
      }) async {
    final request = await getRequest(apiEndpoint + ending);
    if (jsonDecode(request.body)['sol'] == null) {
      throw Exception(
          'There is an error with apiEndpoint! Details:' + request.body);
    }
    return jsonDecode(request.body)['sol']['fee'];
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

  /// Get the `minFee` for an utxoCoin type blockchain.
  ///
  /// Example:
  /// * http://fees.amitabha.xyz/utxoCoins
  /// ```
  /// final request = await UtilsUtxo.getUtxoCoinFee(
  ///   apiEndpoint: 'http://fees.amitabha.xyz/',
  ///   ticker: 'btc',
  /// );
  /// ```
  static Future<String> getUtxoCoinFee({
    required String apiEndpoint,
    required String ticker,
  }) async {
    final request = await getRequest(apiEndpoint + 'utxoCoins');
    if (jsonDecode(request.body)[ticker] == null) {
      throw Exception('Ticker not supported! Details:' + request.body);
    }
    return jsonDecode(request.body)[ticker]['minFee'];
  }
}
