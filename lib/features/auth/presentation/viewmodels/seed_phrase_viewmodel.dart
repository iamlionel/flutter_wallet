import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../states/seed_phrase_state.dart';

export '../states/seed_phrase_state.dart';

// ── ViewModel ─────────────────────────────────────────────────────────────────

class SeedPhraseViewModel extends Notifier<SeedPhraseState> {
  @override
  SeedPhraseState build() => const SeedPhraseState();

  void generateMnemonic() {
    final mnemonic = ref.read(phraseRepositoryProvider).getMnemonics();
    final mnemonics = mnemonic.toList;
    final randomMnemonics = [...mnemonics]..shuffle(Random.secure());
    state = state.copyWith(mnemonics: mnemonics, randomMnemonics: randomMnemonics);
  }

  void clearSelectedMnemonics() {
    state = state.copyWith(
      confirmMnemonics: [],
      isMnemonicsValid: false,
      status: SeedPhraseStatus.initial,
    );
  }

  void addSelectedMnemonics(String text) {
    final current = [...state.confirmMnemonics];
    if (current.contains(text)) {
      current.remove(text);
    } else {
      current.add(text);
    }
    state = state.copyWith(
      confirmMnemonics: current,
      isMnemonicsValid: false,
      status: SeedPhraseStatus.initial,
    );
    validateMnemonics();
  }

  void validateMnemonics() {
    if (state.confirmMnemonics.length != 12) return;
    if (listEquals(state.mnemonics, state.confirmMnemonics)) {
      state = state.copyWith(status: SeedPhraseStatus.success, isMnemonicsValid: true);
    } else {
      state = state.copyWith(
        status: SeedPhraseStatus.failure,
        errorMessage: 'Invalid Mnemonics',
        isMnemonicsValid: false,
      );
    }
  }
}

final seedPhraseViewModelProvider =
    NotifierProvider<SeedPhraseViewModel, SeedPhraseState>(
        () => SeedPhraseViewModel());

extension StringX on String {
  List<String> get toList => split(' ').toList();
}
