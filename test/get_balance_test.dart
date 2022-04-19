import 'dart:convert';

import 'package:test/test.dart';
import 'package:sio_core/src/get_balance.dart';

void main() {
  group('Get balance for cosmos coin - ', () {
    test('Cosmos', () async {
      const address = 'cosmos1rlwemt45ryzc8ynakzwgfkltm7jy8lswfg6qcp';
      final response = await GetBalance.cosmos(
        address: address,
        apiEndpoint: 'https://api.cosmos.network/',
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['balances'], []);
    });
    test('Osmosis', () async {
      const address = 'osmo1rlwemt45ryzc8ynakzwgfkltm7jy8lswpnfswn';
      final response = await GetBalance.osmosis(
        address: address,
        apiEndpoint: 'https://lcd-osmosis.keplr.app/',
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['balances'], []);
    });
    test('Terra', () async {
      const address = 'terra1rva9a70xc3vpvdezn60jerz4ywqa5uey7nefps';
      final response = await GetBalance.terra(
        address: address,
        apiEndpoint: 'https://lcd.terra.dev/',
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['balances'], []);
    });
  });
  group('Get balance for utxoCoin - ', () {
    test('Bitcoin', () async {
      const address = 'bc1qwquauyfgqgwh2gc9td8dhrf00432duh77wvxy5';
      final response = await GetBalance.bitcoin(
        apiEndpoint: 'https://btc1.simplio.io/',
        address: address,
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['balance'], '0');
    });
    test('Bitcoin Cash', () async {
      const address = 'bitcoincash:qphjd0f4jeg9naf29u6tkakv800wgksyhvsamcpdd2';
      final response = await GetBalance.bitcoinCash(
        apiEndpoint: 'https://bch1.simplio.io/',
        address: address,
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['balance'], '0');
    });
    test('Dash', () async {
      const address = 'XgbeASTQTNgPuTyAWb8NVDWVDmhgKJrfRV';
      final response = await GetBalance.dash(
        apiEndpoint: 'https://dash1.simplio.io/',
        address: address,
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['balance'], '0');
    });
    test('DigiByte', () async {
      const address = 'dgb1qshqfysjmxpl0dv5ryjeg8k4tkdp2pfk6k0gvdq';
      final response = await GetBalance.digibyte(
        apiEndpoint: 'https://dgb1.simplio.io/',
        address: address,
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['balance'], '0');
    });
    test('Doge', () async {
      const address = 'DTbELQaWmv5KpFcNpZ9X9wy5RjQGL4YMm2';
      final response = await GetBalance.doge(
        apiEndpoint: 'https://doge1.simplio.io/',
        address: address,
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['balance'], '0');
    });
    test('Flux', () async {
      const address = 't1amMB14YTcUktfjHrz42XcDb2tdHmjgMQd';
      final response = await GetBalance.flux(
        apiEndpoint: 'https://explorer.runonflux.io/',
        address: address,
      );
      expect(jsonDecode(response), 0);
    });
    test('Litecoin', () async {
      const address = 'ltc1q4jd8494yun73v5ul2wcl5p32lcxm66afx4efr6';
      final response = await GetBalance.litecoin(
        apiEndpoint: 'https://ltc1.simplio.io/',
        address: address,
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['balance'], '39169');
    });
    test('Zcash', () async {
      const address = 't1RTNMRyJhc1UgfvrTSqFP46C5xuyxjJGeR';
      final response = await GetBalance.zcash(
        apiEndpoint: 'https://zec1.simplio.io/',
        address: address,
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['balance'], '0');
    });
  });
}
