import 'dart:convert';

import 'package:test/test.dart';
import 'package:sio_core/src/get_balance.dart';

void main() {
  group('Get balance for Cosmos coin - ', () {
    test('Cosmos', () async {
      const address = 'cosmos1rlwemt45ryzc8ynakzwgfkltm7jy8lswfg6qcp';
      final response = await GetBalance.cosmos(
        address: address,
        apiEndpoint: 'https://api.cosmos.network/',
        denomination: 'uatom',
      );

      expect(response, BigInt.zero);
    });
    test('Osmosis', () async {
      const address = 'osmo1rlwemt45ryzc8ynakzwgfkltm7jy8lswpnfswn';
      final response = await GetBalance.cosmos(
        address: address,
        apiEndpoint: 'https://lcd-osmosis.keplr.app/',
        denomination: 'uosmo',
      );
      expect(response, BigInt.zero);
    });
    test('Terra', () async {
      const address = 'terra1rva9a70xc3vpvdezn60jerz4ywqa5uey7nefps';
      final response = await GetBalance.cosmos(
        address: address,
        apiEndpoint: 'https://lcd.terra.dev/',
        denomination: 'uluna',
      );
      expect(response, BigInt.zero);
    });
  });

  group('Get balance for Ethereum coin - ', () {
    test('BNB Smart Chain', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      final response = await GetBalance.ethereumRPC(
        address: address,
        apiEndpoint: 'https://bsc-dataseed.binance.org/',
      );
      expect(response, BigInt.zero);
    });
    test('BNB Smart Chain BEP20 Token', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      const contractAddress = '0xe9e7cea3dedca5984780bafc599bd69add087d56';
      final response = await GetBalance.ethereumERC20(
        address: address,
        contractAddress: contractAddress,
        apiEndpoint:
            'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=PED3MB4V1CD3XAIGTQNAVCD8AHG1KSWAPN',
      );
      expect(response, BigInt.zero);
    });
    test('Ethereum', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      final response = await GetBalance.ethereumRPC(
        address: address,
        apiEndpoint:
            'https://mainnet.infura.io/v3/d0b366367e6d4a1b97b2d844397ca182',
      );
      expect(response, BigInt.zero);
    });
    test('Ethereum ERC20 Token', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      const contractAddress = '0x57d90b64a1a57749b0f932f1a3395792e12e7055';
      final response = await GetBalance.ethereumERC20(
        address: address,
        contractAddress: contractAddress,
        apiEndpoint:
            'https://api.etherscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=J6CAMARJ1QMXIIX3VU2PC81BEYU262PIHU',
      );
      expect(response, BigInt.zero);
    });
    test('Ethereum Classic', () async {
      const address = '0x9C35cd0398E9c8f61258cCdC822233da2D8228a2';
      final response = await GetBalance.ethereumBlockbook(
        address: address,
        apiEndpoint: 'https://etcblockexplorer.com/',
      );
      expect(response, BigInt.zero);
    });
    test('Ethereum Classic ETC20 Token', () async {
      const address = '0x9C35cd0398E9c8f61258cCdC822233da2D8228a2';
      const contractAddress = '0x57d90b64a1a57749b0f932f1a3395792e12e7055';
      final response = await GetBalance.ethereumERC20Blockbook(
        address: address,
        contractAddress: contractAddress,
        apiEndpoint: 'https://etcblockexplorer.com/',
      );
      expect(response, BigInt.zero);
    });
  });

  group('Get balance for Solana - ', () {
    test('Solana', () async {
      const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJCu4f';
      final response = await GetBalance.solana(
        apiEndpoint: 'https://api.devnet.solana.com/',
        address: address,
      );
      expect(response, BigInt.zero);
    });
    test('Solana specific token', () async {
      const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJCu4f';
      const tokenMintAddress =
          '4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R'; //Raydium
      final response = await GetBalance.solanaToken(
        address: address,
        tokenMintAddress: tokenMintAddress,
        apiEndpoint: 'https://api.mainnet-beta.solana.com/',
      );
      expect(response, BigInt.zero);
    });
    test('Solana all tokens', () async {
      const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJCu4f';
      final response = await GetBalance.solanaAllTokens(
        address: address,
        apiEndpoint: 'https://api.mainnet-beta.solana.com/',
      );
      expect(jsonDecode(response), isMap);
      expect(jsonDecode(response)['result']['value'], []);
    });
  });

  group('Get balance for utxoCoin - ', () {
    test('Bitcoin', () async {
      const address = 'bc1qwquauyfgqgwh2gc9td8dhrf00432duh77wvxy5';
      final response = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://btc1.simplio.io/',
        address: address,
      );
      expect(response, BigInt.zero);
    });
    test('Bitcoin Cash', () async {
      const address = 'bitcoincash:qphjd0f4jeg9naf29u6tkakv800wgksyhvsamcpdd2';
      final response = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://bch1.simplio.io/',
        address: address,
      );
      expect(response, BigInt.zero);
    });
    test('Dash', () async {
      const address = 'XgbeASTQTNgPuTyAWb8NVDWVDmhgKJrfRV';
      final response = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://dash1.simplio.io/',
        address: address,
      );
      expect(response, BigInt.zero);
    });
    test('DigiByte', () async {
      const address = 'dgb1qshqfysjmxpl0dv5ryjeg8k4tkdp2pfk6k0gvdq';
      final response = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://dgb1.simplio.io/',
        address: address,
      );
      expect(response, BigInt.zero);
    });
    test('Doge', () async {
      const address = 'DTbELQaWmv5KpFcNpZ9X9wy5RjQGL4YMm2';
      final response = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://doge1.simplio.io/',
        address: address,
      );
      expect(response, BigInt.zero);
    });
    test('Flux', () async {
      const address = 't1amMB14YTcUktfjHrz42XcDb2tdHmjgMQd';
      final response = await GetBalance.utxoCoinInsight(
        apiEndpoint: 'https://explorer.runonflux.io/',
        address: address,
      );
      expect(response, BigInt.zero);
    });
    test('Litecoin', () async {
      const address = 'ltc1q4jd8494yun73v5ul2wcl5p32lcxm66afx4efr6';
      final response = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://ltc1.simplio.io/',
        address: address,
      );
      expect(response, BigInt.zero);
    });
    test('Zcash', () async {
      const address = 't1RTNMRyJhc1UgfvrTSqFP46C5xuyxjJGeR';
      final response = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://zec1.simplio.io/',
        address: address,
      );
      expect(response, BigInt.zero);
    });
  });
}
