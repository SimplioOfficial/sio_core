// ignore_for_file: avoid_print

// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sio_core/sio_core.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart' as trust_core;
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';

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
      "horror select baby exile convince sunset outside vehicle write decade powder energy";

  Future<String> example() async {
    if (Mnemonic.isValid(mnemonic: mnemonic)) {
      wallet = Mnemonic.import(mnemonic: mnemonic);
    } else {
      throw Exception(['Mnemonic is not valid!']);
    }
    // ignore: unused_local_variable
    final solAddress = wallet.getAddressForCoin(TWCoinType.TWCoinTypeSolana);

    // These methods do not exist until 0.0.5 so were commented out to
    // allow CI to succeed.

    // const toAddress = '3fTR8GGL2mniGyHtd3Qy2KDVhZ9LHbW59rCc7A3RtBWk';
    // const tokenMintAddress = 'SioTkQxHyAs98ouRiyi1YDv3gLMSrX3eNBg61GH7NrM';
    // const amount = '2000';

    // final signedSolanaTx = await BuildTransaction.solana(
    //   recipient: toAddress,
    //   amount: amount,
    //   wallet: wallet,
    //   apiEndpoint: 'https://api.devnet.solana.com',
    // );
    // print(signedSolanaTx);
    // final broadcastSolanaTx = await Broadcast.solana(
    //   signedTxEncoded: signedSolanaTx,
    //   apiEndpoint: 'https://api.devnet.solana.com',
    // );
    // print(broadcastSolanaTx);

    // final signedSolanaTokenTx = await BuildTransaction.solanaToken(
    //   amount: amount,
    //   decimals: 8,
    //   tokenMintAddress: tokenMintAddress,
    //   recipientSolanaAddress: toAddress,
    //   wallet: wallet,
    //   apiEndpoint: 'https://api.devnet.solana.com',
    // );
    // print(signedSolanaTokenTx);
    // final broadcastSolanaTokenTx = await Broadcast.solana(
    //   signedTxEncoded: signedSolanaTx,
    //   apiEndpoint: 'https://api.devnet.solana.com',
    // );
    // print(broadcastSolanaTokenTx);

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
