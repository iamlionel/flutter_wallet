import 'dart:math';

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
}

extension StringX on String {
  List<String> get toList => split(' ').toList();
}
