import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/views/create_pin_screen.dart';
import '../../features/auth/presentation/views/import_wallet_screen.dart';
import '../../features/auth/presentation/views/confirm_phrase_screen.dart';
import '../../features/auth/presentation/views/seed_phrase_screen.dart';
import '../../features/wallet/presentation/views/home_screen.dart';
import '../../features/onboarding/presentation/views/splash_screen.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.landing,
    routes: [
      GoRoute(
        path: Routes.landing,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.seedPhrase,
        builder: (context, state) => const SeedPhraseScreen(),
      ),
      GoRoute(
        path: Routes.confirmSeedPhrase,
        builder: (context, state) => const ConfirmPhraseScreen(),
      ),
      GoRoute(
        path: Routes.importWallet,
        builder: (context, state) => const ImportWalletScreen(),
      ),
      GoRoute(
        path: Routes.createPin,
        builder: (context, state) {
          final mnemonics = state.extra as String;
          return CreatePinScreen(mnemonics: mnemonics);
        },
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
