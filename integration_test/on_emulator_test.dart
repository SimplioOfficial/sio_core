import 'dart:convert';

import 'package:bs58/bs58.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';
import 'package:sio_core/sio_core.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart' as trust_core;

void main() {
  trust_core.TrustWalletCoreLib.init();
  trust_core.HDWallet wallet;

  const mnemonic =
      'horror select baby exile convince sunset outside vehicle write decade powder energy';

  if (Mnemonic.isValid(mnemonic: mnemonic)) {
    wallet = Mnemonic.import(mnemonic: mnemonic);
  } else {
    throw Exception(['Mnemonic is not valid!']);
  }

  group('Mnemonic tests - ', () {
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

  group('Cosmos transaction tests - ', () {
    test('Osmosis', () {
      final signedOsmoTx = BuildTransaction.cosmos(
        wallet: wallet,
        coin: TWCoinType.TWCoinTypeOsmosis,
        amount: '10000',
        toAddress: 'osmo1qrhlvrqctv26vn6az7rnunredgy249sm9jt7us',
        chainId: 'osmosis-1',
        denomination: 'uosmo',
        accountNumber: '456069',
        sequence: '0',
        fee: '100',
        gas: '200000',
      );

      expect(jsonDecode(signedOsmoTx), isMap);
      expect(signedOsmoTx,
          '{"mode":"BROADCAST_MODE_BLOCK","tx_bytes":"Co0BCooBChwvY29zbW9zLmJhbmsudjFiZXRhMS5Nc2dTZW5kEmoKK29zbW8xcmx3ZW10NDVyeXpjOHluYWt6d2dma2x0bTdqeThsc3dwbmZzd24SK29zbW8xcXJobHZycWN0djI2dm42YXo3cm51bnJlZGd5MjQ5c205anQ3dXMaDgoFdW9zbW8SBTEwMDAwEmQKTgpGCh8vY29zbW9zLmNyeXB0by5zZWNwMjU2azEuUHViS2V5EiMKIQNPQtmB3SddtiaNalrHzaNlRZlTjV31pqIQZv4WvuRtKRIECgIIARISCgwKBXVvc21vEgMxMDAQwJoMGkDnEDf6YUI4aZ0zIGxnL1GFs/qdSg7q2ymGFm7M/M/BKFQlf8QUd6WZQ+J2D05t3N6xgclxVqPMCCdYm9bevc1e"}');
    });
  });

  group('Ethereum transaction tests - ', () {
    const toAddress = '0x3E26e7F73A80444e67b7bE654A38aB85ccb6ea47';
    const amount = '924400';
    const tokenContract = '0x26Fc591feCC4948c4288d95B6AAdAB00eBa4e72A';
    test('BSC native transaction', () {
      final signedBscTx = BuildTransaction.bnbSmartChain(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedBscTx).length, 110);
      expect(signedBscTx,
          'f86c8085032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a16000808194a0d2c6acce01755661bf4dceee0826d0b7962b018b7a298ec443ad5587e310baefa020a3ffd793ff276af6676bad45887551508c6e98eb07faa9d1bd29a1844f1f8b');
    });
    test('BSC token transaction', () {
      final signedBscTx = BuildTransaction.bnbSmartChainBEP20Token(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedBscTx).length, 171);
      expect(signedBscTx,
          'f8a98084d693a4008252089426fc591fecc4948c4288d95b6aadab00eba4e72a80b844a9059cbb0000000000000000000000003e26e7f73a80444e67b7be654a38ab85ccb6ea4700000000000000000000000000000000000000000000000000000000000e1af08194a0cad73e551edf5e537ee7bad6cdf3e5454c70566b6ea7471b4df4360c364087afa02cfcc1d078171ebc87fc36b725d50f172d9414e50c15c87f59508101b8ae40ea');
    });
    test('Ethereum native transaction', () {
      final signedEthTx = BuildTransaction.ethereum(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEthTx).length, 109);
      expect(signedEthTx,
          'f86b8085032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a160008026a002280d6ed62e1157127ef9a90dfb4b377697d36759e10a3015e33aa7e870ebd5a0483f537fb6c687dc29f60a0b9e861af09ce5d223d339c06c8b7af408277f487f');
    });
    test('Ethereum ERC20 token transaction', () {
      final signedEthTx = BuildTransaction.ethereumERC20Token(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEthTx).length, 170);
      expect(signedEthTx,
          'f8a88084d693a4008252089426fc591fecc4948c4288d95b6aadab00eba4e72a80b844a9059cbb0000000000000000000000003e26e7f73a80444e67b7be654a38ab85ccb6ea4700000000000000000000000000000000000000000000000000000000000e1af026a04dd4b00c74f726118d64219380a9bb1331ebeade4293f86cd6ef5fe930130804a05e8bf5a014cbff501f143aaa2d4f71bfe2fb9006f93755015229d881c6c8e940');
    });
    test('Ethereum Classic native transaction', () {
      final signedEtcTx = BuildTransaction.ethereumClassic(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEtcTx).length, 110);
      expect(signedEtcTx,
          'f86c8085032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a1600080819da00a977cf89f7a84522aa0a87f7504bbc3a18d0a87c8a2c030d96e89427846331ba07da98ce74f7a8214864ed0a4e4f018dbfe8c40518658be51fcfb987218b5f67e');
    });
  });

  group('Solana transactions tests - ', () {
    const toAddress = '3fTR8GGL2mniGyHtd3Qy2KDVhZ9LHbW59rCc7A3RtBWk';
    const tokenMintAddress = 'SioTkQxHyAs98ouRiyi1YDv3gLMSrX3eNBg61GH7NrM';
    const amount = '4000';
    const decimals = 8;
    test('Native transaction', () async {
      final signedSolanaTx = BuildTransaction.solana(
        wallet: wallet,
        recipient: toAddress,
        amount: amount,
        latestBlockHash: '11111111111111111111111111111111',
      );
      expect(base58.decode(signedSolanaTx).length, 215);
      expect(
          signedSolanaTx,
          equals(
              '3zWUJPKRuoYY39TFcezbAxEgnYQ6vdhxHrKR9AfHBwe1jqVeAEREwoSWC1JyuyayggHvMjBjpBzR4EGyAFeR4cYTDB2ivdKmRM56P2vEgZkmEAt57LTxwtVM1isG88Fo9fqkT14vnrkke1tRbD8ivG6BEwhDvYURy1Z9RyKe3QozAKcP28mUyaCeBdjd4LgvmyDNCvstDmT2DADeD6qYoZZHxVNGxpjnR7rQfuG8UgfNWcixZFJkQB7k5SkDE5GuTxZqnHy4M87QdvCc7qKWrGGnmD9j8sQeycJk7'));
    });
    test('Token transaction', () async {
      final signedSolanaTokenTx = BuildTransaction.solanaToken(
        wallet: wallet,
        recipientSolanaAddress: toAddress,
        tokenMintAddress: tokenMintAddress,
        amount: amount,
        decimals: decimals,
        latestBlockHash: '11111111111111111111111111111111',
      );
      expect(base58.decode(signedSolanaTokenTx).length, 279);
      expect(
          signedSolanaTokenTx,
          equals(
              'LMcrASBJnPkjYi5VWC4kjDSDUQ3yPruwqD3EQRH1o1nEEZUYvAvzfF2ZB8E1yL78zJPPCCMQUe9BpJpGR4YJ8Y7ZZ7x7N9KtJEQb9MbtgFaL3GdXvA41suG3KCckRXKwXikZhxgjUCASruE79H1bWZ5rqCCwAhv54SUobj1GvnFXtPaQu9iQG4mGJjEyy44ctBFJatbwBfXwZSKJBVXaYwkpdN2fZy3wZNPt9pFK9BF72n5C3s99Vc9CzrzM9tfE2TKjKE6CopYATdeb1qmVDYVxnj3ZdaJGp7RHP61sGhY21iHQt47E7naMtCSTkjxohUfcirTahTYAcbmZD3iwAKcYRmuCk5PaeSCnL42MYhEE5WsG97sWL5Gk9Nrj'));
    });
  });

  group('UtxoCoin transaction tests - ', () {
    test('No utxo available', () async {
      const coin = TWCoinType.TWCoinTypeDogecoin;
      const toAddress = 'DK3AhJvD57AfUqFCp5MUV62GE6K4enGxSw';
      const amount = '1005000';
      // https://doge1.simplio.io/api/v2/utxo/DTbELQaWmv5KpFcNpZ9X9wy5RjQGL4YMm2
      const utxoString = '[]';
      List utxo = jsonDecode(utxoString);
      try {
        BuildTransaction.utxoCoin(
          wallet: wallet,
          coin: coin,
          toAddress: toAddress,
          amount: amount,
          byteFee: '10',
          utxo: utxo,
        );
      } catch (exception) {
        expect(exception, isA<NoUtxoAvailableException>());
      }
    });
    test('Total amount < amount + estimated fee (1000 sats)', () async {
      const coin = TWCoinType.TWCoinTypeLitecoin;
      const toAddress = 'ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z';
      const amount = '38900';
      // https://ltc1.simplio.io/api/v2/utxo/ltc1qulzv02h8nmsuqxaqas3dv22cl244r7vs0smssh
      const utxoString =
          '[{"txid":"f873f455ded89ef7fc7eae62f9ef78c02814f28cf9501f871cbe576096ad9ef5","vout":0,"value":"29169","height":2252921,"confirmations":683},{"txid":"6e5da8e54a0d785a9c3ec9eb0848d14a4011782cf93491404599e0a4cb5a1c67","vout":0,"value":"10000","height":2252920,"confirmations":684}]';
      List utxo = jsonDecode(utxoString);
      try {
        BuildTransaction.utxoCoin(
          wallet: wallet,
          coin: coin,
          toAddress: toAddress,
          amount: amount,
          byteFee: '10',
          utxo: utxo,
        );
      } catch (exception) {
        expect(exception, isA<LowTotalAmountPLusFeeException>());
      }
    });
    test('Valid utxoCoin transaction', () async {
      const coin = TWCoinType.TWCoinTypeLitecoin;
      const toAddress = 'ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z';
      const amount = '25000';
      // https://ltc1.simplio.io/api/v2/utxo/ltc1qulzv02h8nmsuqxaqas3dv22cl244r7vs0smssh
      const utxoString =
          '[{"txid":"f873f455ded89ef7fc7eae62f9ef78c02814f28cf9501f871cbe576096ad9ef5","vout":0,"value":"29169","height":2252921,"confirmations":683},{"txid":"6e5da8e54a0d785a9c3ec9eb0848d14a4011782cf93491404599e0a4cb5a1c67","vout":0,"value":"10000","height":2252920,"confirmations":684}]';
      List utxo = jsonDecode(utxoString);

      final signedUtxoCoinTx = BuildTransaction.utxoCoin(
        wallet: wallet,
        coin: coin,
        toAddress: toAddress,
        amount: amount,
        byteFee: '10',
        utxo: utxo,
      );
      expect(hex.decode(signedUtxoCoinTx).length, 223);
      expect(signedUtxoCoinTx,
          '01000000000101f59ead966057be1c871f50f98cf21428c078eff962ae7efcf79ed8de55f473f800000000000000000002a861000000000000160014bb8ef6a40ab316da000090c989372ac48f233fd7c70a000000000000160014ac9a7a96a4e4fd16539f53b1fa062afe0dbd6ba902483045022100ad22e6db78e625ab2f1ee12e73222d1ddcab8cc6f3e4f806217bcf18dd74aca102201f013317e42e5a9c87e9a590045bdd209c60b41b052c08b3ecf3f33515df8244012102a91d09121aff91972942758b4e827f18c27305af2085459555f989fbf105d49600000000');
    });
    test('Valid utxoCoin transaction one additional utxo add', () async {
      const coin = TWCoinType.TWCoinTypeLitecoin;
      const toAddress = 'ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z';
      const amount = '9999';
      // https://ltc1.simplio.io/api/v2/utxo/ltc1qulzv02h8nmsuqxaqas3dv22cl244r7vs0smssh
      const utxoString =
          '[{"txid":"f873f455ded89ef7fc7eae62f9ef78c02814f28cf9501f871cbe576096ad9ef5","vout":0,"value":"29169","height":2252921,"confirmations":683},{"txid":"6e5da8e54a0d785a9c3ec9eb0848d14a4011782cf93491404599e0a4cb5a1c67","vout":0,"value":"10000","height":2252920,"confirmations":684}]';
      List utxo = jsonDecode(utxoString);

      final signedUtxoCoinTx = BuildTransaction.utxoCoin(
        wallet: wallet,
        coin: coin,
        toAddress: toAddress,
        amount: amount,
        byteFee: '10',
        utxo: utxo,
      );
      expect(hex.decode(signedUtxoCoinTx).length, 222);
      expect(signedUtxoCoinTx,
          '01000000000101f59ead966057be1c871f50f98cf21428c078eff962ae7efcf79ed8de55f473f8000000000000000000020f27000000000000160014bb8ef6a40ab316da000090c989372ac48f233fd76045000000000000160014ac9a7a96a4e4fd16539f53b1fa062afe0dbd6ba9024730440220044a1392212fb469afb6dfa71c9644eeaa8568d73cc50d08318e1994d5b929a402205251975b001f3be28d1186b3307d5d5361c25e4d9e94d50ec3342f5cce9692b4012102a91d09121aff91972942758b4e827f18c27305af2085459555f989fbf105d49600000000');
    });
  });

  group('Get transactions for Solana - ', () {
    group('Token - ', () {
      test('Normal transactions', () async {
        const address = '3fTR8GGL2mniGyHtd3Qy2KDVhZ9LHbW59rCc7A3RtBWk';
        const tokenMintAddress = '7udMmYXh6cuWVY6qQVCd9b429wDVn2J71r5BdxHkQADY';
        final transactions = await GetTransactions.solanaToken(
          apiEndpoint: 'https://api.mainnet-beta.solana.com/',
          address: address,
          tokenMintAddress: tokenMintAddress,
          txLimit: 1000,
        );
        final transactionsJson = transactions[transactions.length - 1].toJson();
        expect(transactionsJson, {
          "txType": null,
          "address": null,
          "amount": null,
          "txid":
              "3Hd7uCYjh9u5Wej4GF5eLQjwnkbeKjXoj9FbEvRK19LZCCDAt35rRaspZb43UEdwQU5M5ahPFbUaMhWsfrUb6Ts2",
          "networkFee": null,
          "unixTime": 1650368200,
          "confirmed": true
        });
      });
      test('No transactions', () async {
        const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJCu4f';
        const tokenMintAddress = '7udMmYXh6cuWVY6qQVCd9b429wDVn2J71r5BdxHkQADY';
        final transactions = await GetTransactions.solanaToken(
          apiEndpoint: 'https://api.mainnet-beta.solana.com/',
          address: address,
          tokenMintAddress: tokenMintAddress,
          txLimit: 1,
        );
        expect(transactions, []);
      });
      test('Error', () async {
        const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJCu4f';
        const tokenMintAddress = '7udMmYXh6cuWVY6qQVCd9b429wDVn2J71r5BdxHkQ';
        try {
          await GetTransactions.solanaToken(
            apiEndpoint: 'https://api.mainnet-beta.solana.com/',
            address: address,
            tokenMintAddress: tokenMintAddress,
          );
        } catch (exception) {
          expect(exception, isA<Exception>());
        }
      });
    });
  });
}
