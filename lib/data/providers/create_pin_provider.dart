import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/states/create_pin_state.dart';
import 'create_pin_notifier.dart';
import 'seed_phrase_provider.dart';

final createPinProvider =
    StateNotifierProvider<CreatePinNotifier, CreatePinState>((ref) {
      final repository = ref.watch(phraseRepositoryProvider);
      return CreatePinNotifier(phraseRepository: repository);
    });
