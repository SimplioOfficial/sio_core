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
    required String recipient,
    required String amount,
    required HDWallet wallet,
    required String apiEndpoint,
  }) async {
    final secretPrivateKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeSolana);
    final response = await recentBlockHashRequest(apiEndpoint: apiEndpoint);
    final String recentBlockHash =
        jsonDecode(response.body)["result"]["value"]["blockhash"];
    final tx = solana_pb.Transfer(
      recipient: recipient,
      value: $fixnum.Int64.parseInt(amount),
    );
    final _signingInput = solana_pb.SigningInput(
      privateKey: secretPrivateKey.data().toList(),
      recentBlockhash: recentBlockHash,
      transferTransaction: tx,
    );
    final sign = AnySigner.sign(
      _signingInput.writeToBuffer(),
      TWCoinType.TWCoinTypeSolana,
    );
    final signingOutput = solana_pb.SigningOutput.fromBuffer(sign);

    return signingOutput.encoded;
  }

  /// Solana token transaction
  static Future<String> solanaToken({
    required String amount,
    required int decimals,
    required String tokenMintAddress,
    required String recipientSolanaAddress,
    required HDWallet wallet,
    required String apiEndpoint,
  }) async {
    final secretPrivateKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeSolana);
    final _response = await recentBlockHashRequest(apiEndpoint: apiEndpoint);
    final String _recentBlockHash =
        jsonDecode(_response.body)["result"]["value"]["blockhash"];

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
