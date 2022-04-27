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
    test('BSC native transaction length', () {
      final signedBscTx = BuildTransaction.bnbSmartChain(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedBscTx).length, 110);
    });
    test('BSC native transaction hash', () {
      final signedBscTx = BuildTransaction.bnbSmartChain(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(signedBscTx,
          'f86c8085032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a16000808194a0d2c6acce01755661bf4dceee0826d0b7962b018b7a298ec443ad5587e310baefa020a3ffd793ff276af6676bad45887551508c6e98eb07faa9d1bd29a1844f1f8b');
    });
    test('BSC token transaction length', () {
      final signedBscTx = BuildTransaction.bnbSmartChainBEP20Token(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedBscTx).length, 171);
    });
    test('BSC token transaction hash', () {
      final signedBscTx = BuildTransaction.bnbSmartChainBEP20Token(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(signedBscTx,
          'f8a98084d693a4008252089426fc591fecc4948c4288d95b6aadab00eba4e72a80b844a9059cbb0000000000000000000000003e26e7f73a80444e67b7be654a38ab85ccb6ea4700000000000000000000000000000000000000000000000000000000000e1af08194a0cad73e551edf5e537ee7bad6cdf3e5454c70566b6ea7471b4df4360c364087afa02cfcc1d078171ebc87fc36b725d50f172d9414e50c15c87f59508101b8ae40ea');
    });
    test('Ethereum native transaction length', () {
      final signedEthTx = BuildTransaction.ethereum(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEthTx).length, 109);
    });
    test('Ethereum native transaction hash', () {
      final signedEthTx = BuildTransaction.ethereum(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(signedEthTx,
          'f86b8085032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a160008026a002280d6ed62e1157127ef9a90dfb4b377697d36759e10a3015e33aa7e870ebd5a0483f537fb6c687dc29f60a0b9e861af09ce5d223d339c06c8b7af408277f487f');
    });
    test('Ethereum ERC20 token transaction length', () {
      final signedEthTx = BuildTransaction.ethereumERC20Token(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEthTx).length, 170);
    });
    test('Ethereum ERC20 token transaction hash', () {
      final signedEthTx = BuildTransaction.ethereumERC20Token(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(signedEthTx,
          'f8a88084d693a4008252089426fc591fecc4948c4288d95b6aadab00eba4e72a80b844a9059cbb0000000000000000000000003e26e7f73a80444e67b7be654a38ab85ccb6ea4700000000000000000000000000000000000000000000000000000000000e1af026a04dd4b00c74f726118d64219380a9bb1331ebeade4293f86cd6ef5fe930130804a05e8bf5a014cbff501f143aaa2d4f71bfe2fb9006f93755015229d881c6c8e940');
    });
    test('Ethereum Classic native transaction length', () {
      final signedEtcTx = BuildTransaction.ethereumClassic(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEtcTx).length, 110);
    });
    test('Ethereum Classic native transaction hash', () {
      final signedEtcTx = BuildTransaction.ethereumClassic(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(signedEtcTx,
          'f86c8085032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a1600080819da00a977cf89f7a84522aa0a87f7504bbc3a18d0a87c8a2c030d96e89427846331ba07da98ce74f7a8214864ed0a4e4f018dbfe8c40518658be51fcfb987218b5f67e');
    });
  });

  group('Solana transactions tests - ', () {
    const toAddress = '3fTR8GGL2mniGyHtd3Qy2KDVhZ9LHbW59rCc7A3RtBWk';
    const tokenMintAddress = 'SioTkQxHyAs98ouRiyi1YDv3gLMSrX3eNBg61GH7NrM';
    const amount = '4000';
    const decimals = 8;
    const apiEndpoint = 'https://api.devnet.solana.com';
    test('Solana native transaction length', () async {
      final response = await latestBlockHashRequest(apiEndpoint: apiEndpoint);
      final latestBlockHash =
          jsonDecode(response)["result"]["value"]["blockhash"];

      final signedSolanaTx = BuildTransaction.solana(
        wallet: wallet,
        recipient: toAddress,
        amount: amount,
        latestBlockHash: latestBlockHash,
      );
      expect(base58.decode(signedSolanaTx).length, 215);
    });
    test('Solana native transaction hash', () {
      final signedSolanaTx = BuildTransaction.solana(
        wallet: wallet,
        recipient: toAddress,
        amount: amount,
        latestBlockHash: '11111111111111111111111111111111',
      );
      expect(
          signedSolanaTx,
          equals(
              '3zWUJPKRuoYY39TFcezbAxEgnYQ6vdhxHrKR9AfHBwe1jqVeAEREwoSWC1JyuyayggHvMjBjpBzR4EGyAFeR4cYTDB2ivdKmRM56P2vEgZkmEAt57LTxwtVM1isG88Fo9fqkT14vnrkke1tRbD8ivG6BEwhDvYURy1Z9RyKe3QozAKcP28mUyaCeBdjd4LgvmyDNCvstDmT2DADeD6qYoZZHxVNGxpjnR7rQfuG8UgfNWcixZFJkQB7k5SkDE5GuTxZqnHy4M87QdvCc7qKWrGGnmD9j8sQeycJk7'));
    });
    test('Solana token transaction length', () async {
      final response = await latestBlockHashRequest(apiEndpoint: apiEndpoint);
      final latestBlockHash =
          jsonDecode(response)["result"]["value"]["blockhash"];
      final signedSolanaTokenTx = BuildTransaction.solanaToken(
        wallet: wallet,
        recipientSolanaAddress: toAddress,
        tokenMintAddress: tokenMintAddress,
        amount: amount,
        decimals: decimals,
        latestBlockHash: latestBlockHash,
      );
      expect(base58.decode(signedSolanaTokenTx).length, 279);
    });
    test('Solana token transaction hash', () {
      final signedSolanaTokenTx = BuildTransaction.solanaToken(
        wallet: wallet,
        recipientSolanaAddress: toAddress,
        tokenMintAddress: tokenMintAddress,
        amount: amount,
        decimals: decimals,
        latestBlockHash: '11111111111111111111111111111111',
      );
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
      const apiEndpoint = 'https://doge1.simplio.io/';
      final utxoString = await getUtxo(
          apiEndpoint:
              apiEndpoint + 'api/v2/utxo/' + wallet.getAddressForCoin(coin));
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
      const apiEndpoint = 'https://ltc1.simplio.io/';
      final utxoString = await getUtxo(
          apiEndpoint: apiEndpoint +
              'api/v2/utxo/' +
              'ltc1qulzv02h8nmsuqxaqas3dv22cl244r7vs0smssh');
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
      const apiEndpoint = 'https://ltc1.simplio.io/';
      final utxoString = await getUtxo(
          apiEndpoint: apiEndpoint +
              'api/v2/utxo/' +
              'ltc1qulzv02h8nmsuqxaqas3dv22cl244r7vs0smssh');
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
    });
    test('Valid utxoCoin transaction one additional utxo add', () async {
      const coin = TWCoinType.TWCoinTypeLitecoin;
      const toAddress = 'ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z';
      const amount = '9999';
      const apiEndpoint = 'https://ltc1.simplio.io/';
      final utxoString = await getUtxo(
          apiEndpoint: apiEndpoint +
              'api/v2/utxo/' +
              'ltc1qulzv02h8nmsuqxaqas3dv22cl244r7vs0smssh');
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
    });
  });
}
