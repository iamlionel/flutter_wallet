import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/app_provider.dart';
import '../../../data/providers/auth_landing_provider.dart';
import '../../../domain/states/auth_landing_state.dart';
import '../../../routing/routes.dart';
import '../../core/themes/colors.dart';
import '../../widgets/extension.dart';
import '../../widgets/input_box.dart';
import '../../widgets/solid_button.dart';

class AuthLandingScreen extends ConsumerStatefulWidget {
  const AuthLandingScreen({super.key});

  @override
  ConsumerState<AuthLandingScreen> createState() => _AuthLandingScreenState();
}

class _AuthLandingScreenState extends ConsumerState<AuthLandingScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authLandingProvider);
    final notifier = ref.read(authLandingProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<AuthLandingState>(authLandingProvider, (previous, next) {
      if (next.status == AuthLandingStatus.failure) {
        context.showErrorMessage('Oops an error occur, Try again');
      } else if (next.status == AuthLandingStatus.success) {
        ref.read(appProvider.notifier).updateWalletModel(next.wallet);
        context.push(Routes.home);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.backgroundGradient,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  SizedBox(height: context.minBlockVertical * 5),
                  // Logo Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: SvgPicture.asset(
                      'assets/logo.svg',
                      width: 60,
                      height: 60,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(height: context.minBlockVertical * 4),
                  Text(
                    'Welcome Back!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Enter your password to unlock your wallet.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: context.minBlockVertical * 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InputBox(
                    hintText: 'Enter your password',
                    onChanged: notifier.onPasswordChanged,
                    isPassword: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.minBlockVertical * 6),
                  SolidButton(
                    text: 'Unlock',
                    gradient: AppColors.primaryGradient,
                    loading: state.status == AuthLandingStatus.loading,
                    onPressed:
                        state.status != AuthLandingStatus.loading &&
                            state.isValid
                        ? () => notifier.onSubmitted()
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
