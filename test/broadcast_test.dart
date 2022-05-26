import 'dart:convert';

import 'package:test/test.dart';
import 'package:sio_core/sio_core.dart';

void main() {
  group('Broadcast Cosmos coin - ', () {
    test('Cosmos', () async {
      const signedTxSerialized =
          '{"mode":"BROADCAST_MODE_BLOCK","tx_bytes":"CpABCo0BChwvY29zbW9zLmJhbmsudjFiZXRhMS5Nc2dTZW5kEm0KLWNvc21vczFybHdlbXQ0NXJ5emM4eW5ha3p3Z2ZrbHRtN2p5OGxzd2ZnNnFjcBItY29zbW9zMXFyaGx2cnFjdHYyNnZuNmF6N3JudW5yZWRneTI0OXNtZGZjdzJ6Gg0KBXVhdG9tEgQ3ODAwEmYKUApGCh8vY29zbW9zLmNyeXB0by5zZWNwMjU2azEuUHViS2V5EiMKIQNPQtmB3SddtiaNalrHzaNlRZlTjV31pqIQZv4WvuRtKRIECgIIARgFEhIKDAoFdWF0b20SAzEwMBDAmgwaQJgniD4nTl+vgx/Y7Pb6jY4UVDynjYYpUbN1WSpLU7E+UMmvtiYl8kB7Ss++2KdYNeq8DSbReetUocfujUUtY1c="}';
      try {
        await Broadcast.cosmos(
          signedTxSerialized: signedTxSerialized,
          apiEndpoint: 'https://api.cosmos.network/',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Osmosis', () async {
      const signedTxSerialized =
          '{"mode":"BROADCAST_MODE_BLOCK","tx_bytes":"CowBCokBChwvY29zbW9zLmJhbmsudjFiZXRhMS5Nc2dTZW5kEmkKK29zbW8xcmx3ZW10NDVyeXpjOHluYWt6d2dma2x0bTdqeThsc3dwbmZzd24SK29zbW8xcXJobHZycWN0djI2dm42YXo3cm51bnJlZGd5MjQ5c205anQ3dXMaDQoFdW9zbW8SBDc4MDASZgpQCkYKHy9jb3Ntb3MuY3J5cHRvLnNlY3AyNTZrMS5QdWJLZXkSIwohA09C2YHdJ122Jo1qWsfNo2VFmVONXfWmohBm/ha+5G0pEgQKAggBGAUSEgoMCgV1b3NtbxIDMTAwEMCaDBpA1aGulU+jYUpCcA3eQ0dWYTt8qsDH/MNIZbenQj+cwvtVfD+RCWJ2ndhC2sEwVOjD5fenq93mK3/8xylj6jMyGg=="}';
      try {
        await Broadcast.cosmos(
          signedTxSerialized: signedTxSerialized,
          apiEndpoint: 'https://lcd-osmosis.keplr.app/',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Terra', () async {
      const signedTxSerialized =
          '{"mode":"BROADCAST_MODE_BLOCK","tx_bytes":"Co4BCosBChwvY29zbW9zLmJhbmsudjFiZXRhMS5Nc2dTZW5kEmsKLHRlcnJhMXJ2YTlhNzB4YzN2cHZkZXpuNjBqZXJ6NHl3cWE1dWV5N25lZnBzEix0ZXJyYTFzdmM2M3l4d2xxdjJjcG16bWEwZWhjODh6a2Zwa25yYWw5ajZhNBoNCgV1bHVuYRIENzgwMBJmClAKRgofL2Nvc21vcy5jcnlwdG8uc2VjcDI1NmsxLlB1YktleRIjCiEDYPiVIhGbxRWKBJ2ly5K2TpgPeQJfiPaVjTZ/KGjQvA0SBAoCCAEYBRISCgwKBXVsdW5hEgMxMDAQwJoMGkB7eQSdCXKSHMC1fzFDWX3aE3tw0IapUvMpq71GbyiZdg23yDhNMwSnXEc8M8CF5B+QL+pKTXMv09ANe6d+StMP"}';
      try {
        await Broadcast.cosmos(
          signedTxSerialized: signedTxSerialized,
          apiEndpoint: 'https://lcd.terra.dev/',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
  });

  group('Broadcast Ethereum coin - ', () {
    test('BNB Smart Chain', () async {
      const signedTxEncoded =
          'f86c0385032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea4787234230709be0008081e5a0e873a5e71069a59d7e652f9ac4cd667274cb7cdd356e3644601e811ac0105a10a0735e2cef7b1274dc72e1d5c90b3864f270c4cb0a5be90a8c337b4eeee56f8179';
      try {
        await Broadcast.ethereumRPC(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://bsc-dataseed.binance.org/',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Ethereum', () async {
      const signedTxEncoded =
          'f86b8085032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a160008026a002280d6ed62e1157127ef9a90dfb4b377697d36759e10a3015e33aa7e870ebd5a0483f537fb6c687dc29f60a0b9e861af09ce5d223d339c06c8b7af408277f487f';
      try {
        await Broadcast.ethereumRPC(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint:
              'https://mainnet.infura.io/v3/d0b366367e6d4a1b97b2d844397ca182',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Ethereum Classic', () async {
      const signedTxEncoded =
          'f86c8085032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a1600080819da00a977cf89f7a84522aa0a87f7504bbc3a18d0a87c8a2c030d96e89427846331ba07da98ce74f7a8214864ed0a4e4f018dbfe8c40518658be51fcfb987218b5f67e';
      try {
        await Broadcast.ethereumBlockbook(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://etcblockexplorer.com/',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
  });

  test('Broadcast solana', () async {
    const signedTxEncoded =
        '4vEk1KnknS8YGWD8y5L8LtacJauYv7XKo7UtrBHuAGDLKnxQ39eiLjGwrDcKDXPyv1bNX9Y8jgZ5AtAFdiWn6aanYsGqfjArv1ZGdySmwEHDd4d5UZ2vo5LxZHu5bEU5gXxC1VMV4n3C1fXqb7DNt7h9aNyRnoRYzCe76FvxtewQQZ7uuxtGsArKyRufCfpse5d7J1sdMhucW7E7Ab3m46rooUm3BboGDaf5qiEZCgsfbdPfUQJHXFwrZFMGrVXkMvzWVkdHdBZHeAU2nbfznJiinEtkE9x3bEGMu';
    try {
      await Broadcast.solana(
          signedTxEncoded: signedTxEncoded,
          apiEndpoint: 'https://api.devnet.solana.com/');
    } catch (exception) {
      expect(exception, isA<Exception>());
    }
  });

  group('Broadcast utxo coin - ', () {
    test('Bitcoin', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      try {
        await Broadcast.utxoCoinBlockbook(
            signedTxEncoded: signedTxEncoded,
            apiEndpoint: 'https://btc1.simplio.io/');
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Bitcoin Cash', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      try {
        await Broadcast.utxoCoinBlockbook(
            signedTxEncoded: signedTxEncoded,
            apiEndpoint: 'https://bch1.trezor.io/');
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Dash', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      try {
        await Broadcast.utxoCoinBlockbook(
            signedTxEncoded: signedTxEncoded,
            apiEndpoint: 'https://dash1.simplio.io/');
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('DigiByte', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      try {
        await Broadcast.utxoCoinBlockbook(
            signedTxEncoded: signedTxEncoded,
            apiEndpoint: 'https://dgb1.simplio.io/');
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Doge', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      try {
        await Broadcast.utxoCoinBlockbook(
            signedTxEncoded: signedTxEncoded,
            apiEndpoint: 'https://doge1.simplio.io/');
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Flux', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      try {
        await Broadcast.utxoCoinInsight(
            signedTxEncoded: signedTxEncoded,
            apiEndpoint: 'https://explorer.runonflux.io/');
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Litecoin', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      try {
        await Broadcast.utxoCoinBlockbook(
            signedTxEncoded: signedTxEncoded,
            apiEndpoint: 'https://ltc1.simplio.io/');
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Zcash', () async {
      const signedTxEncoded =
          '0100000000010345e866343b494d89af0b75d15b56959e35280be401ee735920bba6a0c131436e';
      try {
        await Broadcast.utxoCoinBlockbook(
            signedTxEncoded: signedTxEncoded,
            apiEndpoint: 'https://zec1.simplio.io/');
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
  });
}
