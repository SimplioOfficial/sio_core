import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart' as trust_core;

///Class that manipulates BIP39 English mnemonics
class Mnemonic {
  final _wallet = trust_core.HDWallet(strength: 256);

  /// Generate an 24 words valid BIP39 English mnemonic.
  String get generate {
    return _wallet.mnemonic();
  }

  /// Determines whether a BIP39 English mnemonic phrase is valid.
  /// Wallet Core supports only 12 or 24 words mnemonic phrases
  static bool isValid({required String mnemonic}) {
    return trust_core.Mnemonic.isValid(mnemonic);
  }

  /// Creates an HDWallet from a valid BIP39 English mnemonic.
  /// Null is returned on invalid mnemonic. Returned object needs to be deleted.
  static trust_core.HDWallet import({required String mnemonic}) {
    return trust_core.HDWallet.createWithMnemonic(mnemonic);
  }
}
