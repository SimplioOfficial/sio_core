import 'dart:convert';

import 'package:test/test.dart';
import 'package:sio_core/sio_core.dart';

void main() {
  test('Broadcast BNB Smart Chain', () async {
    const signedTxEncoded =
        'f86c0385032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea4787234230709be0008081e5a0e873a5e71069a59d7e652f9ac4cd667274cb7cdd356e3644601e811ac0105a10a0735e2cef7b1274dc72e1d5c90b3864f270c4cb0a5be90a8c337b4eeee56f8179';
    final response = await Broadcast.bnbSmartChain(
      signedTxEncoded: signedTxEncoded,
      apiEndpoint: 'https://data-seed-prebsc-1-s1.binance.org:8545/',
    );
    expect(jsonDecode(response), isMap);
    expect(jsonDecode(response)["error"]["code"], -32000);
  });

  test('Broadcast solana', () async {
    const signedTxEncoded =
        '4vEk1KnknS8YGWD8y5L8LtacJauYv7XKo7UtrBHuAGDLKnxQ39eiLjGwrDcKDXPyv1bNX9Y8jgZ5AtAFdiWn6aanYsGqfjArv1ZGdySmwEHDd4d5UZ2vo5LxZHu5bEU5gXxC1VMV4n3C1fXqb7DNt7h9aNyRnoRYzCe76FvxtewQQZ7uuxtGsArKyRufCfpse5d7J1sdMhucW7E7Ab3m46rooUm3BboGDaf5qiEZCgsfbdPfUQJHXFwrZFMGrVXkMvzWVkdHdBZHeAU2nbfznJiinEtkE9x3bEGMu';
    final response = await Broadcast.solana(
        signedTxEncoded: signedTxEncoded,
        apiEndpoint: 'https://api.devnet.solana.com/');
    expect(jsonDecode(response)["error"]["code"], equals(-32002));
    expect(
      jsonDecode(response)["error"]["message"],
      equals('Transaction simulation failed: Blockhash not found'),
    );
  });

  group('Broadcast utxo coin - ', () {
    test('Bitcoin', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      final response = await Broadcast.bitcoin(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://btc1.simplio.io/');
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['error'], contains('-22'));
    });

    test('Bitcoin Cash', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      final response = await Broadcast.bitcoinCash(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://bch1.simplio.io/');
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['error'], contains('-22'));
    });

    test('Dash', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      final response = await Broadcast.dash(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://dash1.simplio.io/');
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['error'], contains('-22'));
    });

    test('DigiByte', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      final response = await Broadcast.digibyte(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://dgb1.simplio.io/');
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['error'], contains('-22'));
    });

    test('Doge', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      final response = await Broadcast.doge(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://doge1.simplio.io/');
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['error'], contains('-22'));
    });

    test('Flux', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      final response = await Broadcast.flux(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://explorer.runonflux.io/');
      expect(response, 'TX decode failed. Code:-22');
    });

    test('Litecoin', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      final response = await Broadcast.litecoin(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://ltc1.simplio.io/');
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['error'], contains('-22'));
    });

    test('Zcash', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      final response = await Broadcast.zcash(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://zec1.simplio.io/');
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['error'], contains('-22'));
    });
  });
}
