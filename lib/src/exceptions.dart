/// All the exceptions are defined so application can
/// respond differently to each case.
///
/// Current address has no utxo available
class NoUtxoAvailableException implements Exception {
  NoUtxoAvailableException();
}

/// Total amount in the address is lower than the amount
/// that is wanted to be send
class LowTotalAmountException implements Exception {
  LowTotalAmountException();
}

/// Total amount that remains in the address after this transaction
/// is lower than 10000 satoshis. Try to send lower amount.
class Under10kTotalAmountException implements Exception {
  Under10kTotalAmountException();
}
