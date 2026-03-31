import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/models/token_asset_model.dart';
import '../../domain/entities/token_asset.dart';
import '../../../../core/di/dependency_injection.dart';
import '../states/import_token_state.dart';

export '../states/import_token_state.dart';

// ── Saved Tokens ──────────────────────────────────────────────────────────────

const _tokensKey = 'saved_tokens';
const _storage = FlutterSecureStorage();

class SavedTokensViewModel extends Notifier<List<TokenAsset>> {
  @override
  List<TokenAsset> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    try {
      final raw = await _storage.read(key: _tokensKey);
      if (raw == null) return;
      final list = jsonDecode(raw) as List<dynamic>;
      state = list
          .map((e) => TokenAssetModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    } catch (_) {
      state = [];
    }
  }

  Future<void> addToken(TokenAsset token) async {
    final exists = state.any(
      (t) => t.contractAddress.toLowerCase() ==
          token.contractAddress.toLowerCase(),
    );
    if (exists) return;
    state = [...state, token];
    final raw = jsonEncode(
      state.map((t) => TokenAssetModel.fromEntity(t).toJson()).toList(),
    );
    await _storage.write(key: _tokensKey, value: raw);
  }
}

final savedTokensViewModelProvider =
    NotifierProvider<SavedTokensViewModel, List<TokenAsset>>(
        () => SavedTokensViewModel());

// ── Import Token ──────────────────────────────────────────────────────────────

class ImportTokenViewModel extends Notifier<ImportTokenState> {
  @override
  ImportTokenState build() => const ImportTokenState();

  void onContractAddressChanged(String address) {
    state = state.copyWith(contractAddress: address);
    _getContractDetails();
  }

  TokenAsset? get currentToken {
    if (state.tokenSymbol.isEmpty) return null;
    return TokenAsset(
      contractAddress: state.contractAddress,
      symbol: state.tokenSymbol,
      decimal: state.tokenDecimal,
    );
  }

  Future<void> _getContractDetails() async {
    if (state.contractAddress.length < 40) return;
    final ethAdapter = ref.read(evmAdapterProvider).value;
    if (ethAdapter == null) return;
    state = state.copyWith(status: ImportTokenStatus.loading);
    try {
      final symbol = await ethAdapter.getTokenSymbol(state.contractAddress);
      final decimal = await ethAdapter.getTokenDecimal(state.contractAddress);
      state = state.copyWith(
        tokenDecimal: decimal,
        tokenSymbol: symbol,
        status: ImportTokenStatus.success,
      );
    } catch (_) {
      state = state.copyWith(status: ImportTokenStatus.failure);
    }
  }
}

final importTokenViewModelProvider =
    NotifierProvider<ImportTokenViewModel, ImportTokenState>(
        () => ImportTokenViewModel());
