import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/presentation/viewmodels/app_viewmodel.dart';
import '../viewmodels/create_pin_viewmodel.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui/themes/colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/ui/widgets/input_box.dart';
import '../../../../core/ui/widgets/solid_button.dart';

class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({Key? key, required this.mnemonics}) : super(key: key);

  final String mnemonics;

  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinState();
}

class _CreatePinState extends ConsumerState<CreatePinScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPinViewModelProvider);
    final notifier = ref.read(createPinViewModelProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<CreatePinState>(createPinViewModelProvider, (previous, next) {
      if (next.status == CreatePinStatus.failure) {
        context.showErrorMessage('Oops an error occur, Try again');
      } else if (next.status == CreatePinStatus.success) {
        ref.read(appViewModelProvider.notifier).updateWallet(next.wallet);
        context.push(Routes.home);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Password'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set a secure password to protect your assets on this device.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: context.minBlockVertical * 5),
                Text(
                  'New Password',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                InputBox(
                  hintText: 'Minimum 8 characters',
                  onChanged: notifier.onPasswordChanged,
                  isPassword: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Password is required';
                    if (value!.length < 8) return 'Password too short';
                    return null;
                  },
                ),
                SizedBox(height: context.minBlockVertical * 4),
                Text(
                  'Confirm Password',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                InputBox(
                  hintText: 'Confirm your password',
                  isPassword: true,
                  onChanged: notifier.onConfirmPasswordChanged,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Confirm Password is required';
                    }
                    if (value != state.password) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.screenHeight * 0.15),
                SolidButton(
                  text: 'Create Wallet',
                  gradient: AppColors.primaryGradient,
                  loading: state.status == CreatePinStatus.loading,
                  onPressed:
                      state.status != CreatePinStatus.loading && state.isValid
                      ? () => notifier.getUserKeys(
                          widget.mnemonics,
                          state.password,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
