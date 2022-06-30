## 0.0.12
* Implement MATIC native transactions and MATIC token transactions.
* Now supports EIP-1559 Transaction Type as well as Legacy Transactions.
## 0.0.11
* Refactor BuildTransaction so it returns also fee estimation for the built transaction.
* Get Fee and Gas Price need for transactions broadcasting.
* Utils requests have been properly parsed and error handled.
* Additional needed util functions.
* Add table of supported coins.
* Increase CI emulator API to 31 on x86_64.
* Fix utxos parsing for insight explorers
## 0.0.10
* Implement decimals request for supported coin and tokens.
* Refactor broadcast transactions for supported coins and tokens.
* Implemented get smallest denomination for cosmos blockchains.
## 0.0.9
* Implement transactions history for all supported coin and tokens.
## 0.0.8
* Refactor get balance and broadcast to chain types.
* Refactor get balance for all supported coins and tokens to return value in
  BigInt.
## 0.0.7
* Implement ATOM, LUNA, OSMO native transactions.
* Implement get balance for all supported coins and tokens.
## 0.0.6
* Implement BSC, ETH, ETC native transactions and BSC, ETH token transactions.
* Implement BTC, BCH, DASH, DGB, DOGE, FLUX, LTC, ZEC transactions.
## 0.0.5
* Implement Solana native transactions and Solana token transactions.
## 0.0.4
* Implement mnemonic operations.
## 0.0.3
* Test continuous delivery on github release.
## 0.0.2
* Just a test for pub.dev.
## 0.0.1
* This release is a meant to be a proof of concept and to test if this can be
  installed in another flutter app.
