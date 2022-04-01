import 'dart:convert';
import 'utils.dart';
import 'exceptions.dart';

import 'package:convert/convert.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:trust_wallet_core_lib/protobuf/Bitcoin.pb.dart' as bitcoin_pb;
import 'package:trust_wallet_core_lib/protobuf/Ethereum.pb.dart' as ethereum_pb;
import 'package:trust_wallet_core_lib/protobuf/Solana.pb.dart' as solana_pb;

/// Class that builds transactions and return OutputTx ready for broadcasting.
class BuildTransaction {
  /// BNB Smart Chain native transactions
  ///
  /// `amount` value in gwei
  ///
  /// `gasPrice` and `gasLimit` values in wei
  static Future<String> bnbSmartChain({
    required HDWallet wallet,
    required String amount, // value in gwei (10^9 wei)
    required String toAddress,
    int gasPrice = 3600000000, // value in wei = 10^(-18) ETH (or 10^(-9) gwei)
    int gasLimit = 21000, // price in wei = 10^(-18) ETH (or 10^(-9) gwei)
  }) async {
    final secretPrivateKey =
        wallet.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);
    final tx = ethereum_pb.Transaction_Transfer(
      amount: [int.parse(amount) * 10 ^ 9],
    );
    final signingInput = ethereum_pb.SigningInput(
      // chainId: [1],
      gasPrice: [gasPrice],
      gasLimit: [gasLimit],
      toAddress: toAddress,
      transaction: ethereum_pb.Transaction(transfer: tx),
      privateKey: secretPrivateKey.data(),
    );
    final sign = AnySigner.sign(
        signingInput.writeToBuffer(), TWCoinType.TWCoinTypeSmartChain);
    final signingOutput = ethereum_pb.SigningOutput.fromBuffer(sign);
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
      final response = await latestBlockHashRequest(apiEndpoint: apiEndpoint);
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
      final response = await latestBlockHashRequest(apiEndpoint: apiEndpoint);
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
    final utxoString = await (getUtxo(
        apiEndpoint: apiEndpoint + 'api/v2/utxo/' + changeAddress));
    List<dynamic> utxo = jsonDecode(utxoString);
    if (utxo.isEmpty) {
      throw NoUtxoAvailableException();
    }
    utxo.sort((map1, map2) =>
        int.parse(map1['value']).compareTo(int.parse(map2['value'])));

    var totalAmount = 0;
    const theConsideredFeeInSats = 10000;
    for (var tx in utxo) {
      totalAmount += int.parse(tx['value']);
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
        minUtxoAmountNeed += int.parse(tx['value']);
      }
    }
    utxo = utxo.take(minUtxoNeed).toList();
    List<bitcoin_pb.UnspentTransaction> utxoParsed = [];
    for (var index = 0; index <= utxo.length - 1; index++) {
      final txParsed = bitcoin_pb.UnspentTransaction(
        amount: $fixnum.Int64.parseInt(utxo[index]['value']),
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
}
