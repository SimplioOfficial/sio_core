# sio_core

Simplio wallet core library for blockchain interactions, developed in Dart, can be used in Flutter framework.

Sio_core library is working hand in hand with [trust_wallet_core_lib](https://github.com/ciripel/trust_wallet_core_lib),
so please check the setup of trust_wallet_core_lib.

### Example:
```
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sio_core/sio_core.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart' as trust_core;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sio_core example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'sio_core example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late trust_core.HDWallet wallet;

  final mnemonic =
      'horror select baby exile convince sunset outside vehicle write decade powder energy';

  Future<String> example() async {
    if (Mnemonic.isValid(mnemonic: mnemonic)) {
      wallet = Mnemonic.import(mnemonic: mnemonic);
    } else {
      throw Exception(['Mnemonic is not valid!']);
    }
    // ignore: unused_local_variable
    final solAddress = wallet.getAddressForCoin(TWCoinType.TWCoinTypeSolana);
    print('My solana address: $solAddress');

    var toAddress = '3fTR8GGL2mniGyHtd3Qy2KDVhZ9LHbW59rCc7A3RtBWk';

    var amount = '2000';

    try {
      final latestBlockHash = await UtilsSolana.latestBlockHashRequest(
          apiEndpoint: 'https://api.mainnet-beta.solana.com/');
      print(latestBlockHash);
      final signedSolanaTx = BuildTransaction.solana(
        recipient: toAddress,
        amount: amount,
        wallet: wallet,
        latestBlockHash: latestBlockHash,
      );
      print(signedSolanaTx.toJson());
      try {
        // Broadcasting will throw exception - it is normal unless u move funds in your solana address
        final broadcastSolanaTx = await Broadcast.solana(
          signedTxEncoded: signedSolanaTx.rawTx!,
          apiEndpoint: 'https://api.mainnet-beta.solana.com',
        );
        print(broadcastSolanaTx);
      } catch (exception) {
        print(exception);
      }
    } catch (exception) {
      print(exception);
    }

    const tokenMintAddress = 'SioTkQxHyAs98ouRiyi1YDv3gLMSrX3eNBg61GH7NrM';
    try {
      final latestBlockHash = await UtilsSolana.latestBlockHashRequest(
          apiEndpoint: 'https://api.mainnet-beta.solana.com/');
      print(latestBlockHash);
      final signedSolanaTokenTx = BuildTransaction.solanaToken(
        amount: amount,
        decimals: 8,
        tokenMintAddress: tokenMintAddress,
        recipientSolanaAddress: toAddress,
        wallet: wallet,
        latestBlockHash: latestBlockHash,
      );
      print(signedSolanaTokenTx.toJson());
      final broadcastSolanaTokenTx = await Broadcast.solana(
        signedTxEncoded: signedSolanaTokenTx.rawTx!,
        apiEndpoint: 'https://api.mainnet-beta.solana.com/',
      );
      // Broadcasting will throw exception - it is normal unless u move funds in your solana address
      print(broadcastSolanaTokenTx);
    } catch (exception) {
      print(exception);
    }

    return 'Success';
  }

  @override
  void initState() {
    trust_core.TrustWalletCoreLib.init();
    super.initState();
    example();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[],
      ),
    );
  }
}
```

List of supported chains [here](list_of_coins.md).
