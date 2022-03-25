import 'package:test/test.dart';
import 'package:sio_core/sio_core.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart' as trust_core;

void main() {
  trust_core.TrustWalletCoreLib.init();
  trust_core.HDWallet wallet;

  const mnemonic =
      'rent craft script crucial item someone dream federal notice page shrug pipe young hover duty';

  if (Mnemonic.isValid(mnemonic: mnemonic)) {
    wallet = Mnemonic.import(mnemonic: mnemonic);
  } else {
    throw Exception(['Mnemonic is not valid!']);
  }

  group('Mnemonic tests', () {
    const mnemonic12Words =
        'rent craft script crucial item someone dream federal notice page shrug pipe young hover duty';
    const mnemonic24Words =
        'trouble sand fringe fox spatial film attract domain biology exchange twist audit nose raccoon steel warrior arrest nut card skirt uniform super make gloom';
    test('Mnemonic of 12 words is valid', () {
      expect(Mnemonic.isValid(mnemonic: mnemonic12Words), equals(true));
    });

    test('Mnemonic of 24 words is valid', () {
      expect(Mnemonic.isValid(mnemonic: mnemonic24Words), equals(true));
    });

    test('Generated mnemonic has 24 words', () {
      expect(Mnemonic().generate.split(' ').length, equals(24));
    });

    test('Import 12 seed mnemonic', () {
      expect(Mnemonic.import(mnemonic: mnemonic12Words).mnemonic(),
          equals(mnemonic12Words));
    });
    test('Import 24 seed mnemonic', () {
      expect(Mnemonic.import(mnemonic: mnemonic24Words).mnemonic(),
          equals(mnemonic24Words));
    });
  });

  group('Solana transactions tests', () {
    const toAddress = '3fTR8GGL2mniGyHtd3Qy2KDVhZ9LHbW59rCc7A3RtBWk';
    const tokenMintAddress = 'SioTkQxHyAs98ouRiyi1YDv3gLMSrX3eNBg61GH7NrM';
    const amount = '4000';
    const decimals = 8;
    const apiEndpoint = 'https://api.devnet.solana.com';

    test('Solana native transaction test', () async {
      final signedSolanaTx = await BuildTransaction.solana(
        wallet: wallet,
        recipient: toAddress,
        amount: amount,
        apiEndpoint: apiEndpoint,
        recentBlockHash: '11111111111111111111111111111111',
      );
      expect(
          signedSolanaTx,
          equals(
              '5kk72sm2ZR1BZAEy2ZFxLMEDS51is5GmNsxWa4NfiDUrWoWN6xTQLWp2ggjryhF5NCxeZK26QpmgH9a1iKucSXKsqV41W6ag3nek5nfDoybC9JFY3m4RSz3czwBZvtrpaCmC9Hk741Z8vW9iPNAQonZarcjfgYGkUb77SgsQTx5j42Pc7SmGcfePeEL31r5oHyp8zTFLK3HhxKcHE8SSQdsPy3adUoyA64fgPrgo6ysSZRwUipwMrH7zwLxcvz8ZLPXVktsBoLFWyRyFiptXxPgm8gWiDS2UVqm9Z'));
    });

    test('Solana token transaction test', () async {
      final signedSolanaTx = await BuildTransaction.solanaToken(
        wallet: wallet,
        recipientSolanaAddress: toAddress,
        tokenMintAddress: tokenMintAddress,
        amount: amount,
        decimals: decimals,
        apiEndpoint: apiEndpoint,
        recentBlockHash: '11111111111111111111111111111111',
      );
      expect(
          signedSolanaTx,
          equals(
              'UjrxQHLaUPAfYxKH1h3CzQEELRAPtpBUhW7Z9D3cSkHP8MMHZsP2evQ7ERsYsxDTKPeoZgUmvsurMEeKuNG1YqZ48VYvohpj326V9P4mHZCrWvx5UJY8sKsaRoMfKTepacUhYo41fsPASy2qgfzXXTaFJZsFrPPoaxjaWEcWqm9WbRU9BnCt8WxxhPusphGP9c4VYkM6YLqQLicxuHQSxfWfACkD7TDcuSfC9kejqGA8LCyb4db4mqB112spfJmkjQgPQELhaxGkTY1rYBphRLbtv2YCVUDeRazHaSmvadgnBXKgo9a2VLXqvH4UCsvy7YB96Y5qgoAC63PUGNSVTCEPE7Ebqfee2JR9CMbuGLezs9TRWsAakvwSHRAF'));
    });
  });
}
