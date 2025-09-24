import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/seed_phrase_state.dart';
import '../repository/phrase_repository_impl.dart';
import 'seed_phrase_notifier.dart';

final phraseRepositoryProvider = Provider((ref) {
  return PhraseRepositoryImpl();
});

final seedPhraseProvider =
    StateNotifierProvider<SeedPhraseNotifier, SeedPhraseState>((ref) {
      final phraseRepository = ref.watch(phraseRepositoryProvider);
      return SeedPhraseNotifier(phraseRepository: phraseRepository);
    });
