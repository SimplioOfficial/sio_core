import 'package:sio_core/src/get_decimals.dart';
import 'package:test/test.dart';

void main() {
  test('Cosmos decimals', () {
    expect(GetDecimals.cosmos(ticker: 'atom'), 6);
    expect(GetDecimals.cosmos(ticker: 'luna'), 6);
    expect(GetDecimals.cosmos(ticker: 'osmo'), 6);
    try {
      GetDecimals.cosmos(ticker: 'ami');
    } catch (exception) {
      expect(exception, isA<Exception>());
    }
  });
  test('Ethereum decimals', () {
    expect(GetDecimals.ethereum(ticker: 'bsc'), 18);
    expect(GetDecimals.ethereum(ticker: 'etc'), 18);
    expect(GetDecimals.ethereum(ticker: 'eth'), 18);
    try {
      GetDecimals.ethereum(ticker: 'ami');
    } catch (exception) {
      expect(exception, isA<Exception>());
    }
  });
  group('Ethereum tokens - ', () {
    test('BEP-20', () async {
      const apiEndpoint = 'https://bscxplorer.com/';
      final decimals = await GetDecimals.ethereumERC20Blockbook(
        contractAddress: '0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d',
        apiEndpoint: apiEndpoint,
      );
      expect(decimals, 18);
      try {
        await GetDecimals.ethereumERC20Blockbook(
          contractAddress: '0x1Ac1C8b874c7B889113A036Ba443b082554bE5',
          apiEndpoint: apiEndpoint,
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
      try {
        await GetDecimals.ethereumERC20Blockbook(
          contractAddress: '0x1Ac1C8b874c7B889113A036Ba443b082554bE5D0',
          apiEndpoint: apiEndpoint,
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('ETC-20', () async {
      const apiEndpoint = 'https://etcblockexplorer.com/';
      final decimals = await GetDecimals.ethereumERC20Blockbook(
        contractAddress: '0x1Ac1C8b874c7B889113A036Ba443b082554bE5D0',
        apiEndpoint: apiEndpoint,
      );
      expect(decimals, 8);
      try {
        await GetDecimals.ethereumERC20Blockbook(
          contractAddress: '0x1Ac1C8b874c7B889113A036Ba443b082554bE5',
          apiEndpoint: apiEndpoint,
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
      try {
        await GetDecimals.ethereumERC20Blockbook(
          contractAddress: '0x949E0a0672299E6fcD6bec3Bd1735d6647b20618',
          apiEndpoint: apiEndpoint,
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('ERC-20', () async {
      const apiEndpoint = 'https://ethblockexplorer.org/';
      final decimals = await GetDecimals.ethereumERC20Blockbook(
        contractAddress: '0xd26114cd6EE289AccF82350c8d8487fedB8A0C07',
        apiEndpoint: apiEndpoint,
      );
      expect(decimals, 18);
      try {
        await GetDecimals.ethereumERC20Blockbook(
          contractAddress: '0x1Ac1C8b874c7B889113A036Ba443b082554bE5',
          apiEndpoint: apiEndpoint,
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
      try {
        await GetDecimals.ethereumERC20Blockbook(
          contractAddress: '0x1Ac1C8b874c7B889113A036Ba443b082554bE5D0',
          apiEndpoint: apiEndpoint,
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('ERC-20 - Polygon', () async {
      const apiEndpoint = 'http://decimals.amitabha.xyz/';
      final decimals = await GetDecimals.ethereumERC20Ami(
        ticker: 'matic',
        contractAddress: '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174',
        apiEndpoint: apiEndpoint,
      );
      expect(decimals, 6);
    });
  });
  test('Solana decimals', () {
    expect(GetDecimals.solana, 9);
  });
  test('Solana tokens', () async {
    const apiEndpoint = 'https://api.mainnet-beta.solana.com/';
    final decimals = await GetDecimals.solanaToken(
      tokenMintAddress: '4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R',
      apiEndpoint: apiEndpoint,
    );
    expect(decimals, 6);
    try {
      await GetDecimals.solanaToken(
        tokenMintAddress: '4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY',
        apiEndpoint: apiEndpoint,
      );
    } catch (exception) {
      expect(exception, isA<Exception>());
    }
  });
  test('UtxoCoin decimals', () {
    expect(GetDecimals.utxoCoin(ticker: 'btc'), 8);
    expect(GetDecimals.utxoCoin(ticker: 'bch'), 8);
    expect(GetDecimals.utxoCoin(ticker: 'dash'), 8);
    expect(GetDecimals.utxoCoin(ticker: 'dgb'), 8);
    expect(GetDecimals.utxoCoin(ticker: 'doge'), 8);
    expect(GetDecimals.utxoCoin(ticker: 'flux'), 8);
    expect(GetDecimals.utxoCoin(ticker: 'ltc'), 8);
    expect(GetDecimals.utxoCoin(ticker: 'zec'), 8);
    try {
      GetDecimals.utxoCoin(ticker: 'ami');
    } catch (exception) {
      expect(exception, isA<Exception>());
    }
  });
}
