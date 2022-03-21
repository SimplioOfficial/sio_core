import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart' as trust_core;

class Mnemonic {
  var wallet = trust_core.HDWallet(strength: 256);

  String get generate {
    return wallet.mnemonic();
  }

  // Supports only 12 or 24 words mnemonics
  static bool isValid({required String mnemonic}) {
    return trust_core.Mnemonic.isValid(mnemonic);
  }

  static trust_core.HDWallet import({required String mnemonic}) {
    return trust_core.HDWallet.createWithMnemonic(mnemonic);
  }
}
