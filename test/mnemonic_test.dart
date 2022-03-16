import 'package:test/test.dart';
import 'package:sio_core/sio_core.dart';

void main() {
  test('Mnemonic is valid', () {
    expect(
        Mnemonic().isValid(
            mnemonic:
                'rent craft script crucial item someone dream federal notice page shrug pipe young hover duty'),
        equals(true));
  });
}
