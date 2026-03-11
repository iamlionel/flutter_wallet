# Home Screen Real Data Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 将主页的硬编码假数据替换为真实链上数据和 Etherscan API 数据。

**Architecture:** ETH 余额通过已有 `ethBalanceProvider` (web3dart) 获取，USD 价格和交易记录通过 Etherscan 主网 API（无 key）获取，用户添加的 ERC-20 代币合约地址持久化到 `flutter_secure_storage`，每次启动时加载余额。

**Tech Stack:** Flutter, Riverpod, web3dart, flutter_secure_storage, Etherscan API (api.etherscan.io), freezed

---

### Task 1: TokenAssetModel

**Files:**
- Create: `lib/domain/models/token_asset_model.dart`
- Run codegen after

**Step 1: Write the model**

```dart
// lib/domain/models/token_asset_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_asset_model.freezed.dart';
part 'token_asset_model.g.dart';

@freezed
abstract class TokenAssetModel with _$TokenAssetModel {
  const factory TokenAssetModel({
    required String contractAddress,
    required String symbol,
    required String decimal,
    @Default('0') String balance,
  }) = _TokenAssetModel;

  factory TokenAssetModel.fromJson(Map<String, dynamic> json) =>
      _$TokenAssetModelFromJson(json);
}
```

**Step 2: Run codegen**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: generates `token_asset_model.freezed.dart` and `token_asset_model.g.dart`

**Step 3: Commit**

```bash
git add lib/domain/models/token_asset_model.dart lib/domain/models/token_asset_model.freezed.dart lib/domain/models/token_asset_model.g.dart
git commit -m "feat: add TokenAssetModel"
```

---

### Task 2: TransactionModel

**Files:**
- Create: `lib/domain/models/transaction_model.dart`
- Run codegen after

**Step 1: Write the model**

```dart
// lib/domain/models/transaction_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionType { send, receive, contractCall }

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String hash,
    required String from,
    required String to,
    required String value,     // in wei (string)
    required String timeStamp, // unix timestamp string
    required String isError,   // "0" = success, "1" = failed
    @Default('') String tokenSymbol,
    @Default('') String tokenDecimal,
    @Default(false) bool isErc20,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
```

**Step 2: Run codegen**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Commit**

```bash
git add lib/domain/models/transaction_model.dart lib/domain/models/transaction_model.freezed.dart lib/domain/models/transaction_model.g.dart
git commit -m "feat: add TransactionModel"
```

---

### Task 3: Etherscan Service (in ContractRepository)

**Files:**
- Modify: `lib/domain/repositories/contract_repository.dart`
- Modify: `lib/data/repositories/contract_repository_impl.dart`

**Step 1: Add abstract methods to ContractRepository**

In `lib/domain/repositories/contract_repository.dart`, add after `getEthBalance`:

```dart
Future<double> getEthUsdPrice();

Future<List<TransactionModel>> getEthTransactions(String address);

Future<List<TransactionModel>> getErc20Transactions(String address);
```

Also add the import at top:
```dart
import '../models/transaction_model.dart';
```

**Step 2: Implement in ContractRepositoryImpl**

In `lib/data/repositories/contract_repository_impl.dart`, add the Etherscan base URL constant after class declaration:

```dart
static const _etherscanBase = 'https://api.etherscan.io/api';
```

Then add the three implementations:

```dart
@override
Future<double> getEthUsdPrice() async {
  final uri = Uri.parse(
    '$_etherscanBase?module=stats&action=ethprice',
  );
  final response = await http.get(uri);
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  if (json['status'] == '1') {
    final result = json['result'] as Map<String, dynamic>;
    return double.parse(result['ethusd'] as String);
  }
  return 0.0;
}

@override
Future<List<TransactionModel>> getEthTransactions(String address) async {
  final uri = Uri.parse(
    '$_etherscanBase?module=account&action=txlist'
    '&address=$address&startblock=0&endblock=99999999'
    '&page=1&offset=20&sort=desc',
  );
  final response = await http.get(uri);
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  if (json['status'] == '1') {
    final results = json['result'] as List<dynamic>;
    return results
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return [];
}

@override
Future<List<TransactionModel>> getErc20Transactions(String address) async {
  final uri = Uri.parse(
    '$_etherscanBase?module=account&action=tokentx'
    '&address=$address&startblock=0&endblock=99999999'
    '&page=1&offset=20&sort=desc',
  );
  final response = await http.get(uri);
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  if (json['status'] == '1') {
    final results = json['result'] as List<dynamic>;
    return results
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)
            .copyWith(isErc20: true))
        .toList();
  }
  return [];
}
```

Also add the import at top of `contract_repository_impl.dart`:
```dart
import 'dart:convert';
import '../../domain/models/transaction_model.dart';
```

**Step 3: Fix existing getTokenBalance bug**

In `contract_repository_impl.dart`, `getTokenBalance` uses wrong address. Replace:
```dart
// WRONG:
final contract = DeployedContract(
  _erc20Abi!,
  EthereumAddress.fromHex(publicKey),  // <-- bug
);
final ethAddress = EthPrivateKey.fromHex(publicKey);
final response = await _web3client.call(
  contract: contract,
  function: contract.function('balanceOf'),
  params: <dynamic>[ethAddress],
);
```
With:
```dart
// CORRECT:
final contract = DeployedContract(
  _erc20Abi!,
  EthereumAddress.fromHex(contractAddress),
);
final walletAddress = EthereumAddress.fromHex(publicKey);
final response = await _web3client.call(
  contract: contract,
  function: contract.function('balanceOf'),
  params: <dynamic>[walletAddress],
);
```

**Step 4: Verify project compiles**

```bash
flutter analyze
```

Expected: no new errors

**Step 5: Commit**

```bash
git add lib/domain/repositories/contract_repository.dart lib/data/repositories/contract_repository_impl.dart
git commit -m "feat: add Etherscan API methods and fix getTokenBalance bug"
```

---

### Task 4: Token Persistence in SecureStorage

**Files:**
- Create: `lib/data/providers/wallet_data_provider.dart`

**Step 1: Create WalletDataProvider with token persistence**

```dart
// lib/data/providers/wallet_data_provider.dart
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/models/token_asset_model.dart';
import 'contract_provider.dart';

const _tokensKey = 'saved_tokens';
const _storage = FlutterSecureStorage();

// ── ETH USD Price ───────────────────────────────────────────────────────────
final ethUsdPriceProvider = FutureProvider<double>((ref) async {
  final repo = await ref.watch(contractRepositoryProvider.future);
  return repo.getEthUsdPrice();
});

// ── Saved Token List ────────────────────────────────────────────────────────
final savedTokensProvider =
    StateNotifierProvider<SavedTokensNotifier, List<TokenAssetModel>>(
  (ref) => SavedTokensNotifier(),
);

class SavedTokensNotifier extends StateNotifier<List<TokenAssetModel>> {
  SavedTokensNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final raw = await _storage.read(key: _tokensKey);
    if (raw == null) return;
    final list = jsonDecode(raw) as List<dynamic>;
    state = list
        .map((e) => TokenAssetModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addToken(TokenAssetModel token) async {
    final exists = state.any(
      (t) => t.contractAddress.toLowerCase() ==
          token.contractAddress.toLowerCase(),
    );
    if (exists) return;
    state = [...state, token];
    await _save();
  }

  Future<void> _save() async {
    final raw = jsonEncode(state.map((t) => t.toJson()).toList());
    await _storage.write(key: _tokensKey, value: raw);
  }
}

// ── Token with Balance ──────────────────────────────────────────────────────
final tokenBalanceProvider =
    FutureProvider.family<TokenAssetModel, ({TokenAssetModel token, String publicKey})>(
  (ref, args) async {
    final repo = await ref.watch(contractRepositoryProvider.future);
    final balance = await repo.getTokenBalance(
      args.token.contractAddress,
      args.publicKey,
    );
    return args.token.copyWith(balance: balance);
  },
);
```

**Step 2: Commit**

```bash
git add lib/data/providers/wallet_data_provider.dart
git commit -m "feat: add WalletDataProvider with token persistence and ETH price"
```

---

### Task 5: Transaction Provider

**Files:**
- Modify: `lib/data/providers/wallet_data_provider.dart`

**Step 1: Add transaction providers at the bottom of wallet_data_provider.dart**

```dart
// ── Transactions ────────────────────────────────────────────────────────────
import '../../domain/models/transaction_model.dart';

final transactionsProvider =
    FutureProvider.family<List<TransactionModel>, String>(
  (ref, address) async {
    if (address.isEmpty) return [];
    final repo = await ref.watch(contractRepositoryProvider.future);
    final results = await Future.wait([
      repo.getEthTransactions(address),
      repo.getErc20Transactions(address),
    ]);
    final all = [...results[0], ...results[1]];
    all.sort((a, b) => int.parse(b.timeStamp).compareTo(int.parse(a.timeStamp)));
    return all.take(20).toList();
  },
);
```

Note: Move the `TransactionModel` import to the top of the file.

**Step 2: Commit**

```bash
git add lib/data/providers/wallet_data_provider.dart
git commit -m "feat: add transaction provider"
```

---

### Task 6: Update AddToken to Save Token

**Files:**
- Modify: `lib/data/providers/add_token_notifier.dart`
- Modify: `lib/ui/widgets/add_token_bottom_sheet.dart`

**Step 1: Add saveToken method to AddTokenNotifier**

In `add_token_notifier.dart`, add import:
```dart
import '../../domain/models/token_asset_model.dart';
```

Add method:
```dart
TokenAssetModel? get currentToken {
  if (state.tokenSymbol.isEmpty) return null;
  return TokenAssetModel(
    contractAddress: state.contractAddress,
    symbol: state.tokenSymbol,
    decimal: state.tokenDecimal,
  );
}
```

**Step 2: Wire "Add Token" button in bottom sheet**

In `add_token_bottom_sheet.dart`, update `SolidButton` `onPressed`:

```dart
SolidButton(
  text: 'Add Token',
  gradient: AppColors.primaryGradient,
  onPressed: () {
    final token = ref.read(addTokenProvider.notifier).currentToken;
    if (token != null) {
      ref.read(savedTokensProvider.notifier).addToken(token);
      Navigator.of(context).pop();
    }
  },
),
```

Add import at top:
```dart
import '../../data/providers/wallet_data_provider.dart';
```

**Step 3: Commit**

```bash
git add lib/data/providers/add_token_notifier.dart lib/ui/widgets/add_token_bottom_sheet.dart
git commit -m "feat: save added token to secure storage"
```

---

### Task 7: Update HomeScreen Balance Section

**Files:**
- Modify: `lib/ui/home/widgets/home_screen.dart`

**Step 1: Add imports**

At top of `home_screen.dart`, add:
```dart
import '../../../data/providers/wallet_data_provider.dart';
```

**Step 2: Replace hardcoded balance with real data**

Replace the `build` method's provider watching section. After `ethBalanceAsync`, add:
```dart
final ethUsdPriceAsync = ref.watch(ethUsdPriceProvider);
```

Replace `_buildBalanceSection(context, ethBalanceAsync)` call:
```dart
_buildBalanceSection(context, ethBalanceAsync, ethUsdPriceAsync),
```

**Step 3: Update `_buildBalanceSection` signature and body**

Replace the entire method:
```dart
Widget _buildBalanceSection(
  BuildContext context,
  AsyncValue<EtherAmount?> ethBalanceAsync,
  AsyncValue<double> ethUsdPriceAsync,
) {
  final theme = Theme.of(context);

  // Calculate values
  double ethAmount = 0.0;
  double usdPrice = 0.0;

  ethBalanceAsync.whenData((balance) {
    if (balance != null) {
      ethAmount = balance.getValueInUnit(EtherUnit.ether).toDouble();
    }
  });
  ethUsdPriceAsync.whenData((price) => usdPrice = price);

  final totalUsd = ethAmount * usdPrice;
  final isLoading = ethBalanceAsync.isLoading || ethUsdPriceAsync.isLoading;

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
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
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

Add import at top:
```dart
import 'package:web3dart/web3dart.dart';
```

**Step 4: Commit**

```bash
git add lib/ui/home/widgets/home_screen.dart
git commit -m "feat: display real ETH balance and USD value on home screen"
```

---

### Task 8: Update Assets Tab with Real Data

**Files:**
- Modify: `lib/ui/home/widgets/home_screen.dart`

**Step 1: Replace `_buildAssetsTab()` method**

Replace the entire `_buildAssetsTab` method with a version that reads real data:

```dart
Widget _buildAssetsTab() {
  final app = ref.watch(appProvider);
  final publicKey = app.wallet.publicKey ?? '';
  final ethBalanceAsync = ref.watch(ethBalanceProvider(publicKey));
  final savedTokens = ref.watch(savedTokensProvider);

  // Build ETH entry
  double ethAmount = 0.0;
  ethBalanceAsync.whenData((balance) {
    if (balance != null) {
      ethAmount = balance.getValueInUnit(EtherUnit.ether).toDouble();
    }
  });

  return ListView.builder(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
    itemCount: 1 + savedTokens.length,
    itemBuilder: (context, index) {
      if (index == 0) {
        // ETH native asset
        return _buildAssetTile(
          name: 'Ethereum',
          symbol: 'ETH',
          amount: ethAmount.toStringAsFixed(4),
          color: AppColors.primary,
          isLoading: ethBalanceAsync.isLoading,
        );
      }
      // ERC-20 tokens
      final token = savedTokens[index - 1];
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

Widget _buildAssetTile({
  required String name,
  required String symbol,
  required String amount,
  required Color color,
  bool isLoading = false,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.token_rounded, color: color, size: 24),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        symbol,
        style: const TextStyle(color: Colors.white38, fontSize: 12),
      ),
      trailing: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
    ),
  );
}

String _formatTokenBalance(String rawBalance, String decimal) {
  if (rawBalance.isEmpty || rawBalance == '0') return '0';
  try {
    final decimals = int.parse(decimal);
    final value = BigInt.parse(rawBalance);
    final divisor = BigInt.from(10).pow(decimals);
    final whole = value ~/ divisor;
    final fraction = value % divisor;
    final fractionStr = fraction.toString().padLeft(decimals, '0');
    return '$whole.${fractionStr.substring(0, 4.clamp(0, fractionStr.length))}';
  } catch (_) {
    return rawBalance;
  }
}
```

Also delete the old `_Asset` class at the bottom of the file.

**Step 2: Commit**

```bash
git add lib/ui/home/widgets/home_screen.dart
git commit -m "feat: assets tab shows real ETH and ERC-20 token balances"
```

---

### Task 9: Update Activity Tab with Transaction History

**Files:**
- Modify: `lib/ui/home/widgets/home_screen.dart`

**Step 1: Replace `_buildActivityTab()` with real transactions**

```dart
Widget _buildActivityTab() {
  final app = ref.watch(appProvider);
  final publicKey = app.wallet.publicKey ?? '';
  final txAsync = ref.watch(transactionsProvider(publicKey));

  return txAsync.when(
    loading: () => const Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
    error: (e, _) => Center(
      child: Text(
        'Failed to load transactions',
        style: const TextStyle(color: Colors.white38),
      ),
    ),
    data: (txList) {
      if (txList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history_rounded,
                size: 56,
                color: Colors.white.withValues(alpha: 0.12),
              ),
              const SizedBox(height: 14),
              const Text(
                'No recent activity',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your transactions will appear here',
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: txList.length,
        itemBuilder: (context, index) {
          final tx = txList[index];
          final isSend = tx.from.toLowerCase() == publicKey.toLowerCase();
          final isSuccess = tx.isError == '0';
          final color = isSuccess
              ? (isSend ? AppColors.warning : AppColors.success)
              : Colors.red;
          final icon = isSend
              ? Icons.arrow_upward_rounded
              : Icons.arrow_downward_rounded;
          final label = tx.isErc20
              ? '${isSend ? 'Send' : 'Receive'} ${tx.tokenSymbol}'
              : (isSend ? 'Send ETH' : 'Receive ETH');
          final amount = tx.isErc20
              ? _formatTokenBalance(tx.value, tx.tokenDecimal)
              : _weiToEth(tx.value);
          final dt = DateTime.fromMillisecondsSinceEpoch(
            int.parse(tx.timeStamp) * 1000,
          );
          final dateStr =
              '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              title: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                '${_shortHash(tx.hash)} · $dateStr',
                style:
                    const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isSend ? '-' : '+'}$amount',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (!isSuccess)
                    const Text(
                      'Failed',
                      style: TextStyle(color: Colors.red, fontSize: 11),
                    ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

String _weiToEth(String wei) {
  try {
    final value = BigInt.parse(wei);
    final eth = value / BigInt.from(10).pow(18);
    return eth.toStringAsFixed(4);
  } catch (_) {
    return '0';
  }
}

String _shortHash(String hash) {
  if (hash.length < 12) return hash;
  return '${hash.substring(0, 6)}...${hash.substring(hash.length - 4)}';
}
```

Add import for `transactionsProvider` — it's already in `wallet_data_provider.dart`.

**Step 2: Final flutter analyze**

```bash
flutter analyze
```

Expected: no errors

**Step 3: Commit**

```bash
git add lib/ui/home/widgets/home_screen.dart
git commit -m "feat: activity tab shows real transaction history from Etherscan"
```

---

## Summary of Changed Files

| File | Action |
|------|--------|
| `lib/domain/models/token_asset_model.dart` | Create |
| `lib/domain/models/transaction_model.dart` | Create |
| `lib/domain/repositories/contract_repository.dart` | Add 3 methods |
| `lib/data/repositories/contract_repository_impl.dart` | Implement 3 methods + fix bug |
| `lib/data/providers/wallet_data_provider.dart` | Create |
| `lib/data/providers/add_token_notifier.dart` | Add currentToken getter |
| `lib/ui/widgets/add_token_bottom_sheet.dart` | Wire Add Token button |
| `lib/ui/home/widgets/home_screen.dart` | All 3 sections updated |
