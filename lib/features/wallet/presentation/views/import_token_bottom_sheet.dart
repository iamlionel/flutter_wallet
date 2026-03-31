import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/themes/colors.dart';
import '../../../../core/ui/themes/font_weights.dart';
import '../../../../core/ui/themes/text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/ui/widgets/input_box.dart';
import '../../../../core/ui/widgets/solid_button.dart';

import '../viewmodels/token_viewmodel.dart';

class ImportTokenBottomSheet extends ConsumerStatefulWidget {
  const ImportTokenBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<ImportTokenBottomSheet> createState() =>
      _ImportTokenBottomSheetState();
}

class _ImportTokenBottomSheetState
    extends ConsumerState<ImportTokenBottomSheet> {
  late final TextEditingController _symbolController;
  late final TextEditingController _decimalController;

  @override
  void initState() {
    super.initState();
    _symbolController = TextEditingController();
    _decimalController = TextEditingController();
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _decimalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen<ImportTokenState>(importTokenViewModelProvider, (
      previous,
      next,
    ) {
      if (previous?.status != ImportTokenStatus.success &&
          next.status == ImportTokenStatus.success) {
        _symbolController.text = next.tokenSymbol;
        _decimalController.text = next.tokenDecimal;
      }
    });

    return Container(
      height: context.screenHeight - (context.screenHeight / 5),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Import Tokens',
              style: AppTextStyle.headline2.copyWith(
                fontWeight: AppFontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: context.minBlockVertical * 2),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: context.minBlockHorizontal * 3),
                  Expanded(
                    child: Text(
                      '''Anyone can create a token, including fake versions of existing tokens.''',
                      style: AppTextStyle.overline.copyWith(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: AppFontWeight.regular,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.minBlockVertical * 3),
            InputBox(
              hintText: 'Contract Address',
              onChanged: _onContractAddressChanged,
            ),
            SizedBox(height: context.minBlockVertical * 3),
            Column(
              children: [
                InputBox(
                  controller: _symbolController,
                  hintText: 'Token Symbol',
                ),
                SizedBox(height: context.minBlockVertical * 3),
                InputBox(
                  controller: _decimalController,
                  hintText: 'Token Decimal',
                ),
              ],
            ),
            SizedBox(height: context.minBlockVertical * 4),
            Builder(
              builder: (context) {
                final addTokenState = ref.watch(importTokenViewModelProvider);
                return SolidButton(
                  text: 'Add Token',
                  gradient: AppColors.primaryGradient,
                  onPressed: addTokenState.status == ImportTokenStatus.success
                      ? () {
                          final token = ref
                              .read(importTokenViewModelProvider.notifier)
                              .currentToken;
                          if (token != null) {
                            ref
                                .read(savedTokensViewModelProvider.notifier)
                                .addToken(token);
                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                );
              },
            ),
            SizedBox(height: context.minBlockVertical * 4),
          ],
        ),
      ),
    );
  }

  void _onContractAddressChanged(String address) {
    ref
        .read(importTokenViewModelProvider.notifier)
        .onContractAddressChanged(address);
  }
}
