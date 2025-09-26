import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/phrase_repository.dart';
import '../../domain/states/seed_phrase_state.dart';
import '../repositories/phrase_repository_impl.dart';
import 'secure_storage_provider.dart';
import 'seed_phrase_notifier.dart';

final phraseRepositoryProvider = Provider<PhraseRepository>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return PhraseRepositoryImpl(storage: secureStorage);
});

final seedPhraseProvider =
    StateNotifierProvider<SeedPhraseNotifier, SeedPhraseState>((ref) {
      final phraseRepository = ref.watch(phraseRepositoryProvider);
      return SeedPhraseNotifier(phraseRepository: phraseRepository);
    });
