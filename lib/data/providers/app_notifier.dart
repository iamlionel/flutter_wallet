import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/wallet_model.dart';
import '../../domain/repositories/phrase_repository.dart';
import '../../domain/states/app_state.dart';

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier({required PhraseRepository phraseRepository})
    : _phraseRepository = phraseRepository,
      super(AppState()) {
    _streamSubscription = _phraseRepository.status.listen(updateAuthStatus);
  }

  late final StreamSubscription _streamSubscription;

  final PhraseRepository _phraseRepository;

  void updateWalletModel(WalletModel wallet) {
    state = state.copyWith(wallet: wallet);
  }

  void updateAuthStatus(AuthStatus status) {
    state = state.copyWith(status: status);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
