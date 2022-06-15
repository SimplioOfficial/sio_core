/// All the exceptions are defined so application can
/// respond differently to each case.
///
/// Current address has no utxo available.
class NoUtxoAvailableException implements Exception {
  NoUtxoAvailableException();
}

/// Total amount in the address is lower than the amount
/// that is wanted to be send plus the transaction fee
/// needed to execute this transaction.
///
/// Try to lower the amount to be sent.
class LowTotalAmountPlusFeeException implements Exception {
  LowTotalAmountPlusFeeException();
}
