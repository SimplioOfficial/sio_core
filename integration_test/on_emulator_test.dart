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

  group('Ethereum transaction tests - ', () {
    const toAddress = '0x3E26e7F73A80444e67b7bE654A38aB85ccb6ea47';
    const amount = '924400';
    const tokenContract = '0x26Fc591feCC4948c4288d95B6AAdAB00eBa4e72A';
    test('BSC native transaction length', () async {
      final signedBscTx = await BuildTransaction.bnbSmartChain(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedBscTx).length, 110);
    });
    test('BSC native transaction hash', () async {
      final signedBscTx = await BuildTransaction.bnbSmartChain(
        wallet: wallet,
        amount: amount,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(signedBscTx,
          'f86c8085032a9f8800825208943e26e7f73a80444e67b7be654a38ab85ccb6ea47870348bca5a16000808194a0d2c6acce01755661bf4dceee0826d0b7962b018b7a298ec443ad5587e310baefa020a3ffd793ff276af6676bad45887551508c6e98eb07faa9d1bd29a1844f1f8b');
    });
    test('BSC token transaction length', () async {
      final signedBscTx = await BuildTransaction.bnbSmartChainToken(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(hex.decode(signedBscTx).length, 171);
    });
    test('BSC token transaction hash', () async {
      final signedBscTx = await BuildTransaction.bnbSmartChainToken(
        wallet: wallet,
        amount: amount,
        tokenContract: tokenContract,
        toAddress: toAddress,
        nonce: '0',
      );
      expect(signedBscTx,
          'f8a98084d693a4008252089426fc591fecc4948c4288d95b6aadab00eba4e72a80b844a9059cbb0000000000000000000000003e26e7f73a80444e67b7be654a38ab85ccb6ea4700000000000000000000000000000000000000000000000000000000000e1af08194a0cad73e551edf5e537ee7bad6cdf3e5454c70566b6ea7471b4df4360c364087afa02cfcc1d078171ebc87fc36b725d50f172d9414e50c15c87f59508101b8ae40ea');
    });
  });

  group('Solana transactions tests - ', () {
    const toAddress = '3fTR8GGL2mniGyHtd3Qy2KDVhZ9LHbW59rCc7A3RtBWk';
    const tokenMintAddress = 'SioTkQxHyAs98ouRiyi1YDv3gLMSrX3eNBg61GH7NrM';
    const amount = '4000';
    const decimals = 8;
    const apiEndpoint = 'https://api.devnet.solana.com';
    test('Solana native transaction length', () async {
      final signedSolanaTx = await BuildTransaction.solana(
        wallet: wallet,
        recipient: toAddress,
        amount: amount,
        apiEndpoint: apiEndpoint,
      );
      expect(base58.decode(signedSolanaTx).length, 215);
    });
    test('Solana native transaction hash', () async {
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
              '3zWUJPKRuoYY39TFcezbAxEgnYQ6vdhxHrKR9AfHBwe1jqVeAEREwoSWC1JyuyayggHvMjBjpBzR4EGyAFeR4cYTDB2ivdKmRM56P2vEgZkmEAt57LTxwtVM1isG88Fo9fqkT14vnrkke1tRbD8ivG6BEwhDvYURy1Z9RyKe3QozAKcP28mUyaCeBdjd4LgvmyDNCvstDmT2DADeD6qYoZZHxVNGxpjnR7rQfuG8UgfNWcixZFJkQB7k5SkDE5GuTxZqnHy4M87QdvCc7qKWrGGnmD9j8sQeycJk7'));
    });
    test('Solana token transaction length', () async {
      final signedSolanaTokenTx = await BuildTransaction.solanaToken(
        wallet: wallet,
        recipientSolanaAddress: toAddress,
        tokenMintAddress: tokenMintAddress,
        amount: amount,
        decimals: decimals,
        apiEndpoint: apiEndpoint,
      );
      expect(base58.decode(signedSolanaTokenTx).length, 279);
    });
    test('Solana token transaction hash', () async {
      final signedSolanaTokenTx = await BuildTransaction.solanaToken(
        wallet: wallet,
        recipientSolanaAddress: toAddress,
        tokenMintAddress: tokenMintAddress,
        amount: amount,
        decimals: decimals,
        apiEndpoint: apiEndpoint,
        recentBlockHash: '11111111111111111111111111111111',
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

      final signedUtxoCoinTx = BuildTransaction.utxoCoin(
        wallet: wallet,
        coin: coin,
        toAddress: toAddress,
        amount: amount,
        byteFee: '10',
        apiEndpoint: apiEndpoint,
      );
      await expectLater(signedUtxoCoinTx, throwsException);
    });
    test('Total amount < amount', () async {
      const coin = TWCoinType.TWCoinTypeLitecoin;
      const toAddress = 'ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z';
      const amount = '1550000';
      const apiEndpoint = 'https://ltc1.simplio.io/';
      final signedUtxoCoinTx = BuildTransaction.utxoCoin(
        wallet: wallet,
        coin: coin,
        toAddress: toAddress,
        amount: amount,
        byteFee: '10',
        apiEndpoint: apiEndpoint,
      );
      await expectLater(signedUtxoCoinTx, throwsException);
    });
    test('Total amount < amount + estimated fee (1000 sats)', () async {
      const coin = TWCoinType.TWCoinTypeLitecoin;
      const toAddress = 'ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z';
      const amount = '30000';
      const apiEndpoint = 'https://ltc1.simplio.io/';

      final signedUtxoCoinTx = BuildTransaction.utxoCoin(
        wallet: wallet,
        coin: coin,
        toAddress: toAddress,
        amount: amount,
        byteFee: '10',
        apiEndpoint: apiEndpoint,
      );
      await expectLater(signedUtxoCoinTx, throwsException);
    });
    test('Valid utxoCoin transaction', () async {
      const coin = TWCoinType.TWCoinTypeLitecoin;
      const toAddress = 'ltc1qhw80dfq2kvtd5qqqjrycjde2cj8jx07h98rj0z';
      const amount = '25000';
      const apiEndpoint = 'https://ltc1.simplio.io/';

      final signedUtxoCoinTx = await BuildTransaction.utxoCoin(
        wallet: wallet,
        coin: coin,
        toAddress: toAddress,
        amount: amount,
        byteFee: '10',
        apiEndpoint: apiEndpoint,
      );
      expect(hex.decode(signedUtxoCoinTx).length, 223);
    });
  });
}
