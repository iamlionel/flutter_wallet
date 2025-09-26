import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/phrase_repository.dart';
import '../../domain/states/auth_landing_state.dart';
import '../repositories/phrase_repository_impl.dart';

class AuthLandingNotifier extends StateNotifier<AuthLandingState> {
  AuthLandingNotifier({required PhraseRepository phraseRepository})
    : _phraseRepository = phraseRepository,
      super(const AuthLandingState());

  final PhraseRepository _phraseRepository;

  void onPasswordChanged(String password) {
    state = state.copyWith(password: password);
    _isValid();
  }

  void _isValid() {
    if (state.password.isNotEmpty && state.password.length >= 8) {
      state = state.copyWith(isValid: true);
    } else {
      state = state.copyWith(isValid: false);
    }
  }

  Future<void> onSubmitted() async {
    try {
      final response = await _phraseRepository.retrieveData(state.password);
      if (response != null) {
        state = state.copyWith(
          wallet: response,
          status: AuthLandingStatus.success,
        );
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
