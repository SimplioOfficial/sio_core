import 'package:sio_core/src/get_transactions.dart';
import 'package:test/test.dart';

void main() {
  group('Get transactions for utxoCoin - ', () {
    test('Bitcoin - No transactions', () async {
      const address = 'bc1qwquauyfgqgwh2gc9td8dhrf00432duh77wvxy5';
      final response = await GetTransactions.utxoCoinBlockbook(
        apiEndpoint: 'https://btc1.simplio.io/',
        address: address,
      );
      expect(response, []);
    });

    test('Bitcoin - Error', () async {
      const address = 'ltc1q4jd8494yun73v5ul2wcl5p32lcxm66afx4efr6';
      try {
        await GetTransactions.utxoCoinBlockbook(
          apiEndpoint: 'https://btc1.simplio.io/',
          address: address,
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Litecoin - Standard transactions', () async {
      const address = 'ltc1qulzv02h8nmsuqxaqas3dv22cl244r7vs0smssh';
      final response = await GetTransactions.utxoCoinBlockbook(
        apiEndpoint: 'https://ltc1.simplio.io/',
        address: address,
      );

      expect(response[response.length - 1].txid,
          '6e5da8e54a0d785a9c3ec9eb0848d14a4011782cf93491404599e0a4cb5a1c67');
    });
    test('Litecoin - Generated coins', () async {
      const address = 'LfmssDyX6iZvbVqHv6t9P6JWXia2JG7mdb';
      final response = await GetTransactions.utxoCoinBlockbook(
        apiEndpoint: 'https://ltc1.simplio.io/',
        address: address,
        page: '1000',
      );
      expect(response[response.length - 1].txid,
          '4eb47c6c53e4b4decb0ee36bfc928267de9a189f10359c8bfe495e57960f6762');
    });
    test('Dash - Composed transactions', () async {
      const address = 'XognSnGYoqaNiL2v24hRMwc6QdWfuRoQz7';
      final response = await GetTransactions.utxoCoinBlockbook(
        apiEndpoint: 'https://dash1.trezor.io/',
        address: address,
      );
      expect(response[response.length - 1].txid,
          '24ba935d8ecd2d89873c9e23ea46581de950b14b8b23b1ef08ac6d000265d088');
    });
  });
}
