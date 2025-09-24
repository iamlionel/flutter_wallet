import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../ui/landing/widgets/landing_screen.dart';
import '../ui/seed_phrase/widgets/seed_phrase_screen.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      GoRoute(
        path: Routes.seedPhrase,
        builder: (context, state) => const SeedPhraseScreen(),
      ),
    ],
  );
});
