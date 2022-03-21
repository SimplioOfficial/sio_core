import 'package:test/test.dart';
import 'package:sio_core/sio_core.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart' as trust_core;

void main() {
  trust_core.TrustWalletCoreLib.init();

  group('Mnemonic tests', () {
    test('Mnemonic is valid', () {
      const mnemonic =
          'rent craft script crucial item someone dream federal notice page shrug pipe young hover duty';
      expect(Mnemonic().isValid(mnemonic: mnemonic), equals(true));
    });
  });

  // group('String', () {
  //   test('.split() splits the string on the delimiter', () {
  //     var string = 'foo,bar,baz';
  //     expect(string.split(','), equals(['foo', 'bar', 'baz']));
  //   });

  //   test('.trim() removes surrounding whitespace', () {
  //     var string = '  foo ';
  //     expect(string.trim(), equals('foo'));
  //   });
  // });
}
