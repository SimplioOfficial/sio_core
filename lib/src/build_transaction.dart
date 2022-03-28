import 'dart:convert';

import 'utils.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:trust_wallet_core_lib/protobuf/Solana.pb.dart' as solana_pb;

/// Class that builds transactions and return OutputTx ready for broadcasting.
class BuildTransaction {
  /// Solana native transaction
  static Future<String> solana({
    required HDWallet wallet,
    required String recipient,
    required String amount,
    required String apiEndpoint,
    String? recentBlockHash, // needed for tests
  }) async {
    final secretPrivateKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeSolana);

    String _recentBlockHash;
    if (recentBlockHash == null) {
      final response = await recentBlockHashRequest(apiEndpoint: apiEndpoint);
      _recentBlockHash = jsonDecode(response)["result"]["value"]["blockhash"];
    } else {
      _recentBlockHash = recentBlockHash;
    }

    final tx = solana_pb.Transfer(
      recipient: recipient,
      value: $fixnum.Int64.parseInt(amount),
    );
    final signingInput = solana_pb.SigningInput(
      privateKey: secretPrivateKey.data().toList(),
      recentBlockhash: _recentBlockHash,
      transferTransaction: tx,
    );
    final sign = AnySigner.sign(
      signingInput.writeToBuffer(),
      TWCoinType.TWCoinTypeSolana,
    );
    final signingOutput = solana_pb.SigningOutput.fromBuffer(sign);

    return signingOutput.encoded;
  }

  /// Solana token transaction
  static Future<String> solanaToken({
    required HDWallet wallet,
    required String recipientSolanaAddress,
    required String tokenMintAddress,
    required String amount,
    required int decimals,
    required String apiEndpoint,
    String? recentBlockHash, // needed for tests
  }) async {
    final secretPrivateKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeSolana);

    String _recentBlockHash;
    if (recentBlockHash == null) {
      final response = await recentBlockHashRequest(apiEndpoint: apiEndpoint);
      _recentBlockHash = jsonDecode(response)["result"]["value"]["blockhash"];
    } else {
      _recentBlockHash = recentBlockHash;
    }

    final solanaAddress = SolanaAddress.createWithString(
        wallet.getAddressForCoin(TWCoinType.TWCoinTypeSolana));
    final senderTokenAddress =
        solanaAddress.defaultTokenAddress(tokenMintAddress);

    final recipientTokenAddress =
        SolanaAddress.createWithString(recipientSolanaAddress)
            .defaultTokenAddress(tokenMintAddress);
    final tx = solana_pb.TokenTransfer(
      tokenMintAddress: tokenMintAddress,
      senderTokenAddress: senderTokenAddress,
      recipientTokenAddress: recipientTokenAddress,
      amount: $fixnum.Int64.parseInt(amount),
      decimals: decimals,
    );

    final signingInput = solana_pb.SigningInput(
      privateKey: secretPrivateKey.data().toList(),
      recentBlockhash: _recentBlockHash,
      tokenTransferTransaction: tx,
    );
    final sign = AnySigner.sign(
      signingInput.writeToBuffer(),
      TWCoinType.TWCoinTypeSolana,
    );
    final signingOutput = solana_pb.SigningOutput.fromBuffer(sign);

    return signingOutput.encoded;
  }
}
