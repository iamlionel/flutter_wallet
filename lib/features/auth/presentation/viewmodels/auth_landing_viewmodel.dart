import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../domain/repositories/phrase_repository.dart';
import '../states/auth_landing_state.dart';

export '../states/auth_landing_state.dart';

// ── ViewModel ─────────────────────────────────────────────────────────────────

class AuthLandingViewModel extends Notifier<AuthLandingState> {
  @override
  AuthLandingState build() => const AuthLandingState();

  void onPasswordChanged(String password) {
    state = state.copyWith(
      password: password,
      isValid: password.isNotEmpty && password.length >= 8,
    );
  }

  Future<void> onSubmitted() async {
    state = state.copyWith(status: AuthLandingStatus.loading);
    try {
      final response =
          await ref.read(phraseRepositoryProvider).retrieveData(state.password);
      if (response != null) {
        state = state.copyWith(wallet: response, status: AuthLandingStatus.success);
      } else {
        state = state.copyWith(
          status: AuthLandingStatus.failure,
          errorMessage: 'Oops an error occur, Try again',
        );
      }
    } on IncorrectPasswordException {
      state = state.copyWith(
        status: AuthLandingStatus.failure,
        errorMessage: 'Incorrect password',
      );
    } on Exception {
      state = state.copyWith(
        status: AuthLandingStatus.failure,
        errorMessage: 'Oops an error occur, Try again',
      );
    }
  }
}

final authLandingViewModelProvider =
    NotifierProvider<AuthLandingViewModel, AuthLandingState>(
        () => AuthLandingViewModel());
