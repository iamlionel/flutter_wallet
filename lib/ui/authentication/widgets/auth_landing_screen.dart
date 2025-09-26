import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/app_provider.dart';
import '../../../data/providers/auth_landing_provider.dart';
import '../../../domain/states/auth_landing_state.dart';
import '../../../routing/routes.dart';
import '../../core/themes/font_weights.dart';
import '../../core/themes/text_styles.dart';
import '../../widgets/extension.dart';
import '../../widgets/input_box.dart';
import '../../widgets/solid_button.dart';

class AuthLandingScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthLandingScreenState();
}

class _AuthLandingScreenState extends ConsumerState<AuthLandingScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authLandingProvider);
    final notifier = ref.read(authLandingProvider.notifier);
    ref.listen<AuthLandingState>(authLandingProvider, (previous, next) {
      if (next.status == AuthLandingStatus.failure) {
        context.showErrorMessage('Oops an error occur, Try again');
      } else if (next.status == AuthLandingStatus.success) {
        ref.read(appProvider.notifier).updateWalletModel(next.wallet);
        context.push(Routes.home);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/logo.svg', width: 100, height: 100),
              SizedBox(height: context.minBlockVertical * 2),
              Text(
                'Welcome Back!',
                style: AppTextStyle.headline2.copyWith(
                  fontWeight: AppFontWeight.bold,
                ),
              ),
              SizedBox(height: context.minBlockVertical * 7),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: AppTextStyle.overline.copyWith(),
                ),
              ),
              SizedBox(height: context.minBlockVertical),
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
              SizedBox(height: context.minBlockVertical * 5),
              SolidButton(
                text: 'Unlock',
                onPressed: state.isValid ? () => notifier.onSubmitted() : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
