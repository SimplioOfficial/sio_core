import 'package:test/test.dart';
import 'package:sio_core/sio_core.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart' as trust_core;

void main() {
  trust_core.TrustWalletCoreLib.init();
  test('Mnemonic is valid', () {
    const mnemonic =
        'rent craft script crucial item someone dream federal notice page shrug pipe young hover duty';
    expect(Mnemonic().isValid(mnemonic: mnemonic), equals(true));
  });
}
