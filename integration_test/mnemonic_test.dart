import 'package:test/test.dart';
import 'package:sio_core/sio_core.dart';
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart' as trust_core;

void main() {
  trust_core.FlutterTrustWalletCore.init();
  test('Mnemonic is valid', () {
    const mnemonic =
        'rent craft script crucial item someone dream federal notice page shrug pipe young hover duty';
    expect(Mnemonic().isValid(mnemonic: mnemonic), equals(true));
  });
}
