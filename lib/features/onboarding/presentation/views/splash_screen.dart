import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/presentation/viewmodels/app_viewmodel.dart';
import '../../../auth/domain/repositories/phrase_repository.dart';
import '../../../auth/presentation/views/auth_landing_screen.dart';
import 'landing_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appViewModelProvider);
    if (state.status == AuthStatus.authenticated) {
      return AuthLandingScreen();
    } else if (state.status == AuthStatus.unauthenticated) {
      return LandingScreen();
    } else {
      return LandingScreen();
    }
  }
}
