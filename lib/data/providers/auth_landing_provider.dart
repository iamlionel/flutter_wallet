import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/states/auth_landing_state.dart';
import 'auth_landing_notifier.dart';
import 'seed_phrase_provider.dart';

final authLandingProvider =
    StateNotifierProvider<AuthLandingNotifier, AuthLandingState>((ref) {
      final repository = ref.watch(phraseRepositoryProvider);
      return AuthLandingNotifier(phraseRepository: repository);
    });
