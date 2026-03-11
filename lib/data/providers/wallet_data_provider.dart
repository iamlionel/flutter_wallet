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
