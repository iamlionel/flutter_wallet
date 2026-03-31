import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../features/wallet/domain/entities/chain_id.dart';
import '../../features/auth/data/repositories/phrase_repository_impl.dart';
import '../../features/auth/domain/repositories/phrase_repository.dart';
import '../../features/wallet/data/datasources/btc_chain_adapter.dart';
import '../../features/wallet/data/datasources/eth_chain_adapter.dart';
import '../../features/wallet/data/datasources/sol_chain_adapter.dart';
import '../../features/wallet/domain/entities/token_asset.dart';
import '../../features/wallet/domain/entities/transaction.dart';
import '../../features/wallet/domain/repositories/chain_adapter.dart';

// ── Storage ───────────────────────────────────────────────────────────────────

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// ── Repositories ──────────────────────────────────────────────────────────────

final phraseRepositoryProvider = Provider<PhraseRepository>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return PhraseRepositoryImpl(storage: secureStorage);
});

// ── Chain Adapters ────────────────────────────────────────────────────────────

final chainAdaptersProvider = FutureProvider<List<ChainAdapter>>((ref) async {
  return [
    await EthChainAdapter.create(),
    BtcChainAdapter(),
    SolChainAdapter(),
  ];
});

/// Convenience provider — returns the EthChainAdapter directly.
final evmAdapterProvider = FutureProvider<EthChainAdapter>((ref) async {
  final adapters = await ref.watch(chainAdaptersProvider.future);
  return adapters.whereType<EthChainAdapter>().first;
});

// ── Chain Prices (CoinGecko) ──────────────────────────────────────────────────

final chainPricesProvider = FutureProvider<Map<ChainId, double>>((ref) async {
  try {
    final uri = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=ethereum,bitcoin,solana&vs_currencies=usd',
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) return {};
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return {
      ChainId.ethereum: (json['ethereum']['usd'] as num).toDouble(),
      ChainId.bitcoin: (json['bitcoin']['usd'] as num).toDouble(),
      ChainId.solana: (json['solana']['usd'] as num).toDouble(),
    };
  } catch (_) {
    return {};
  }
});

// ── Native Balance ────────────────────────────────────────────────────────────

final nativeBalanceProvider = FutureProvider.family<
    double, ({ChainId chainId, String address})>((ref, params) async {
  final adapters = await ref.read(chainAdaptersProvider.future);
  final adapter = adapters.firstWhere(
    (a) => a.chainId == params.chainId,
    orElse: () => throw StateError('No adapter for chain ${params.chainId}'),
  );
  return adapter.getNativeBalance(params.address);
});

// ── Total USD Balance ─────────────────────────────────────────────────────────

final totalUsdBalanceProvider =
    FutureProvider.family<double, Map<String, String>>((ref, addresses) async {
  try {
    final prices = await ref.read(chainPricesProvider.future);

    final futures = ChainId.values.map((chainId) async {
      final address = addresses[chainId.key] ?? '';
      if (address.isEmpty) return 0.0;
      final price = prices[chainId] ?? 0.0;
      if (price == 0.0) return 0.0;
      try {
        final balance = await ref.read(
          nativeBalanceProvider((chainId: chainId, address: address)).future,
        );
        return balance * price;
      } catch (_) {
        return 0.0;
      }
    });

    final results = await Future.wait(futures);
    return results.fold<double>(0.0, (sum, v) => sum + v);
  } catch (_) {
    return 0.0;
  }
});

// ── Token Balance ─────────────────────────────────────────────────────────────

final tokenBalanceProvider = FutureProvider.family<
    TokenAsset, ({TokenAsset token, String publicKey})>(
  (ref, args) async {
    final evm = await ref.read(evmAdapterProvider.future);
    final balance =
        await evm.getTokenBalance(args.token.contractAddress, args.publicKey);
    return args.token.copyWith(balance: balance);
  },
);

// ── Transactions ──────────────────────────────────────────────────────────────

final transactionsProvider =
    FutureProvider.family<List<Transaction>, String>((ref, address) async {
  if (address.isEmpty) return [];
  final adapters = await ref.read(chainAdaptersProvider.future);
  final adapter = adapters.firstWhere(
    (a) => a.chainId == ChainId.ethereum,
  );
  return adapter.getTransactions(address);
});
