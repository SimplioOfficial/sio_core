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

      expect(signedOsmoTx.toJson(), {
        'txid':
            '{"mode":"BROADCAST_MODE_BLOCK","tx_bytes":"Co0BCooBChwvY29zbW9zLmJhbmsudjFiZXRhMS5Nc2dTZW5kEmoKK29zbW8xcmx3ZW10NDVyeXpjOHluYWt6d2dma2x0bTdqeThsc3dwbmZzd24SK29zbW8xcXJobHZycWN0djI2dm42YXo3cm51bnJlZGd5MjQ5c205anQ3dXMaDgoFdW9zbW8SBTEwMDAwEmQKTgpGCh8vY29zbW9zLmNyeXB0by5zZWNwMjU2azEuUHViS2V5EiMKIQNPQtmB3SddtiaNalrHzaNlRZlTjV31pqIQZv4WvuRtKRIECgIIARISCgwKBXVvc21vEgMxMDAQwJoMGkDnEDf6YUI4aZ0zIGxnL1GFs/qdSg7q2ymGFm7M/M/BKFQlf8QUd6WZQ+J2D05t3N6xgclxVqPMCCdYm9bevc1e"}',
        'networkFee': '100'
      });
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
      expect(hex.decode(signedBscTx.rawTx as String).length, 110);
      expect(signedBscTx.toJson(), {
        'txid':
            'f86c8085032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a16000808194a0d2c6acce01755661bf4dceee0826d0b7962b018b7a298ec443ad5587e310baefa020a3ffd793ff276af6676bad45887551508c6e98eb07faa9d1bd29a1844f1f8b',
        'networkFee': '285600000000000'
      });
    });
    test('BSC token transaction', () {
      final signedBscTx = BuildTransaction.bnbSmartChainBEP20Token(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedBscTx.rawTx as String).length, 171);
      expect(signedBscTx.toJson(), {
        'txid':
            'f8a98084d693a4008252089426fc591fecc4948c4288d95b6aadab00eba4e72a80b844a9059cbb0000000000000000000000003e26e7f73a80444e67b7be654a38ab85ccb6ea4700000000000000000000000000000000000000000000000000000000000e1af08194a0cad73e551edf5e537ee7bad6cdf3e5454c70566b6ea7471b4df4360c364087afa02cfcc1d078171ebc87fc36b725d50f172d9414e50c15c87f59508101b8ae40ea',
        'networkFee': '75600000000000'
      });
    });
    test('Ethereum native transaction', () {
      final signedEthTx = BuildTransaction.ethereum(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEthTx.rawTx as String).length, 117);
      expect(signedEthTx.toJson(), {
        'txid':
            '02f8720180847735940085104c533c00825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a1600080c080a026f518b68b0aceb7168490743185606f267f2db9b0762fcf1525060fc4f9bd10a04e77b5defdd2ac6baba503fb540ee7e94cbbd57d6fdf0b5063c371bb24896186',
        'networkFee': '1470000000000000'
      });
    });
    test('Ethereum ERC20 token transaction', () {
      final signedEthTx = BuildTransaction.ethereumERC20Token(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEthTx.rawTx as String).length, 178);
      expect(signedEthTx.toJson(), {
        'txid':
            '02f8af0180847735940085104c533c008252089426fc591fecc4948c4288d95b6aadab00eba4e72a80b844a9059cbb0000000000000000000000003e26e7f73a80444e67b7be654a38ab85ccb6ea4700000000000000000000000000000000000000000000000000000000000e1af0c0019f167aba1c67d36ff746999a00c1e63925bb3d742e1ea2011ad9daa24bcf400ba059efe11b45173f678264e72b89efa480500aa4e4c8cce18a25c6897e96a25732',
        'networkFee': '1470000000000000'
      });
    });
    test('Ethereum Classic native transaction', () {
      final signedEtcTx = BuildTransaction.ethereumClassic(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEtcTx.rawTx as String).length, 110);
      expect(signedEtcTx.toJson(), {
        'txid':
            'f86c8085012a05f200825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a1600080819da0347b36cf8a1d2b31370fb882f6ec6b38362bc38d484776f2aea54cd712a7a5a2a00f62d9c81987979f70395c594d0214a04bd7db8850970f1511a48d132f70e244',
        'networkFee': '105000000000000'
      });
    });
    test('Polygon native transaction', () {
      final signedEthTx = BuildTransaction.polygon(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEthTx.rawTx as String).length, 119);
      expect(signedEthTx.toJson(), {
        'txid':
            '02f8748189808506fc23ac008509502f9000825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a1600080c080a0e43117a6a9943bf8abb462c9c41842f1f16645e5f94d72299bdaf71d07e3d0d0a046dc725ee88aa0eec11ac8b9cd4f32f78829148ceaa5d1e10bb9427f3689cd49',
        'networkFee': '840000000000000'
      });
    });
    test('Polygon ERC20 token transaction', () {
      final signedEthTx = BuildTransaction.polygonERC20Token(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEthTx.rawTx as String).length, 181);
      expect(signedEthTx.toJson(), {
        'txid':
            '02f8b28189808506fc23ac008509502f90008252089426fc591fecc4948c4288d95b6aadab00eba4e72a80b844a9059cbb0000000000000000000000003e26e7f73a80444e67b7be654a38ab85ccb6ea4700000000000000000000000000000000000000000000000000000000000e1af0c001a0472ab70dffd909bbbbafa44d3a4667007e1d31f05c7fa9db3e01420a910a3e66a01aee0ed1f99a0196fc3cad6076a41b0cc8bea07eac7ac937d75af2f0049fd17f',
        'networkFee': '840000000000000'
      });
    });
    test('Avalanche native transaction', () {
      final signedEthTx = BuildTransaction.avalanche(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEthTx.rawTx as String).length, 118);
      expect(signedEthTx.toJson(), {
        'txid':
            '02f8736a80849502f90085066720b30083030d40943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a1600080c001a03014b986040d0352147580519c0b671bade51655908de03eca574990dd570c03a0035168bb9b6527c5bb1655ce3e96783795f4b3e4d6907aef194f3d9fb2e7c857',
        'networkFee': '5500000000000000'
      });
    });
    test('Avalanche ERC20 token transaction', () {
      final signedEthTx = BuildTransaction.avalancheERC20Token(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedEthTx.rawTx as String).length, 180);
      expect(signedEthTx.toJson(), {
        'txid':
            '02f8b16a80849502f90085066720b30083030d409426fc591fecc4948c4288d95b6aadab00eba4e72a80b844a9059cbb0000000000000000000000003e26e7f73a80444e67b7be654a38ab85ccb6ea4700000000000000000000000000000000000000000000000000000000000e1af0c001a0fcab33eaaa16aa3fc6271a5becce1f2b61513690e54fe8cf1a0d69bc7fe37cffa06fa66619068be4411f353e24293e48bd341879276c4d0ccd6affa2ce9d9b9101',
        'networkFee': '5500000000000000'
      });
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
      expect(base58.decode(signedSolanaTx.rawTx as String).length, 215);
      expect(signedSolanaTx.toJson(), {
        'txid':
            '3zWUJPKRuoYY39TFcezbAxEgnYQ6vdhxHrKR9AfHBwe1jqVeAEREwoSWC1JyuyayggHvMjBjpBzR4EGyAFeR4cYTDB2ivdKmRM56P2vEgZkmEAt57LTxwtVM1isG88Fo9fqkT14vnrkke1tRbD8ivG6BEwhDvYURy1Z9RyKe3QozAKcP28mUyaCeBdjd4LgvmyDNCvstDmT2DADeD6qYoZZHxVNGxpjnR7rQfuG8UgfNWcixZFJkQB7k5SkDE5GuTxZqnHy4M87QdvCc7qKWrGGnmD9j8sQeycJk7',
        'networkFee': '5000'
      });
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
      expect(base58.decode(signedSolanaTokenTx.rawTx as String).length, 279);
      expect(signedSolanaTokenTx.toJson(), {
        'txid':
            'LMcrASBJnPkjYi5VWC4kjDSDUQ3yPruwqD3EQRH1o1nEEZUYvAvzfF2ZB8E1yL78zJPPCCMQUe9BpJpGR4YJ8Y7ZZ7x7N9KtJEQb9MbtgFaL3GdXvA41suG3KCckRXKwXikZhxgjUCASruE79H1bWZ5rqCCwAhv54SUobj1GvnFXtPaQu9iQG4mGJjEyy44ctBFJatbwBfXwZSKJBVXaYwkpdN2fZy3wZNPt9pFK9BF72n5C3s99Vc9CzrzM9tfE2TKjKE6CopYATdeb1qmVDYVxnj3ZdaJGp7RHP61sGhY21iHQt47E7naMtCSTkjxohUfcirTahTYAcbmZD3iwAKcYRmuCk5PaeSCnL42MYhEE5WsG97sWL5Gk9Nrj',
        'networkFee': '5000'
      });
    });
  });

  group('UtxoCoin transaction tests - ', () {
    test('No utxo available - blockbook', () async {
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
    test('Total amount < amount + estimated fee (1000 sats) - blockbook',
        () async {
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
        expect(exception, isA<LowTotalAmountPlusFeeException>());
      }
    });
    test('Total amount < amount + estimated fee (1000 sats) - insight',
        () async {
      const coin = TWCoinType.TWCoinTypeLitecoin;
      const toAddress = 'ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z';
      const amount = '38900';
      const utxoString =
          '[{"txid":"f873f455ded89ef7fc7eae62f9ef78c02814f28cf9501f871cbe576096ad9ef5","vout":0,"satoshis":29169,"height":2252921,"confirmations":683},{"txid":"6e5da8e54a0d785a9c3ec9eb0848d14a4011782cf93491404599e0a4cb5a1c67","vout":0,"satoshis":10000,"height":2252920,"confirmations":684}]';
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
        expect(exception, isA<LowTotalAmountPlusFeeException>());
      }
    });
    test('Valid utxoCoin transaction - blockbook', () async {
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
      expect(hex.decode(signedUtxoCoinTx.rawTx as String).length, 223);
      expect(signedUtxoCoinTx.toJson(), {
        'txid':
            '01000000000101f59ead966057be1c871f50f98cf21428c078eff962ae7efcf79ed8de55f473f800000000000000000002a861000000000000160014bb8ef6a40ab316da000090c989372ac48f233fd7c70a000000000000160014ac9a7a96a4e4fd16539f53b1fa062afe0dbd6ba902483045022100ad22e6db78e625ab2f1ee12e73222d1ddcab8cc6f3e4f806217bcf18dd74aca102201f013317e42e5a9c87e9a590045bdd209c60b41b052c08b3ecf3f33515df8244012102a91d09121aff91972942758b4e827f18c27305af2085459555f989fbf105d49600000000',
        'networkFee': '1410'
      });
    });
    test('Valid utxoCoin transaction - insight', () async {
      const coin = TWCoinType.TWCoinTypeZelcash;
      const toAddress = 't1byktNheu1vBB5YkwKY1zvQDcAt5c44v8w';
      const amount = '4000';
      // https://explorer.runonflux.io/api/addr/t1byktNheu1vBB5YkwKY1zvQDcAt5c44v8w/utxo
      const utxoString =
          '[{"address":"t1byktNheu1vBB5YkwKY1zvQDcAt5c44v8w","txid":"d44de5df6f6e6581dd5a8a16f3b2f1dcd4e2637699d38864d29a9e1b050496ef","vout":0,"scriptPubKey":"76a914c69c2c2a50ddd8fc960a0ef0cc3cdac9a3d995bc88ac","amount":0.000114,"satoshis":11400,"height":1142791,"confirmations":69}]';
      List utxo = jsonDecode(utxoString);

      final signedUtxoCoinTx = BuildTransaction.utxoCoin(
        wallet: wallet,
        coin: coin,
        toAddress: toAddress,
        amount: amount,
        byteFee: '10',
        utxo: utxo,
      );
      expect(hex.decode(signedUtxoCoinTx.rawTx as String).length, 245);
      expect(signedUtxoCoinTx.toJson(), {
        'txid':
            '0400008085202f8901ef9604051b9e9ad26488d3997663e2d4dcf1b2f3168a5add81656e6fdfe54dd4000000006b4830450221008cf8ebe7b4cb60890bf04a1f004d4b75c9740d64b760a7dc6167a10d321e71b2022013f750b6746ba9287b2cea199afb69b977b4b89805d076ce0d340ab5edbbe22f012103c177cbfeb3f360aeb36e65c2ef70e4dcbd7a033faabd8f9a4ab100cb73b341fc0000000002a00f0000000000001976a914c69c2c2a50ddd8fc960a0ef0cc3cdac9a3d995bc88ac14140000000000001976a914b94b42a358f3dc8ec231d90eac15a59481d9440988ac00000000000000000000000000000000000000',
        'networkFee': '2260'
      });
    });
    test('Valid utxoCoin transaction one additional utxo add - blockbook',
        () async {
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
      expect(hex.decode(signedUtxoCoinTx.rawTx as String).length, 222);
      expect(signedUtxoCoinTx.toJson(), {
        'txid':
            '01000000000101f59ead966057be1c871f50f98cf21428c078eff962ae7efcf79ed8de55f473f8000000000000000000020f27000000000000160014bb8ef6a40ab316da000090c989372ac48f233fd76045000000000000160014ac9a7a96a4e4fd16539f53b1fa062afe0dbd6ba9024730440220044a1392212fb469afb6dfa71c9644eeaa8568d73cc50d08318e1994d5b929a402205251975b001f3be28d1186b3307d5d5361c25e4d9e94d50ec3342f5cce9692b4012102a91d09121aff91972942758b4e827f18c27305af2085459555f989fbf105d49600000000',
        'networkFee': '1410'
      });
    });
    test('Valid utxoCoin transaction one additional utxo add - insight',
        () async {
      const coin = TWCoinType.TWCoinTypeLitecoin;
      const toAddress = 'ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z';
      const amount = '9999';
      const utxoString =
          '[{"txid":"f873f455ded89ef7fc7eae62f9ef78c02814f28cf9501f871cbe576096ad9ef5","vout":0,"satoshis":29169,"height":2252921,"confirmations":683},{"txid":"6e5da8e54a0d785a9c3ec9eb0848d14a4011782cf93491404599e0a4cb5a1c67","vout":0,"satoshis":10000,"height":2252920,"confirmations":684}]';
      List utxo = jsonDecode(utxoString);

      final signedUtxoCoinTx = BuildTransaction.utxoCoin(
        wallet: wallet,
        coin: coin,
        toAddress: toAddress,
        amount: amount,
        byteFee: '10',
        utxo: utxo,
      );
      expect(hex.decode(signedUtxoCoinTx.rawTx as String).length, 222);
      expect(signedUtxoCoinTx.toJson(), {
        'txid':
            '01000000000101f59ead966057be1c871f50f98cf21428c078eff962ae7efcf79ed8de55f473f8000000000000000000020f27000000000000160014bb8ef6a40ab316da000090c989372ac48f233fd76045000000000000160014ac9a7a96a4e4fd16539f53b1fa062afe0dbd6ba9024730440220044a1392212fb469afb6dfa71c9644eeaa8568d73cc50d08318e1994d5b929a402205251975b001f3be28d1186b3307d5d5361c25e4d9e94d50ec3342f5cce9692b4012102a91d09121aff91972942758b4e827f18c27305af2085459555f989fbf105d49600000000',
        'networkFee': '1410'
      });
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
