import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/seed_phrase_state.dart';
import '../repository/phrase_repository.dart';

class SeedPhraseNotifier extends StateNotifier<SeedPhraseState> {
  SeedPhraseNotifier({required PhraseRepository phraseRepository})
    : _phraseRepository = phraseRepository,
      super(const SeedPhraseState());

  final PhraseRepository _phraseRepository;

  void generateMnemonic() {
    final mnemonic = _phraseRepository.getMnemonics();
    final mnemonics = mnemonic.toList;
    final randomMnemonics = [...mnemonics]..shuffle(Random.secure());

    state = state.copyWith(
      mnemonics: mnemonics,
      randomMnemonics: randomMnemonics,
    );
  }

  void clearSelectedMnemonics() {
    state = state.copyWith(
      confirmMnemonics: [],
      isMnemonicsValid: false,
      status: SeedPhraseStatus.initial,
    );
  }

  void addSelectedMnemonics(String text) {
    final currentSelectedMnemonics = <String>[];
    for (final mnemonic in state.confirmMnemonics) {
      currentSelectedMnemonics.add(mnemonic);
    }
    if (state.confirmMnemonics.contains(text)) {
      currentSelectedMnemonics.remove(text);
    } else {
      currentSelectedMnemonics.add(text);
    }
    state = state.copyWith(
      confirmMnemonics: currentSelectedMnemonics,
      isMnemonicsValid: false,
      status: SeedPhraseStatus.initial,
    );
    validateMnemonics();
  }

  void validateMnemonics() {
    if (state.confirmMnemonics.length != 12) return;
    if (listEquals(state.mnemonics, state.confirmMnemonics)) {
      state = state.copyWith(
        status: SeedPhraseStatus.success,
        isMnemonicsValid: true,
      );
    } else {
      state = state.copyWith(
        status: SeedPhraseStatus.failure,
        errorMessage: 'Invalid Mnemonics',
        isMnemonicsValid: false,
      );
    }
  }
}

extension StringX on String {
  List<String> get toList => split(' ').toList();
}
