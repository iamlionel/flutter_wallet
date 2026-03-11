# Multi-Chain Wallet Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 支持 ETH、BTC、SOL 三条链，同一助记词 BIP44 派生各链地址，主页统一显示总 USD 余额和所有链资产。

**Architecture:** 定义抽象 `ChainAdapter` 接口，三个实现类各自负责地址派生、余额查询；`WalletModel` 存储三链地址；Riverpod 层聚合多链数据；CoinGecko 统一获取三链 USD 价格。

**Tech Stack:** Flutter, Riverpod, bip32 (secp256k1 HD), ed25519_hd_key (Solana), pinenacl (ed25519 公钥), bech32 (BTC 地址), bs58 (SOL base58), web3dart (ETH), mempool.space API (BTC), Solana JSON-RPC, CoinGecko API

> ⚠️ **Breaking change:** 当前 ETH 派生使用 ed25519 master key（不标准）。改为 BIP44 secp256k1 path 后，ETH 地址会变化。假设测试钱包无真实资产。

---

### Task 1: 添加新依赖包

**Files:**
- Modify: `pubspec.yaml`

**Step 1: 在 pubspec.yaml dependencies 中添加以下包**

```yaml
  bip32: ^2.0.0
  bech32: ^0.2.1
  pinenacl: ^1.4.0
  bs58: ^1.0.0
```

完整 dependencies 区域（添加在 `flutter_dotenv` 之后）：
```yaml
  bip32: ^2.0.0
  bech32: ^0.2.1
  pinenacl: ^1.4.0
  bs58: ^1.0.0
```

**Step 2: 安装依赖**

```bash
flutter pub get
```

Expected: 成功解析，无冲突

**Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "feat: add bip32, bech32, pinenacl, bs58 packages for multi-chain support"
```

---

### Task 2: ChainId 枚举

**Files:**
- Create: `lib/domain/models/chain_id.dart`

**Step 1: 创建文件**

```dart
// lib/domain/models/chain_id.dart

enum ChainId {
  ethereum('eth'),
  bitcoin('btc'),
  solana('sol');

  const ChainId(this.key);
  final String key; // used as map key in WalletModel.addresses
}
```

**Step 2: Verify**

```bash
flutter analyze lib/domain/models/chain_id.dart
```

Expected: no issues

**Step 3: Commit**

```bash
git add lib/domain/models/chain_id.dart
git commit -m "feat: add ChainId enum"
```

---

### Task 3: 更新 TokenAssetModel

**Files:**
- Modify: `lib/domain/models/token_asset_model.dart`
- Re-run codegen

**Step 1: 更新模型，添加 `chain` 和 `isNative` 字段**

将文件内容替换为：

```dart
// lib/domain/models/token_asset_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_asset_model.freezed.dart';
part 'token_asset_model.g.dart';

@freezed
abstract class TokenAssetModel with _$TokenAssetModel {
  const factory TokenAssetModel({
    @Default('eth') String chain,         // 'eth' | 'btc' | 'sol'
    required String contractAddress,      // 'native' for ETH/BTC/SOL
    required String symbol,
    required String decimal,
    @Default('0') String balance,
    @Default(false) bool isNative,
  }) = _TokenAssetModel;

  factory TokenAssetModel.fromJson(Map<String, dynamic> json) =>
      _$TokenAssetModelFromJson(json);
}
```

**Step 2: 运行 codegen**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: regenerates `token_asset_model.freezed.dart` and `token_asset_model.g.dart`

**Step 3: Commit**

```bash
git add lib/domain/models/token_asset_model.dart lib/domain/models/token_asset_model.freezed.dart lib/domain/models/token_asset_model.g.dart
git commit -m "feat: add chain and isNative fields to TokenAssetModel"
```

---

### Task 4: 更新 TransactionModel

**Files:**
- Modify: `lib/domain/models/transaction_model.dart`
- Re-run codegen

**Step 1: 添加 `chain` 字段**

在 `isErc20` 字段之后添加：

```dart
@Default('eth') String chain,
```

完整文件：

```dart
// lib/domain/models/transaction_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String hash,
    required String from,
    required String to,
    required String value,
    required String timeStamp,
    required String isError,
    @Default('') String tokenSymbol,
    @Default('') String tokenDecimal,
    @Default(false) bool isErc20,
    @Default('eth') String chain,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
```

**Step 2: 运行 codegen**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Commit**

```bash
git add lib/domain/models/transaction_model.dart lib/domain/models/transaction_model.freezed.dart lib/domain/models/transaction_model.g.dart
git commit -m "feat: add chain field to TransactionModel"
```

---

### Task 5: 更新 WalletModel

**Files:**
- Modify: `lib/domain/models/wallet_model.dart`
- Re-run codegen

**Step 1: 添加 `addresses` 字段**

```dart
// lib/domain/models/wallet_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const factory WalletModel({
    @JsonKey(name: 'private_key') String? privateKey,
    @JsonKey(name: 'public_key') String? publicKey,
    @Default({}) Map<String, String> addresses,
    // addresses = {'eth': '0x...', 'btc': 'bc1...', 'sol': '...'}
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
}
```

**Step 2: 运行 codegen**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Commit**

```bash
git add lib/domain/models/wallet_model.dart lib/domain/models/wallet_model.freezed.dart lib/domain/models/wallet_model.g.dart
git commit -m "feat: add addresses map to WalletModel"
```

---

### Task 6: 创建 ChainAdapter 抽象接口

**Files:**
- Create: `lib/domain/repositories/chain_adapter.dart`

**Step 1: 创建文件**

```dart
// lib/domain/repositories/chain_adapter.dart
import 'dart:typed_data';

import '../models/chain_id.dart';
import '../models/transaction_model.dart';

abstract class ChainAdapter {
  ChainId get chainId;
  String get name;
  String get nativeSymbol;
  int get nativeDecimals; // 18 for ETH, 8 for BTC, 9 for SOL

  /// Derive the chain address from BIP39 seed bytes.
  Future<String> deriveAddress(Uint8List seedBytes);

  /// Get the native token balance for [address].
  /// Returns the amount in human-readable units (ETH, BTC, SOL).
  Future<double> getNativeBalance(String address);

  /// Get recent transactions for [address].
  Future<List<TransactionModel>> getTransactions(String address);
}
```

**Step 2: Verify**

```bash
flutter analyze lib/domain/repositories/chain_adapter.dart
```

**Step 3: Commit**

```bash
git add lib/domain/repositories/chain_adapter.dart
git commit -m "feat: add ChainAdapter abstract interface"
```

---

### Task 7: 更新 PhraseRepositoryImpl — 三链地址派生

**Files:**
- Modify: `lib/domain/repositories/phrase_repository.dart`
- Modify: `lib/data/repositories/phrase_repository_impl.dart`

**Step 1: 在 PhraseRepository 抽象类中添加方法**

在 `lib/domain/repositories/phrase_repository.dart` 中，在 `generatePublicKey` 之后添加：

```dart
/// Derive all chain addresses from mnemonic and return updated WalletModel.
Future<WalletModel> deriveAllAddresses(String mnemonics);
```

查看当前 phrase_repository.dart 文件确认现有方法，然后在合适位置添加该方法。

**Step 2: 在 PhraseRepositoryImpl 中实现**

在 `lib/data/repositories/phrase_repository_impl.dart` 顶部添加 imports：

```dart
import 'dart:typed_data';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bs58/bs58.dart';
import 'package:pinenacl/ed25519.dart';
import 'package:pointycastle/digests/ripemd160.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:bech32/bech32.dart';
```

添加 `deriveAllAddresses` 实现（在 `generatePublicKey` 之后）：

```dart
@override
Future<WalletModel> deriveAllAddresses(String mnemonics) async {
  final seedBytes = bip39.mnemonicToSeed(mnemonics);

  // ── ETH (secp256k1, m/44'/60'/0'/0/0) ───────────────────────────────────
  final root = bip32.BIP32.fromSeed(seedBytes);
  final ethChild = root.derivePath("m/44'/60'/0'/0/0");
  final ethPrivKey = HEX.encode(ethChild.privateKey!);
  final ethCredentials = EthPrivateKey.fromHex(ethPrivKey);
  final ethAddress = (await ethCredentials.extractAddress()).hex;

  // ── BTC (secp256k1, m/84'/0'/0'/0/0, P2WPKH bech32) ─────────────────────
  final btcChild = root.derivePath("m/84'/0'/0'/0/0");
  final btcPubKey = btcChild.publicKey; // compressed 33 bytes
  final sha256Hash = crypto.sha256.convert(btcPubKey).bytes;
  final ripemd = RIPEMD160Digest()
      .process(Uint8List.fromList(sha256Hash));
  // Convert 8-bit groups to 5-bit groups for bech32
  final converted = _convertBits(ripemd, 8, 5, pad: true);
  final bech32Data = Bech32('bc', [0, ...converted]);
  final btcAddress = const Bech32Codec().encode(bech32Data);

  // ── SOL (ed25519, m/44'/501'/0'/0') ──────────────────────────────────────
  final solDerived = await ED25519_HD_KEY.derivePath(
    "m/44'/501'/0'/0'",
    seedBytes,
  );
  final signingKey = SigningKey.fromSeed(Uint8List.fromList(solDerived.key));
  final solAddress = base58.encode(
    Uint8List.fromList(signingKey.verifyKey.asTypedList),
  );

  return WalletModel(
    privateKey: ethPrivKey,
    publicKey: ethAddress,
    addresses: {
      'eth': ethAddress,
      'btc': btcAddress,
      'sol': solAddress,
    },
  );
}

/// Convert between bit-group sizes (for bech32 encoding).
List<int> _convertBits(List<int> data, int from, int to, {required bool pad}) {
  var acc = 0;
  var bits = 0;
  final result = <int>[];
  final maxv = (1 << to) - 1;
  for (final value in data) {
    acc = ((acc << from) | value) & 0xFFFF;
    bits += from;
    while (bits >= to) {
      bits -= to;
      result.add((acc >> bits) & maxv);
    }
  }
  if (pad) {
    if (bits > 0) result.add((acc << (to - bits)) & maxv);
  } else if (bits >= from || ((acc << (to - bits)) & maxv) != 0) {
    throw Exception('Invalid convertBits input');
  }
  return result;
}
```

Also update `generatePrivatekey` to use BIP44 ETH path (for backward compat callers):

```dart
@override
Future<String> generatePrivatekey(String mnemonics) async {
  final seedBytes = bip39.mnemonicToSeed(mnemonics);
  final root = bip32.BIP32.fromSeed(seedBytes);
  final child = root.derivePath("m/44'/60'/0'/0/0");
  return HEX.encode(child.privateKey!);
}
```

**Step 3: 运行 analyze**

```bash
flutter analyze lib/data/repositories/phrase_repository_impl.dart
```

Expected: no errors

**Step 4: Commit**

```bash
git add lib/domain/repositories/phrase_repository.dart lib/data/repositories/phrase_repository_impl.dart
git commit -m "feat: BIP44 multi-chain address derivation in PhraseRepositoryImpl"
```

---

### Task 8: 创建 EthChainAdapter

**Files:**
- Create: `lib/data/adapters/eth_chain_adapter.dart`

**Step 1: 创建目录并创建文件**

```bash
mkdir -p lib/data/adapters
```

```dart
// lib/data/adapters/eth_chain_adapter.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

import '../../domain/models/chain_id.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/chain_adapter.dart';

class EthChainAdapter implements ChainAdapter {
  EthChainAdapter(this._web3client);

  final Web3Client _web3client;

  static const _etherscanBase = 'https://api.etherscan.io/api';

  @override
  ChainId get chainId => ChainId.ethereum;

  @override
  String get name => 'Ethereum';

  @override
  String get nativeSymbol => 'ETH';

  @override
  int get nativeDecimals => 18;

  @override
  Future<String> deriveAddress(Uint8List seedBytes) async {
    final root = bip32.BIP32.fromSeed(seedBytes);
    final child = root.derivePath("m/44'/60'/0'/0/0");
    final credentials = EthPrivateKey.fromHex(HEX.encode(child.privateKey!));
    return (await credentials.extractAddress()).hex;
  }

  @override
  Future<double> getNativeBalance(String address) async {
    try {
      final ethAddress = EthereumAddress.fromHex(address);
      final balance = await _web3client.getBalance(ethAddress);
      return balance.getValueInUnit(EtherUnit.ether).toDouble();
    } catch (_) {
      return 0.0;
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions(String address) async {
    try {
      final uri = Uri.parse(
        '$_etherscanBase?module=account&action=txlist'
        '&address=$address&startblock=0&endblock=99999999'
        '&page=1&offset=20&sort=desc',
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) return [];
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['status'] != '1') return [];
      return (json['result'] as List<dynamic>)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)
              .copyWith(chain: 'eth'))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
```

**Step 2: Verify**

```bash
flutter analyze lib/data/adapters/eth_chain_adapter.dart
```

**Step 3: Commit**

```bash
git add lib/data/adapters/eth_chain_adapter.dart
git commit -m "feat: add EthChainAdapter"
```

---

### Task 9: 创建 BtcChainAdapter

**Files:**
- Create: `lib/data/adapters/btc_chain_adapter.dart`

**Step 1: 创建文件**

```dart
// lib/data/adapters/btc_chain_adapter.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:bech32/bech32.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:pointycastle/digests/ripemd160.dart';

import '../../domain/models/chain_id.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/chain_adapter.dart';

class BtcChainAdapter implements ChainAdapter {
  static const _mempoolBase = 'https://mempool.space/api';

  @override
  ChainId get chainId => ChainId.bitcoin;

  @override
  String get name => 'Bitcoin';

  @override
  String get nativeSymbol => 'BTC';

  @override
  int get nativeDecimals => 8;

  @override
  Future<String> deriveAddress(Uint8List seedBytes) async {
    final root = bip32.BIP32.fromSeed(seedBytes);
    final child = root.derivePath("m/84'/0'/0'/0/0");
    final pubKey = child.publicKey; // compressed 33 bytes

    // HASH160 = RIPEMD160(SHA256(pubKey))
    final sha256Hash = crypto.sha256.convert(pubKey).bytes;
    final pubKeyHash = RIPEMD160Digest()
        .process(Uint8List.fromList(sha256Hash));

    // P2WPKH bech32 address (witness version 0)
    final converted = _convertBits(pubKeyHash, 8, 5, pad: true);
    final bech32Data = Bech32('bc', [0, ...converted]);
    return const Bech32Codec().encode(bech32Data);
  }

  @override
  Future<double> getNativeBalance(String address) async {
    try {
      final uri = Uri.parse('$_mempoolBase/address/$address');
      final response = await http.get(uri);
      if (response.statusCode != 200) return 0.0;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final chainStats = json['chain_stats'] as Map<String, dynamic>;
      final funded = chainStats['funded_txo_sum'] as int;
      final spent = chainStats['spent_txo_sum'] as int;
      return (funded - spent) / 100000000.0; // satoshis → BTC
    } catch (_) {
      return 0.0;
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions(String address) async {
    // BTC transaction structure differs significantly — not implemented in v1
    return [];
  }

  List<int> _convertBits(List<int> data, int from, int to, {required bool pad}) {
    var acc = 0;
    var bits = 0;
    final result = <int>[];
    final maxv = (1 << to) - 1;
    for (final value in data) {
      acc = ((acc << from) | value) & 0xFFFF;
      bits += from;
      while (bits >= to) {
        bits -= to;
        result.add((acc >> bits) & maxv);
      }
    }
    if (pad) {
      if (bits > 0) result.add((acc << (to - bits)) & maxv);
    }
    return result;
  }
}
```

**Step 2: Verify**

```bash
flutter analyze lib/data/adapters/btc_chain_adapter.dart
```

**Step 3: Commit**

```bash
git add lib/data/adapters/btc_chain_adapter.dart
git commit -m "feat: add BtcChainAdapter"
```

---

### Task 10: 创建 SolChainAdapter

**Files:**
- Create: `lib/data/adapters/sol_chain_adapter.dart`

**Step 1: 创建文件**

```dart
// lib/data/adapters/sol_chain_adapter.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:bs58/bs58.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:http/http.dart' as http;
import 'package:pinenacl/ed25519.dart';

import '../../domain/models/chain_id.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/chain_adapter.dart';

class SolChainAdapter implements ChainAdapter {
  static const _rpcUrl = 'https://api.mainnet-beta.solana.com';

  @override
  ChainId get chainId => ChainId.solana;

  @override
  String get name => 'Solana';

  @override
  String get nativeSymbol => 'SOL';

  @override
  int get nativeDecimals => 9;

  @override
  Future<String> deriveAddress(Uint8List seedBytes) async {
    final derived = await ED25519_HD_KEY.derivePath(
      "m/44'/501'/0'/0'",
      seedBytes,
    );
    final signingKey = SigningKey.fromSeed(Uint8List.fromList(derived.key));
    return base58.encode(Uint8List.fromList(signingKey.verifyKey.asTypedList));
  }

  @override
  Future<double> getNativeBalance(String address) async {
    try {
      final response = await http.post(
        Uri.parse(_rpcUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'getBalance',
          'params': [address],
        }),
      );
      if (response.statusCode != 200) return 0.0;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['result'] as Map<String, dynamic>?;
      if (result == null) return 0.0;
      final lamports = result['value'] as int? ?? 0;
      return lamports / 1e9; // lamports → SOL
    } catch (_) {
      return 0.0;
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions(String address) async {
    // SOL transaction structure differs significantly — not implemented in v1
    return [];
  }
}
```

**Step 2: Verify**

```bash
flutter analyze lib/data/adapters/sol_chain_adapter.dart
```

**Step 3: Commit**

```bash
git add lib/data/adapters/sol_chain_adapter.dart
git commit -m "feat: add SolChainAdapter"
```

---

### Task 11: 创建 chain_provider.dart

**Files:**
- Create: `lib/data/providers/chain_provider.dart`

**Step 1: 创建文件**

```dart
// lib/data/providers/chain_provider.dart
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as httpClient;

import '../../app/env_config.dart';
import '../../domain/models/chain_id.dart';
import '../../domain/repositories/chain_adapter.dart';
import '../adapters/btc_chain_adapter.dart';
import '../adapters/eth_chain_adapter.dart';
import '../adapters/sol_chain_adapter.dart';

// ── Chain Adapters ───────────────────────────────────────────────────────────
final chainAdaptersProvider = Provider<List<ChainAdapter>>((ref) {
  final web3client = Web3Client(EnvConfig.baseUrl, httpClient.Client());
  return [
    EthChainAdapter(web3client),
    BtcChainAdapter(),
    SolChainAdapter(),
  ];
});

final chainAdapterProvider =
    Provider.family<ChainAdapter?, ChainId>((ref, chainId) {
  return ref.watch(chainAdaptersProvider).firstWhere(
        (a) => a.chainId == chainId,
        orElse: () => throw StateError('No adapter for $chainId'),
      );
});

// ── CoinGecko Prices ─────────────────────────────────────────────────────────
final chainPricesProvider = FutureProvider<Map<ChainId, double>>((ref) async {
  try {
    final uri = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price'
      '?ids=ethereum,bitcoin,solana&vs_currencies=usd',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) return {};
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return {
      ChainId.ethereum: ((json['ethereum'] as Map)['usd'] as num).toDouble(),
      ChainId.bitcoin: ((json['bitcoin'] as Map)['usd'] as num).toDouble(),
      ChainId.solana: ((json['solana'] as Map)['usd'] as num).toDouble(),
    };
  } catch (_) {
    return {};
  }
});

// ── Native Balance per chain ──────────────────────────────────────────────────
final nativeBalanceProvider =
    FutureProvider.family<double, ({ChainId chainId, String address})>(
  (ref, args) async {
    if (args.address.isEmpty) return 0.0;
    final adapter = ref
        .watch(chainAdaptersProvider)
        .firstWhere((a) => a.chainId == args.chainId);
    return adapter.getNativeBalance(args.address);
  },
);

// ── Total USD Balance (all chains) ───────────────────────────────────────────
final totalUsdBalanceProvider =
    FutureProvider.family<double, Map<String, String>>(
  (ref, addresses) async {
    final prices = await ref.watch(chainPricesProvider.future);
    if (prices.isEmpty) return 0.0;

    double total = 0.0;
    for (final entry in addresses.entries) {
      final chainId = ChainId.values.firstWhere(
        (c) => c.key == entry.key,
        orElse: () => ChainId.ethereum,
      );
      final balanceAsync = ref.watch(
        nativeBalanceProvider((chainId: chainId, address: entry.value)),
      );
      final balance = balanceAsync.valueOrNull ?? 0.0;
      final price = prices[chainId] ?? 0.0;
      total += balance * price;
    }
    return total;
  },
);
```

**Step 2: Verify**

```bash
flutter analyze lib/data/providers/chain_provider.dart
```

**Step 3: Commit**

```bash
git add lib/data/providers/chain_provider.dart
git commit -m "feat: add chain_provider with multi-chain adapters and price aggregation"
```

---

### Task 12: 更新 HomeScreen — 余额区域使用多链总余额

**Files:**
- Modify: `lib/ui/home/widgets/home_screen.dart`

**Step 1: 在 build() 中替换余额相关 provider**

读取当前 `home_screen.dart`，找到 `build()` 方法中的 provider watches。

替换掉单独的 `ethBalanceAsync` + `ethUsdPriceAsync`（仅用于余额区），改为：

```dart
final addresses = app.wallet.addresses;
final totalUsdAsync = ref.watch(totalUsdBalanceProvider(addresses));
```

同时保留 `ethBalanceAsync`（assets tab 和 activity tab 仍需要）：
```dart
final ethBalanceAsync = ref.watch(
  ethBalanceProvider(app.wallet.publicKey ?? ''),
);
```

删除 `ethUsdPriceAsync`（它被 `chainPricesProvider` 替代）。

**Step 2: 更新 _buildBalanceSection 签名和实现**

```dart
Widget _buildBalanceSection(
  BuildContext context,
  AsyncValue<double> totalUsdAsync,
  AsyncValue<EtherAmount?> ethBalanceAsync,
) {
  final theme = Theme.of(context);

  double ethAmount = 0.0;
  ethBalanceAsync.whenData((balance) {
    if (balance != null) {
      ethAmount = balance.getValueInUnit(EtherUnit.ether).toDouble();
    }
  });

  final isLoading = totalUsdAsync.isLoading;
  final totalUsd = totalUsdAsync.valueOrNull ?? 0.0;

  return Container(
    color: const Color(0xFF0F1218),
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
    child: Column(
      children: [
        const Text(
          'Total Balance',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(height: 4),
        isLoading
            ? const SizedBox(
                height: 44,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : Text(
                '\$${totalUsd.toStringAsFixed(2)}',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 36,
                  letterSpacing: -1,
                ),
              ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${ethAmount.toStringAsFixed(4)} ETH',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}
```

Update the call site in `build()`:
```dart
_buildBalanceSection(context, totalUsdAsync, ethBalanceAsync),
```

Add imports:
```dart
import '../../../data/providers/chain_provider.dart';
```

**Step 3: Verify**

```bash
flutter analyze lib/ui/home/widgets/home_screen.dart
```

**Step 4: Commit**

```bash
git add lib/ui/home/widgets/home_screen.dart
git commit -m "feat: home screen balance shows total USD across all chains"
```

---

### Task 13: 更新 HomeScreen — 资产 Tab 显示多链原生资产

**Files:**
- Modify: `lib/ui/home/widgets/home_screen.dart`

**Step 1: 更新 _buildAssetsTab，在列表顶部显示 BTC 和 SOL 原生资产**

读取文件，找到 `_buildAssetsTab` 方法。

当前：只有 ETH（index 0）+ 保存的 ERC-20 代币。

更新为：ETH（index 0）、BTC（index 1）、SOL（index 2）+ ERC-20 代币（index 3+）。

```dart
Widget _buildAssetsTab(AsyncValue<EtherAmount?> ethBalanceAsync) {
  final app = ref.watch(appProvider);
  final publicKey = app.wallet.publicKey ?? '';
  final addresses = app.wallet.addresses;
  final savedTokens = ref.watch(savedTokensProvider);
  final prices = ref.watch(chainPricesProvider).valueOrNull ?? {};

  double ethAmount = 0.0;
  ethBalanceAsync.whenData((balance) {
    if (balance != null) {
      ethAmount = balance.getValueInUnit(EtherUnit.ether).toDouble();
    }
  });

  // BTC
  final btcAddress = addresses['btc'] ?? '';
  final btcBalanceAsync = ref.watch(
    nativeBalanceProvider((chainId: ChainId.bitcoin, address: btcAddress)),
  );

  // SOL
  final solAddress = addresses['sol'] ?? '';
  final solBalanceAsync = ref.watch(
    nativeBalanceProvider((chainId: ChainId.solana, address: solAddress)),
  );

  // Native assets section: ETH, BTC, SOL
  final nativeTiles = [
    _buildAssetTile(
      name: 'Ethereum',
      symbol: 'ETH',
      amount: ethAmount.toStringAsFixed(4),
      color: AppColors.primary,
      isLoading: ethBalanceAsync.isLoading,
    ),
    btcBalanceAsync.when(
      data: (btc) => _buildAssetTile(
        name: 'Bitcoin',
        symbol: 'BTC',
        amount: btc.toStringAsFixed(6),
        color: const Color(0xFFF7931A),
      ),
      loading: () => _buildAssetTile(
        name: 'Bitcoin',
        symbol: 'BTC',
        amount: '...',
        color: const Color(0xFFF7931A),
        isLoading: true,
      ),
      error: (_, __) => _buildAssetTile(
        name: 'Bitcoin',
        symbol: 'BTC',
        amount: 'Error',
        color: const Color(0xFFF7931A),
      ),
    ),
    solBalanceAsync.when(
      data: (sol) => _buildAssetTile(
        name: 'Solana',
        symbol: 'SOL',
        amount: sol.toStringAsFixed(4),
        color: const Color(0xFF14F195),
      ),
      loading: () => _buildAssetTile(
        name: 'Solana',
        symbol: 'SOL',
        amount: '...',
        color: const Color(0xFF14F195),
        isLoading: true,
      ),
      error: (_, __) => _buildAssetTile(
        name: 'Solana',
        symbol: 'SOL',
        amount: 'Error',
        color: const Color(0xFF14F195),
      ),
    ),
  ];

  return ListView.builder(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
    itemCount: nativeTiles.length + savedTokens.length,
    itemBuilder: (context, index) {
      if (index < nativeTiles.length) return nativeTiles[index];
      final token = savedTokens[index - nativeTiles.length];
      final balanceAsync = ref.watch(
        tokenBalanceProvider((token: token, publicKey: publicKey)),
      );
      return balanceAsync.when(
        data: (t) => _buildAssetTile(
          name: t.symbol,
          symbol: t.symbol,
          amount: _formatTokenBalance(t.balance, t.decimal),
          color: const Color(0xFF6C7BFF),
        ),
        loading: () => _buildAssetTile(
          name: token.symbol,
          symbol: token.symbol,
          amount: '...',
          color: const Color(0xFF6C7BFF),
          isLoading: true,
        ),
        error: (_, __) => _buildAssetTile(
          name: token.symbol,
          symbol: token.symbol,
          amount: 'Error',
          color: const Color(0xFF6C7BFF),
        ),
      );
    },
  );
}
```

Add `chain_provider.dart` import (if not already added in Task 12).

**Step 2: 更新 AppBar 展示多链说明**

在 AppBar 的网络标签处（当前显示 'Ethereum Mainnet'），更改为 'Multi-Chain':

```dart
const Text(
  'Multi-Chain',
  style: TextStyle(fontSize: 11, color: Colors.white60),
),
```

**Step 3: Verify**

```bash
flutter analyze
```

Expected: no errors (only pre-existing info-level warnings)

**Step 4: Commit**

```bash
git add lib/ui/home/widgets/home_screen.dart
git commit -m "feat: assets tab shows ETH, BTC, SOL native balances"
```

---

## 完成后需要验证

1. `flutter analyze` 无错误
2. 重新创建钱包（输入助记词），确认三链地址均不为空
3. `WalletModel.addresses` 包含 `eth`、`btc`、`sol` 三个键
4. 主页资产 Tab 显示三行原生资产（ETH、BTC、SOL）
5. 余额区显示的是三链总 USD 价值

## 改动文件汇总

| 文件 | 操作 |
|------|------|
| `pubspec.yaml` | 添加 4 个包 |
| `lib/domain/models/chain_id.dart` | 新建 |
| `lib/domain/models/token_asset_model.dart` | 添加 chain, isNative |
| `lib/domain/models/transaction_model.dart` | 添加 chain |
| `lib/domain/models/wallet_model.dart` | 添加 addresses |
| `lib/domain/repositories/chain_adapter.dart` | 新建抽象接口 |
| `lib/domain/repositories/phrase_repository.dart` | 添加 deriveAllAddresses |
| `lib/data/repositories/phrase_repository_impl.dart` | BIP44 三链派生 |
| `lib/data/adapters/eth_chain_adapter.dart` | 新建 |
| `lib/data/adapters/btc_chain_adapter.dart` | 新建 |
| `lib/data/adapters/sol_chain_adapter.dart` | 新建 |
| `lib/data/providers/chain_provider.dart` | 新建 |
| `lib/ui/home/widgets/home_screen.dart` | 多链余额 + 资产 Tab |
