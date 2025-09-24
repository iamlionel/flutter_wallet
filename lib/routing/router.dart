import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../ui/landing/widgets/landing_screen.dart';
import '../ui/seed_phrase/widgets/confirm_phrase_screen.dart';
import '../ui/seed_phrase/widgets/seed_phrase_screen.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.landing,
    routes: [
      GoRoute(
        path: Routes.landing,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: Routes.seedPhrase,
        builder: (context, state) => const SeedPhraseScreen(),
      ),
      GoRoute(
        path: Routes.confirmSeedPhrase,
        builder: (context, state) => const ConfirmPhraseScreen(),
      ),
    ],
  );
});
