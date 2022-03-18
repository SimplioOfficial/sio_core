import 'package:trust_wallet_core/flutter_trust_wallet_core.dart' as trust_core;

class Mnemonic {
  var wallet = trust_core.HDWallet();

  String get generate {
    return wallet.mnemonic();
  }

  bool isValid({required String mnemonic}) {
    return trust_core.Mnemonic.isValid(mnemonic);
  }
}
