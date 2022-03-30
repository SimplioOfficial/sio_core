import 'dart:convert';
import 'utils.dart';
import 'exceptions.dart';

import 'package:convert/convert.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:trust_wallet_core_lib/protobuf/Solana.pb.dart' as solana_pb;
import 'package:trust_wallet_core_lib/protobuf/Bitcoin.pb.dart' as bitcoin_pb;

/// Class that builds transactions and return OutputTx ready for broadcasting.
class BuildTransaction {
  /// Utxo coins transaction
  static Future<String> utxoCoin({
    required HDWallet wallet,
    required int coin,
    required String toAddress,
    required String amount,
    required String byteFee,
    required String apiEndpoint,
  }) async {
    final changeAddress = wallet.getAddressForCoin(coin);
    final utxoString =
        await (getUtxo(apiEndpoint: apiEndpoint + 'api/utxo/' + changeAddress));
    List<dynamic> utxo = jsonDecode(utxoString);
    if (utxo.isEmpty) {
      throw NoUtxoAvailableException();
    }
    utxo.sort((map1, map2) => map1['satoshis'].compareTo(map2['satoshis']));

    var totalAmount = 0;
    const theConsideredFeeInSats = 10000;
    for (var tx in utxo) {
      totalAmount += tx['satoshis'] as int;
      if (totalAmount > int.parse(amount) + theConsideredFeeInSats * 10) break;
    }
    if (totalAmount < int.parse(amount)) {
      throw LowTotalAmountException();
    }

    var minUtxoNeed = 0;
    var minUtxoAmountNeed = 0;
    if (totalAmount < int.parse(amount) + theConsideredFeeInSats) {
      throw Under10kTotalAmountException();
    }
    for (var tx in utxo) {
      if (minUtxoAmountNeed < int.parse(amount) + theConsideredFeeInSats) {
        minUtxoNeed++;
        minUtxoAmountNeed += tx['satoshis'] as int;
      }
    }
    utxo = utxo.take(minUtxoNeed).toList();
    List<bitcoin_pb.UnspentTransaction> utxoParsed = [];
    for (var index = 0; index <= utxo.length - 1; index++) {
      final txParsed = bitcoin_pb.UnspentTransaction(
        amount: $fixnum.Int64(utxo[index]['satoshis']),
        outPoint: bitcoin_pb.OutPoint(
          hash: hex.decode(utxo[index]['txid']).reversed.toList(),
          index: utxo[index]['vout'],
        ),
        script: BitcoinScript.lockScriptForAddress(
                wallet.getAddressForCoin(coin), coin)
            .data()
            .toList(),
      );
      utxoParsed.add(txParsed);
    }

    final signingInput = bitcoin_pb.SigningInput(
      amount: $fixnum.Int64.parseInt(amount),
      hashType: BitcoinScript.hashTypeForCoin(coin),
      toAddress: toAddress,
      changeAddress: changeAddress,
      byteFee: $fixnum.Int64.parseInt(byteFee),
      coinType: coin,
      utxo: utxoParsed,
      privateKey: [wallet.getKeyForCoin(coin).data().toList()],
    );
    final transactionPlan = bitcoin_pb.TransactionPlan.fromBuffer(
      AnySigner.signerPlan(signingInput.writeToBuffer(), coin).toList(),
    );
    signingInput.plan = transactionPlan;
    signingInput.amount = transactionPlan.amount;
    final sign = AnySigner.sign(signingInput.writeToBuffer(), coin);
    final signingOutput = bitcoin_pb.SigningOutput.fromBuffer(sign);

    return hex.encode(signingOutput.encoded);
  }

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
