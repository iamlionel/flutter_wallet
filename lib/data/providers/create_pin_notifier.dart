import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/wallet_model.dart';
import '../../domain/repositories/phrase_repository.dart';
import '../../domain/states/create_pin_state.dart';

class CreatePinNotifier extends StateNotifier<CreatePinState> {
  CreatePinNotifier({required PhraseRepository phraseRepository})
    : _phraseRepository = phraseRepository,
      super(const CreatePinState());

  final PhraseRepository _phraseRepository;

  Future<void> getUserKeys(String mnemonics, String password) async {
    state = state.copyWith(status: CreatePinStatus.loading);
    try {
      final privateKey = await _phraseRepository.generatePrivatekey(mnemonics);
      final publicKey = await _phraseRepository.generatePublicKey(privateKey);
      final data = WalletModel(
        privateKey: privateKey,
        publicKey: publicKey.toString(),
      );
      await _phraseRepository.saveData(data, password);
      state = state.copyWith(status: CreatePinStatus.success, wallet: data);
    } on Exception {
      state = state.copyWith(status: CreatePinStatus.failure);
    }
  }

  void onPasswordChanged(String password) {
    state = state.copyWith(password: password);
    _isPinValid();
  }

  void onConfirmPasswordChanged(String password) {
    state = state.copyWith(confirmPassword: password);
    _isPinValid();
  }

  void _isPinValid() {
    if (state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty &&
        state.password.length >= 8 &&
        state.confirmPassword.length >= 8 &&
        state.password == state.confirmPassword) {
      state = state.copyWith(isValid: true, status: CreatePinStatus.initial);
    } else {
      state = state.copyWith(isValid: false, status: CreatePinStatus.initial);
    }
  }
}
