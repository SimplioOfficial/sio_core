import 'dart:convert';

import 'package:sio_core/sio_core.dart';
import 'package:test/test.dart';

void main() {
  group('Get balance for Cosmos coin - ', () {
    test('Cosmos', () async {
      const address = 'cosmos1rlwemt45ryzc8ynakzwgfkltm7jy8lswfg6qcp';
      final balance = await GetBalance.cosmos(
        address: address,
        apiEndpoint: 'https://api.cosmos.network/',
        denomination: 'uatom',
      );
      expect(balance, BigInt.zero);
    });
    test('Cosmos existent positive', () async {
      const address = 'cosmos1ryfjy25gmqxkggyxjrz93lrv5tc9q3rzzkhvtr';
      final balance = await GetBalance.cosmos(
        address: address,
        apiEndpoint: 'https://api.cosmos.network/',
        denomination: 'uatom',
      );
      expect(balance, greaterThan(BigInt.parse('-1')));
    });
    test('Osmosis', () async {
      const address = 'osmo18ue9y4nwmqm3qp4fh3vyxyle8qq3xr4hevmvgw';
      final balance = await GetBalance.cosmos(
        address: address,
        apiEndpoint: 'https://lcd-osmosis.keplr.app/',
        denomination: 'uosmo',
      );
      expect(balance, BigInt.zero);
    });
    test('Osmosis search inexistent denomination', () async {
      const address = 'osmo1ryfjy25gmqxkggyxjrz93lrv5tc9q3rz2dyua3';
      final balance = await GetBalance.cosmos(
        address: address,
        apiEndpoint: 'https://lcd-osmosis.keplr.app/',
        denomination: 'uatom',
      );
      expect(balance, BigInt.zero);
    });
    test('Osmosis exception', () async {
      const address = 'osmo1rlwemt45ryzc8ynakzwgfkltm7jy8lswpnfsw';
      try {
        await GetBalance.cosmos(
          address: address,
          apiEndpoint: 'https://lcd-osmosis.keplr.app/',
          denomination: 'uosmo',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    // test('Terra', () async {
    //   const address = 'terra1rva9a70xc3vpvdezn60jerz4ywqa5uey7nefps';
    //   final balance = await GetBalance.cosmos(
    //     address: address,
    //     apiEndpoint: 'https://lcd.terra.dev/',
    //     denomination: 'uluna',
    //   );
    //   expect(balance, BigInt.zero);
    // });
    // test('Terra existent positive', () async {
    //   const address = 'terra1whevxvk66j7p4c0rgm0fzzep4hywrm6sytfh0j';
    //   final balance = await GetBalance.cosmos(
    //     address: address,
    //     apiEndpoint: 'https://lcd.terra.dev/',
    //     denomination: 'uluna',
    //   );
    //   expect(balance, greaterThan(BigInt.parse('-1')));
    // });
  });

  group('Get balance for Ethereum coin - ', () {
    test('BNB Smart Chain', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      final balance = await GetBalance.ethereumRPC(
        address: address,
        apiEndpoint: 'https://bsc-dataseed.binance.org/',
      );
      expect(balance, BigInt.zero);
    });
    test('BNB Smart Chain error', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df';
      try {
        await GetBalance.ethereumRPC(
          address: address,
          apiEndpoint: 'https://bsc-dataseed.binance.org/',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('BNB Smart Chain BEP20 Token', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      const contractAddress = '0xe9e7cea3dedca5984780bafc599bd69add087d56';
      final balance = await GetBalance.ethereumERC20Scan(
        address: address,
        contractAddress: contractAddress,
        apiEndpoint:
            'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=$bscScanToken',
      );
      expect(balance, BigInt.zero);
    });
    test('BNB Smart Chain BEP20 Token error', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df';
      const contractAddress = '0xe9e7cea3dedca5984780bafc599bd69add08';
      try {
        await GetBalance.ethereumERC20Scan(
          address: address,
          contractAddress: contractAddress,
          apiEndpoint:
              'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=$bscScanToken',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Ethereum', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      final balance = await GetBalance.ethereumRPC(
        address: address,
        apiEndpoint: 'https://mainnet.infura.io/v3/$infuraToken',
      );
      expect(balance, BigInt.zero);
    });
    test('Ethereum ERC20 Token', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      const contractAddress = '0x57d90b64a1a57749b0f932f1a3395792e12e7055';
      final balance = await GetBalance.ethereumERC20Scan(
        address: address,
        contractAddress: contractAddress,
        apiEndpoint:
            'https://api.etherscan.io/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=$etherScanToken',
      );
      expect(balance, BigInt.zero);
    });
    test('Polygon', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      final balance = await GetBalance.ethereumRPC(
        address: address,
        apiEndpoint: 'https://polygon-rpc.com/',
      );
      expect(balance, BigInt.zero);
    });
    test('Polygon ERC20 Token', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      const contractAddress = '0x5918Fa85f0a3DdC00Ce145CBA21D5540d25c5cc7';
      final balance = await GetBalance.ethereumERC20Scan(
        address: address,
        contractAddress: contractAddress,
        apiEndpoint:
            'https://api.polygonscan.com/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=$polygonScanToken1',
      );
      expect(balance, BigInt.zero);
    });
    test('Avalanche', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      final balance = await GetBalance.ethereumRPC(
        address: address,
        apiEndpoint: 'https://api.avax.network/ext/bc/C/rpc',
      );
      expect(balance, BigInt.zero);
    });
    test('Avalanche ERC20 Token', () async {
      const address = '0x6A86087Ee103DCC2494cA2804e4934b913df84E8';
      const contractAddress = '0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E';
      final balance = await GetBalance.ethereumERC20Scan(
        address: address,
        contractAddress: contractAddress,
        apiEndpoint:
            'https://api.snowtrace.io/api?module=account&action=tokenbalance&contractaddress=<contractAddress>&address=<address>&tag=latest&apikey=$snowTraceToken',
      );
      expect(balance, BigInt.zero);
    });
    test('Ethereum Classic', () async {
      const address = '0x9C35cd0398E9c8f61258cCdC822233da2D8228a2';
      final balance = await GetBalance.ethereumBlockbook(
        address: address,
        apiEndpoint: 'https://etcblockexplorer.com/',
      );
      expect(balance, BigInt.zero);
    });
    test('Ethereum Classic error', () async {
      const address = '0x9C35cd0398E9c8f61258cCdC822233da2D82';
      try {
        await GetBalance.ethereumBlockbook(
          address: address,
          apiEndpoint: 'https://etcblockexplorer.com/',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Ethereum Classic ETC20 Token', () async {
      const address = '0x9C35cd0398E9c8f61258cCdC822233da2D8228a2';
      const contractAddress = '0x57d90b64a1a57749b0f932f1a3395792e12e7055';
      final balance = await GetBalance.ethereumERC20Blockbook(
        address: address,
        contractAddress: contractAddress,
        apiEndpoint: 'https://etcblockexplorer.com/',
      );
      expect(balance, BigInt.zero);
    });
    test('Ethereum Classic ETC20 Token implicit BigInt.zero', () async {
      const address = '0x734Ac651Dd95a339c633cdEd410228515F97fAfF';
      const contractAddress = '0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39';
      final balance = await GetBalance.ethereumERC20Blockbook(
        address: address,
        contractAddress: contractAddress,
        apiEndpoint: 'https://etcblockexplorer.com/',
      );
      expect(balance, BigInt.zero);
    });
    test('Ethereum Classic ETC20 Token error', () async {
      const address = '0x9C35cd0398E9c8f61258cCdC822233da2D82';
      const contractAddress = '0x57d90b64a1a57749b0f932f1a3395792e12e';
      try {
        await GetBalance.ethereumERC20Blockbook(
          address: address,
          contractAddress: contractAddress,
          apiEndpoint: 'https://etcblockexplorer.com/',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
  });

  group('Get balance for Solana - ', () {
    test('Solana', () async {
      const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJCu4f';
      final balance = await GetBalance.solana(
        apiEndpoint: 'https://api.devnet.solana.com/',
        address: address,
      );
      expect(balance, BigInt.zero);
    });
    test('Solana error', () async {
      const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJ';
      try {
        await GetBalance.solana(
          apiEndpoint: 'https://api.devnet.solana.com/',
          address: address,
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Solana specific token', () async {
      const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJCu4f';
      const tokenMintAddress =
          '4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R'; //Raydium
      final balance = await GetBalance.solanaToken(
        address: address,
        tokenMintAddress: tokenMintAddress,
        apiEndpoint: 'https://api.mainnet-beta.solana.com/',
      );
      expect(balance, BigInt.zero);
    });
    test('Solana specific token error', () async {
      const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJ';
      const tokenMintAddress =
          '4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R'; //Raydium
      try {
        await GetBalance.solanaToken(
          address: address,
          tokenMintAddress: tokenMintAddress,
          apiEndpoint: 'https://api.mainnet-beta.solana.com/',
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Solana specific token existent positive', () async {
      const address = '3fTR8GGL2mniGyHtd3Qy2KDVhZ9LHbW59rCc7A3RtBWk';
      const tokenMintAddress =
          '4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R'; //Raydium
      final balance = await GetBalance.solanaToken(
        address: address,
        tokenMintAddress: tokenMintAddress,
        apiEndpoint: 'https://api.mainnet-beta.solana.com/',
      );
      expect(balance, greaterThan(BigInt.parse('-1')));
    });
    test('Solana all tokens', () async {
      const address = 'HnVnY6kD8BqTXo2G2yDmckKnN2H821pkWhvRsheJCu4f';
      final balance = await GetBalance.solanaAllTokens(
        address: address,
        apiEndpoint: 'https://api.mainnet-beta.solana.com/',
      );
      expect(jsonDecode(balance), isMap);
      expect(jsonDecode(balance)['result']['value'], []);
    });
  });

  group('Get balance for utxoCoin - ', () {
    test('Bitcoin', () async {
      const address = 'bc1qwquauyfgqgwh2gc9td8dhrf00432duh77wvxy5';
      final balance = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://btc1.simplio.io/',
        address: address,
      );
      expect(balance, BigInt.zero);
    });
    test('Bitcoin Cash', () async {
      const address = 'bitcoincash:qphjd0f4jeg9naf29u6tkakv800wgksyhvsamcpdd2';
      final balance = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://bch1.trezor.io/',
        address: address,
      );
      expect(balance, BigInt.zero);
    });
    test('Dash', () async {
      const address = 'XgbeASTQTNgPuTyAWb8NVDWVDmhgKJrfRV';
      final balance = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://dash1.simplio.io/',
        address: address,
      );
      expect(balance, BigInt.zero);
    });
    test('DigiByte', () async {
      const address = 'dgb1qshqfysjmxpl0dv5ryjeg8k4tkdp2pfk6k0gvdq';
      final balance = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://dgb1.simplio.io/',
        address: address,
      );
      expect(balance, BigInt.zero);
    });
    test('Doge', () async {
      const address = 'DTbELQaWmv5KpFcNpZ9X9wy5RjQGL4YMm2';
      final balance = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://doge1.simplio.io/',
        address: address,
      );
      expect(balance, BigInt.zero);
    });
    test('Flux', () async {
      const address = 't1amMB14YTcUktfjHrz42XcDb2tdHmjgMQd';
      final balance = await GetBalance.utxoCoinInsight(
        apiEndpoint: 'https://explorer.runonflux.io/',
        address: address,
      );
      expect(balance, BigInt.zero);
    });
    test('Litecoin', () async {
      const address = 'ltc1q4jd8494yun73v5ul2wcl5p32lcxm66afx4efr6';
      final balance = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://ltc1.simplio.io/',
        address: address,
      );
      expect(balance, BigInt.zero);
    });
    test('Litecoin exception', () async {
      const address = 'bitcoincash:qphjd0f4jeg9naf29u6tkakv800wgksyhvsamcpdd2';
      try {
        await GetBalance.utxoCoinBlockbook(
          apiEndpoint: 'https://ltc1.simplio.io/',
          address: address,
        );
      } catch (exception) {
        expect(exception, isA<Exception>());
      }
    });
    test('Zcash', () async {
      const address = 't1RTNMRyJhc1UgfvrTSqFP46C5xuyxjJGeR';
      final balance = await GetBalance.utxoCoinBlockbook(
        apiEndpoint: 'https://zec1.simplio.io/',
        address: address,
      );
      expect(balance, BigInt.zero);
    });
  });
}
