import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart' as trust_core;

class Mnemonic {
  var wallet = trust_core.HDWallet();

  // No tests are needed for generate mnemonic.
  // Function is tested in wallet-core lib
  // coverage:ignore-start
  String get generate {
    return wallet.mnemonic();
  }
  // coverage:ignore-end

  bool isValid({required String mnemonic}) {
    return trust_core.Mnemonic.isValid(mnemonic);
  }
}
