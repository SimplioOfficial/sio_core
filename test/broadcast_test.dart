import 'dart:convert';

import 'package:test/test.dart';
import 'package:sio_core/sio_core.dart';

void main() {
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
}
