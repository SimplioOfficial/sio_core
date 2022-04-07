import 'package:convert/convert.dart';
import 'package:sio_core/src/utils_internal.dart';

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

Future<String> getUtxo({
  required String apiEndpoint,
}) async {
  final request = await getRequest(apiEndpoint);
  return request.body;
}

List<int> bigIntToBytes(BigInt number) {
  var inHex = number.toRadixString(16);
  if (inHex.length % 2 == 1) {
    inHex = '0' + inHex;
  }
  return hex.decode(inHex);
}
