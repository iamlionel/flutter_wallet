import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/app_provider.dart';
import '../../../domain/repositories/phrase_repository.dart';
import '../../authentication/widgets/auth_landing_screen.dart';
import 'landing_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    if (state.status == AuthStatus.authenticated) {
      return AuthLandingScreen();
    } else if (state.status == AuthStatus.unauthenticated) {
      return LandingScreen();
    } else {
      return LandingScreen();
    }
  }
}
