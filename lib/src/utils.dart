import 'package:convert/convert.dart';
import 'package:sio_core/src/utils_internal.dart';

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

/// Get ATOM, LUNA, OSMO minimal denomination on mainnet.
String cosmosDenomination({
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
Future<String> getCosmosAccountDetails({
  required String address,
  required String apiEndpoint,
}) async {
  final request =
      await getRequest(apiEndpoint + 'cosmos/auth/v1beta1/accounts/' + address);
  return request.body;
}

/// Get the nonce of the specified address.
/// Used for ethereum chains type.
Future<String> getNonce({
  required String address,
  required String apiEndpoint,
}) async {
  final request = await postEncodedRequest(apiEndpoint, {
    "jsonrpc": "2.0",
    "id": "1",
    "method": "eth_getTransactionCount",
    "params": [address, "latest"]
  });
  return request.body;
}

/// Get the list of utxo for utxoCoin.
///
/// Example:
/// * https://ltc1.simplio.io/api/v2/utxo/ltc1q4jd8494yun73v5ul2wcl5p32lcxm66afx4efr6 for blockbook
/// * https://explorer.runonflux.io/api/addr/t1amMB14YTcUktfjHrz42XcDb2tdHmjgMQd/utxo for insight
Future<String> getUtxo({
  required String apiEndpoint,
}) async {
  final request = await getRequest(apiEndpoint);
  return request.body;
}

/// Get the latest blockhash for solana transactions signing.
/// Find more details at
/// https://docs.solana.com/developing/clients/jsonrpc-api#getlatestblockhash
Future<String> latestBlockHashRequest({
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
  return request.body;
}
