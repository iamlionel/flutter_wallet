import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../ui/authentication/widgets/create_pin_screen.dart';
import '../ui/import_wallet/widgets/import_wallet_screen.dart';
import '../ui/home/widgets/home_screen.dart';
import '../ui/landing/widgets/splash_screen.dart';
import '../ui/seed_phrase/widgets/confirm_phrase_screen.dart';
import '../ui/seed_phrase/widgets/seed_phrase_screen.dart';
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
