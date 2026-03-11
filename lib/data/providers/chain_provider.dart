// lib/data/providers/chain_provider.dart
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../domain/models/chain_id.dart';
import '../../domain/repositories/chain_adapter.dart';
import '../adapters/btc_chain_adapter.dart';
import '../adapters/eth_chain_adapter.dart';
import '../adapters/sol_chain_adapter.dart';
import 'app_provider.dart';
import 'contract_provider.dart';

// ── Chain Adapters ───────────────────────────────────────────────────────────
final chainAdaptersProvider = FutureProvider<List<ChainAdapter>>((ref) async {
  final contractRepo = await ref.read(contractRepositoryProvider.future);
  return [
    EthChainAdapter(contractRepo),
    BtcChainAdapter(),
    SolChainAdapter(),
  ];
});

// ── Chain Prices (CoinGecko) ─────────────────────────────────────────────────
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

// ── Native Balance (per chain + address) ────────────────────────────────────
final nativeBalanceProvider = FutureProvider.family<
  double,
  ({ChainId chainId, String address})
>((ref, params) async {
  final adapters = await ref.read(chainAdaptersProvider.future);
  final adapter = adapters.firstWhere(
    (a) => a.chainId == params.chainId,
    orElse: () => throw StateError('No adapter for chain ${params.chainId}'),
  );
  return adapter.getNativeBalance(params.address);
});

// ── Total USD Balance (all chains) ──────────────────────────────────────────
final totalUsdBalanceProvider = FutureProvider<double>((ref) async {
  try {
    final wallet = ref.read(appProvider).wallet;
    final prices = await ref.read(chainPricesProvider.future);

    final futures = ChainId.values.map((chainId) async {
      final address = wallet.addresses[chainId.key] ?? '';
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
