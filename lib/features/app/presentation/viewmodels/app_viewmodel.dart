import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../auth/domain/repositories/phrase_repository.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../states/app_state.dart';

export '../states/app_state.dart';

// ── ViewModel ─────────────────────────────────────────────────────────────────

class AppViewModel extends Notifier<AppState> {
  @override
  AppState build() {
    final phraseRepository = ref.watch(phraseRepositoryProvider);
    final subscription = phraseRepository.status.listen(
      (status) => state = state.copyWith(status: status),
    );
    ref.onDispose(subscription.cancel);
    return AppState();
  }

  void updateWallet(Wallet wallet) {
    state = state.copyWith(wallet: wallet);
  }

  void updateAuthStatus(AuthStatus status) {
    state = state.copyWith(status: status);
  }
}

final appViewModelProvider =
    NotifierProvider<AppViewModel, AppState>(() => AppViewModel());
