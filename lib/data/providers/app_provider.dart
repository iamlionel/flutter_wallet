import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_notifier.dart';
import 'seed_phrase_provider.dart';

final appProvider = StateNotifierProvider((ref) {
  final repository = ref.watch(phraseRepositoryProvider);
  return AppNotifier(phraseRepository: repository);
});
