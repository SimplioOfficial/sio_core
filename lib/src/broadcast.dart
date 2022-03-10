class Broadcast {
  final String txHash;
  Broadcast({required this.txHash});

  String get bitcoin {
    return txHash;
  }

  String get solana {
    return txHash;
  }
}
