# Multi-Chain Wallet Design

## Goal

支持 ETH、BTC、SOL 三条链，使用同一 BIP39 助记词按 BIP44 标准派生各链地址，主页以统一视图（总 USD 余额 + 所有链资产列表）展示。

## Architecture

采用 **ChainAdapter 抽象接口**，每条链独立实现，Riverpod 层聚合多链数据。

### ChainAdapter Interface

```dart
abstract class ChainAdapter {
  ChainId get chainId;
  String get name;
  String get nativeSymbol;

  Future<String> deriveAddress(Uint8List seedBytes);
  Future<double> getNativeBalance(String address);
  Future<double> getUsdPrice();
  Future<List<TransactionModel>> getTransactions(String address);
}
```

### HD Derivation Paths (BIP44)

| Chain    | Algorithm  | Path                  | Package          |
|----------|------------|-----------------------|------------------|
| Ethereum | secp256k1  | m/44'/60'/0'/0/0      | bip32 (new)      |
| Bitcoin  | secp256k1  | m/84'/0'/0'/0/0       | bip32 (new)      |
| Solana   | ed25519    | m/44'/501'/0'/0'      | ed25519_hd_key   |

> ⚠️ Breaking change: current ETH key derivation uses ed25519 master key directly (non-standard). New code uses proper BIP44 secp256k1 path — existing wallet ETH addresses will change.

### Balance & Price APIs (No API Key)

| Chain | Balance API              | Price API  |
|-------|--------------------------|------------|
| ETH   | web3dart (existing)      | CoinGecko  |
| BTC   | mempool.space/api/address| CoinGecko  |
| SOL   | Solana mainnet RPC       | CoinGecko  |

CoinGecko single request for all prices:
`/simple/price?ids=ethereum,bitcoin,solana&vs_currencies=usd`

## Data Model Changes

### WalletModel

Add `addresses` map to store all chain addresses:
```dart
Map<String, String>? addresses; // {'eth': '0x...', 'btc': 'bc1...', 'sol': '...'}
```
Keep existing `privateKey` / `publicKey` fields for backward compatibility.

### TokenAssetModel

Add `chain` and `isNative` fields:
```dart
required String chain;      // 'eth' | 'btc' | 'sol'
@Default(false) bool isNative;
// contractAddress = 'native' for ETH/BTC/SOL
```

### TransactionModel

Add `chain` field:
```dart
@Default('eth') String chain;
```

## New Packages

- `bip32`: secp256k1 HD key derivation (ETH + BTC paths)
- `pointycastle`: crypto primitives for BTC address (SHA256, RIPEMD160) — likely already transitive

## Riverpod Layer

```dart
final chainAdaptersProvider = Provider<List<ChainAdapter>>(...)
final chainPricesProvider = FutureProvider<Map<ChainId, double>>(...)
final nativeBalanceProvider = FutureProvider.family<double, ({ChainId, String address})>(...)
final totalUsdBalanceProvider = FutureProvider<double>(...)
```

## UI Changes

- **Balance section**: sum of all chains in USD
- **Assets tab**: ETH / BTC / SOL native assets at top, then ERC-20 tokens (ETH chain only)
- **Activity tab**: ETH transactions only (BTC/SOL transaction format too different — future iteration)
- **AppBar**: "Multi-Chain Wallet" label; address display shows ETH address (primary)

## File Structure

```
lib/
  domain/
    models/
      chain_id.dart           (new — ChainId enum)
      token_asset_model.dart  (update — add chain, isNative)
      transaction_model.dart  (update — add chain)
      wallet_model.dart       (update — add addresses map)
    repositories/
      chain_adapter.dart      (new — abstract interface)
  data/
    adapters/
      eth_chain_adapter.dart  (new)
      btc_chain_adapter.dart  (new)
      sol_chain_adapter.dart  (new)
    providers/
      chain_provider.dart     (new — chainAdaptersProvider, prices, balances)
      wallet_data_provider.dart (update — use chainAdaptersProvider)
    repositories/
      phrase_repository_impl.dart (update — BIP44 derivation for all chains)
```

## Scope Limits

- Send/receive for BTC and SOL: out of scope (future)
- ERC-20 tokens: ETH chain only (existing)
- Activity tab: ETH only (existing)
- Wallet import (existing seed): will generate new ETH address due to derivation path fix
