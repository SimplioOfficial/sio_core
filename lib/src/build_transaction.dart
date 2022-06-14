import 'package:convert/convert.dart';
import 'package:sio_core/sio_core.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:trust_wallet_core_lib/protobuf/Bitcoin.pb.dart' as bitcoin_pb;
import 'package:trust_wallet_core_lib/protobuf/Cosmos.pb.dart' as cosmos_pb;
import 'package:trust_wallet_core_lib/protobuf/Ethereum.pb.dart' as ethereum_pb;
import 'package:trust_wallet_core_lib/protobuf/Solana.pb.dart' as solana_pb;

class _Transaction {
  final String? rawTx;
  final BigInt? networkFee;

  _Transaction({
    this.rawTx,
    this.networkFee,
  });

  Map<String, dynamic> toJson() {
    return {
      'txid': rawTx,
      'networkFee': networkFee.toString(),
    };
  }
}

/// Class that builds transactions and return OutputTx ready for broadcasting.
class BuildTransaction {
  /// BNB Smart Chain native transactions.
  ///
  /// `amount` value in gwei.
  ///
  /// `gasPrice` and `gasLimit` values in wei.
  static _Transaction bnbSmartChain({
    required HDWallet wallet,
    // value in gwei (10^9 wei)
    required String amount,
    required String toAddress,
    required String nonce,
    // value in wei = 10^(-18) BNB (or 10^(-9) gwei)
    String gasPrice = '13600000000',
    // price in wei = 10^(-18) BNB (or 10^(-9) gwei)
    String gasLimit = '21000',
    // change chainId to 97 for testnet chain
    int chainId = 56,
  }) {
    final secretPrivateKey =
        wallet.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);
    final tx = ethereum_pb.Transaction_Transfer(
      amount: bigIntToBytes(BigInt.parse(amount + '000000000')),
    );
    final signingInput = ethereum_pb.SigningInput(
      chainId: [chainId],
      gasPrice: bigIntToBytes(BigInt.parse(gasPrice)),
      gasLimit: bigIntToBytes(BigInt.parse(gasLimit)),
      toAddress: toAddress,
      transaction: ethereum_pb.Transaction(transfer: tx),
      privateKey: secretPrivateKey.data(),
      nonce: bigIntToBytes(BigInt.parse(nonce)),
    );
    final sign = AnySigner.sign(
        signingInput.writeToBuffer(), TWCoinType.TWCoinTypeSmartChain);
    final signingOutput = ethereum_pb.SigningOutput.fromBuffer(sign);
    final transaction = _Transaction(
      rawTx: hex.encode(signingOutput.encoded),
      networkFee: BigInt.parse(gasPrice) * BigInt.parse(gasLimit),
    );
    return transaction;
  }

  /// BNB Smart Chain token transactions.
  ///
  /// `amount` value in smallest denomination.
  ///
  /// `gasPrice` and `gasLimit` values in wei.
  static _Transaction bnbSmartChainBEP20Token({
    required HDWallet wallet,
    // value in smallest denomination
    required String amount,
    required String tokenContract,
    required String toAddress,
    required String nonce,
    // value in wei = 10^(-18) BNB (or 10^(-9) gwei)
    String gasPrice = '3600000000',
    // price in wei = 10^(-18) BNB (or 10^(-9) gwei)
    String gasLimit = '21000',
    // change chainId to 97 for testnet chain
    int chainId = 56,
  }) {
    final secretPrivateKey =
        wallet.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);

    final tx = ethereum_pb.Transaction_ERC20Transfer(
      amount: bigIntToBytes(BigInt.parse(amount)),
      to: toAddress,
    );

    final signingInput = ethereum_pb.SigningInput(
      chainId: [chainId],
      gasPrice: bigIntToBytes(BigInt.parse(gasPrice)),
      gasLimit: bigIntToBytes(BigInt.parse(gasLimit)),
      toAddress: tokenContract, // yes here must be tokenContract (crazy right?)
      transaction: ethereum_pb.Transaction(erc20Transfer: tx),
      privateKey: secretPrivateKey.data(),
      nonce: bigIntToBytes(BigInt.parse(nonce)),
    );
    final sign = AnySigner.sign(
        signingInput.writeToBuffer(), TWCoinType.TWCoinTypeSmartChain);
    final signingOutput = ethereum_pb.SigningOutput.fromBuffer(sign);
    final transaction = _Transaction(
      rawTx: hex.encode(signingOutput.encoded),
      networkFee: BigInt.parse(gasPrice) * BigInt.parse(gasLimit),
    );
    return transaction;
  }

  /// Cosmos native transactions.
  ///
  /// Denomination of OSMO: `uosmo`, `mosmo`, `osmo`.
  ///
  /// ChainId of OSMO: `osmosis-1`.
  ///
  /// BroadcastMode enum: `0-BLOCK`, `1-SYNC`, `2-ASYNC`.
  static _Transaction cosmos({
    required HDWallet wallet,
    required int coin,
    required String amount,
    required String toAddress,
    required String chainId,
    required String denomination,
    required String accountNumber,
    required String sequence,
    String fee = '0',
    String gas = '200000',
    int broadcastMode = 0,
  }) {
    final messageSend = cosmos_pb.Message_Send(
      amounts: [
        cosmos_pb.Amount(
          amount: $fixnum.Int64.parseInt(amount),
          denom: denomination,
        )
      ],
      fromAddress: wallet.getAddressForCoin(coin),
      toAddress: toAddress,
    );
    final signingInput = cosmos_pb.SigningInput(
      signingMode: cosmos_pb.SigningMode.Protobuf,
      chainId: chainId,
      messages: [cosmos_pb.Message(sendCoinsMessage: messageSend)],
      fee: cosmos_pb.Fee(
        amounts: [
          cosmos_pb.Amount(
            amount: $fixnum.Int64.parseInt(fee),
            denom: denomination,
          )
        ],
        gas: $fixnum.Int64.parseInt(gas),
      ),
      privateKey: wallet.getKeyForCoin(coin).data(),
      memo: '',
      accountNumber: $fixnum.Int64.parseInt(accountNumber),
      sequence: $fixnum.Int64.parseInt(sequence),
      mode: cosmos_pb.BroadcastMode.valueOf(broadcastMode),
    );
    final sign = AnySigner.sign(signingInput.writeToBuffer(), coin);
    final signingOutput = cosmos_pb.SigningOutput.fromBuffer(sign);
    final transaction = _Transaction(
      rawTx: signingOutput.serialized,
      networkFee: BigInt.parse(fee),
    );
    return transaction;
  }

  /// Ethereum native transactions.
  ///
  /// `amount` value in gwei.
  ///
  /// `gasPrice` and `gasLimit` values in wei.
  static _Transaction ethereum({
    required HDWallet wallet,
    // value in gwei (10^9 wei)
    required String amount,
    required String toAddress,
    required String nonce,
    // value in wei = 10^(-18) ETH (or 10^(-9) gwei)
    String gasPrice = '13600000000',
    // price in wei = 10^(-18) ETH (or 10^(-9) gwei)
    String gasLimit = '21000',
    int chainId = 1,
  }) {
    final secretPrivateKey =
        wallet.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);
    final tx = ethereum_pb.Transaction_Transfer(
      amount: bigIntToBytes(BigInt.parse(amount + '000000000')),
    );
    final signingInput = ethereum_pb.SigningInput(
      chainId: [chainId],
      gasPrice: bigIntToBytes(BigInt.parse(gasPrice)),
      gasLimit: bigIntToBytes(BigInt.parse(gasLimit)),
      toAddress: toAddress,
      transaction: ethereum_pb.Transaction(transfer: tx),
      privateKey: secretPrivateKey.data(),
      nonce: bigIntToBytes(BigInt.parse(nonce)),
    );
    final sign = AnySigner.sign(
        signingInput.writeToBuffer(), TWCoinType.TWCoinTypeSmartChain);
    final signingOutput = ethereum_pb.SigningOutput.fromBuffer(sign);
    final transaction = _Transaction(
      rawTx: hex.encode(signingOutput.encoded),
      networkFee: BigInt.parse(gasPrice) * BigInt.parse(gasLimit),
    );
    return transaction;
  }

  /// Ethereum ERC20 token transactions.
  ///
  /// `amount` value in smallest denomination.
  ///
  /// `gasPrice` and `gasLimit` values in wei.
  static _Transaction ethereumERC20Token({
    required HDWallet wallet,
    // value in smallest denomination
    required String amount,
    required String tokenContract,
    required String toAddress,
    required String nonce,
    // value in wei = 10^(-18) ETH (or 10^(-9) gwei)
    String gasPrice = '3600000000',
    // price in wei = 10^(-18) ETH (or 10^(-9) gwei)
    String gasLimit = '21000',
    int chainId = 1,
  }) {
    final secretPrivateKey =
        wallet.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);

    final tx = ethereum_pb.Transaction_ERC20Transfer(
      amount: bigIntToBytes(BigInt.parse(amount)),
      to: toAddress,
    );

    final signingInput = ethereum_pb.SigningInput(
      chainId: [chainId],
      gasPrice: bigIntToBytes(BigInt.parse(gasPrice)),
      gasLimit: bigIntToBytes(BigInt.parse(gasLimit)),
      toAddress: tokenContract, // yes here must be tokenContract (crazy right?)
      transaction: ethereum_pb.Transaction(erc20Transfer: tx),
      privateKey: secretPrivateKey.data(),
      nonce: bigIntToBytes(BigInt.parse(nonce)),
    );
    final sign = AnySigner.sign(
        signingInput.writeToBuffer(), TWCoinType.TWCoinTypeSmartChain);
    final signingOutput = ethereum_pb.SigningOutput.fromBuffer(sign);
    final transaction = _Transaction(
      rawTx: hex.encode(signingOutput.encoded),
      networkFee: BigInt.parse(gasPrice) * BigInt.parse(gasLimit),
    );
    return transaction;
  }

  /// Ethereum Classic native transactions.
  ///
  /// `amount` value in gwei.
  ///
  /// `gasPrice` and `gasLimit` values in wei.
  static _Transaction ethereumClassic({
    required HDWallet wallet,
    // value in gwei (10^9 wei)
    required String amount,
    required String toAddress,
    required String nonce,
    // value in wei = 10^(-18) ETC (or 10^(-9) gwei)
    String gasPrice = '13600000000',
    // price in wei = 10^(-18) ETC (or 10^(-9) gwei)
    String gasLimit = '21000',
    int chainId = 61,
  }) {
    final secretPrivateKey =
        wallet.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);
    final tx = ethereum_pb.Transaction_Transfer(
      amount: bigIntToBytes(BigInt.parse(amount + '000000000')),
    );
    final signingInput = ethereum_pb.SigningInput(
      chainId: [chainId],
      gasPrice: bigIntToBytes(BigInt.parse(gasPrice)),
      gasLimit: bigIntToBytes(BigInt.parse(gasLimit)),
      toAddress: toAddress,
      transaction: ethereum_pb.Transaction(transfer: tx),
      privateKey: secretPrivateKey.data(),
      nonce: bigIntToBytes(BigInt.parse(nonce)),
    );
    final sign = AnySigner.sign(
        signingInput.writeToBuffer(), TWCoinType.TWCoinTypeSmartChain);
    final signingOutput = ethereum_pb.SigningOutput.fromBuffer(sign);
    final transaction = _Transaction(
      rawTx: hex.encode(signingOutput.encoded),
      networkFee: BigInt.parse(gasPrice) * BigInt.parse(gasLimit),
    );
    return transaction;
  }

  /// Solana native transaction.
  static _Transaction solana({
    required HDWallet wallet,
    required String recipient,
    required String amount,
    required String latestBlockHash,
    String fee = '5000',
  }) {
    final secretPrivateKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeSolana);

    final tx = solana_pb.Transfer(
      recipient: recipient,
      value: $fixnum.Int64.parseInt(amount),
    );
    final signingInput = solana_pb.SigningInput(
      privateKey: secretPrivateKey.data().toList(),
      recentBlockhash: latestBlockHash,
      transferTransaction: tx,
    );
    final sign = AnySigner.sign(
      signingInput.writeToBuffer(),
      TWCoinType.TWCoinTypeSolana,
    );
    final signingOutput = solana_pb.SigningOutput.fromBuffer(sign);
    final transaction = _Transaction(
      rawTx: signingOutput.encoded,
      networkFee: BigInt.parse(fee),
    );
    return transaction;
  }

  /// Solana token transaction.
  static _Transaction solanaToken({
    required HDWallet wallet,
    required String recipientSolanaAddress,
    required String tokenMintAddress,
    required String amount,
    required int decimals,
    required String latestBlockHash,
    String fee = '5000',
  }) {
    final secretPrivateKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeSolana);

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
      recentBlockhash: latestBlockHash,
      tokenTransferTransaction: tx,
    );
    final sign = AnySigner.sign(
      signingInput.writeToBuffer(),
      TWCoinType.TWCoinTypeSolana,
    );
    final signingOutput = solana_pb.SigningOutput.fromBuffer(sign);
    final transaction = _Transaction(
      rawTx: signingOutput.encoded,
      networkFee: BigInt.parse(fee),
    );
    return transaction;
  }

  /// Utxo coins transaction.
  static _Transaction utxoCoin({
    required HDWallet wallet,
    required int coin,
    required String toAddress,
    required String amount,
    required String byteFee,
    required List utxo,
  }) {
    final changeAddress = wallet.getAddressForCoin(coin);
    if (utxo.isEmpty) {
      throw NoUtxoAvailableException();
    }
    utxo.sort((map1, map2) =>
        int.parse(map1['value']).compareTo(int.parse(map2['value'])));

    var minUtxoNeed = 0;
    var minUtxoAmountNeed = 0;
    for (var tx in utxo) {
      if (minUtxoAmountNeed < int.parse(amount)) {
        minUtxoNeed++;
        minUtxoAmountNeed += int.parse(tx['value']);
      } else {
        break;
      }
    }
    final minUtxo = utxo.take(minUtxoNeed).toList();

    List<bitcoin_pb.UnspentTransaction> utxoParsed = [];
    for (var index = 0; index < minUtxo.length; index++) {
      final txParsed = bitcoin_pb.UnspentTransaction(
        amount: $fixnum.Int64.parseInt(minUtxo[index]['value']),
        outPoint: bitcoin_pb.OutPoint(
          hash: hex.decode(minUtxo[index]['txid']).reversed.toList(),
          index: minUtxo[index]['vout'],
        ),
        script: BitcoinScript.lockScriptForAddress(
                wallet.getAddressForCoin(coin), coin)
            .data()
            .toList(),
      );
      utxoParsed.add(txParsed);
    }

    var signingInput = bitcoin_pb.SigningInput(
      amount: $fixnum.Int64.parseInt(amount),
      hashType: BitcoinScript.hashTypeForCoin(coin),
      toAddress: toAddress,
      changeAddress: changeAddress,
      byteFee: $fixnum.Int64.parseInt(byteFee),
      coinType: coin,
      utxo: utxoParsed,
      privateKey: [wallet.getKeyForCoin(coin).data().toList()],
    );
    var transactionPlan = bitcoin_pb.TransactionPlan.fromBuffer(
      AnySigner.signerPlan(signingInput.writeToBuffer(), coin).toList(),
    );

    while (
        (int.parse(amount) + transactionPlan.fee.toInt() > minUtxoAmountNeed ||
                transactionPlan.fee.toInt() == 0) &&
            minUtxoNeed < utxo.length) {
      final txParsed = bitcoin_pb.UnspentTransaction(
        amount: $fixnum.Int64.parseInt(utxo[minUtxoNeed]['value']),
        outPoint: bitcoin_pb.OutPoint(
          hash: hex.decode(utxo[minUtxoNeed]['txid']).reversed.toList(),
          index: utxo[minUtxoNeed]['vout'],
        ),
        script: BitcoinScript.lockScriptForAddress(
                wallet.getAddressForCoin(coin), coin)
            .data()
            .toList(),
      );
      utxoParsed.add(txParsed);
      minUtxoAmountNeed += int.parse(utxo[minUtxoNeed]['value']);
      minUtxoNeed++;
      signingInput = bitcoin_pb.SigningInput(
        amount: $fixnum.Int64.parseInt(amount),
        hashType: BitcoinScript.hashTypeForCoin(coin),
        toAddress: toAddress,
        changeAddress: changeAddress,
        byteFee: $fixnum.Int64.parseInt(byteFee),
        coinType: coin,
        utxo: utxoParsed,
        privateKey: [wallet.getKeyForCoin(coin).data().toList()],
      );
      transactionPlan = bitcoin_pb.TransactionPlan.fromBuffer(
        AnySigner.signerPlan(signingInput.writeToBuffer(), coin).toList(),
      );
    }

    if (minUtxoNeed == utxo.length &&
        (transactionPlan.fee.toInt() == 0 ||
            int.parse(amount) + transactionPlan.fee.toInt() >
                minUtxoAmountNeed)) {
      throw LowTotalAmountPLusFeeException();
    }
    signingInput.plan = transactionPlan;
    signingInput.amount = transactionPlan.amount;

    final sign = AnySigner.sign(signingInput.writeToBuffer(), coin);
    final signingOutput = bitcoin_pb.SigningOutput.fromBuffer(sign);
    final transaction = _Transaction(
      rawTx: hex.encode(signingOutput.encoded),
      networkFee: BigInt.parse(transactionPlan.fee.toString()),
    );
    return transaction;
  }
}
