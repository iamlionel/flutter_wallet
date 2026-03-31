import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../states/create_pin_state.dart';

export '../states/create_pin_state.dart';

// ── ViewModel ─────────────────────────────────────────────────────────────────

class CreatePinViewModel extends Notifier<CreatePinState> {
  @override
  CreatePinState build() => const CreatePinState();

  Future<void> getUserKeys(String mnemonics, String password) async {
    state = state.copyWith(status: CreatePinStatus.loading);
    try {
      final repo = ref.read(phraseRepositoryProvider);
      final privateKey = await repo.generatePrivatekey(mnemonics);
      final publicKey = await repo.generatePublicKey(privateKey);
      final derived = await repo.deriveAllAddresses(mnemonics);
      final data = Wallet(
        privateKey: privateKey,
        publicKey: publicKey.toString(),
        addresses: derived.addresses,
      );
      await repo.saveMnemonics(mnemonics, password);
      await repo.saveData(data, password);
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
    final valid = state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty &&
        state.password.length >= 8 &&
        state.confirmPassword.length >= 8 &&
        state.password == state.confirmPassword;
    state = state.copyWith(isValid: valid, status: CreatePinStatus.initial);
  }
}

final createPinViewModelProvider =
    NotifierProvider<CreatePinViewModel, CreatePinState>(
        () => CreatePinViewModel());
