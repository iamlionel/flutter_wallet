import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/add_token_provider.dart';
import '../../domain/states/add_token_state.dart';
import '../core/themes/colors.dart';
import '../core/themes/font_weights.dart';
import '../core/themes/text_styles.dart';
import 'extension.dart';
import 'input_box.dart';
import 'solid_button.dart';

class AddTokenBottomSheet extends ConsumerStatefulWidget {
  const AddTokenBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<AddTokenBottomSheet> createState() =>
      _AddTokenBottomSheetState();
}

class _AddTokenBottomSheetState extends ConsumerState<AddTokenBottomSheet> {
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

    ref.listen<AddTokenState>(addTokenProvider, (previous, next) {
      if (previous?.status != AddTokenStatus.success &&
          next.status == AddTokenStatus.success) {
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
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
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
            SolidButton(
              text: 'Add Token',
              gradient: AppColors.primaryGradient,
              onPressed: () {},
            ),
            SizedBox(height: context.minBlockVertical * 4),
          ],
        ),
      ),
    );
  }

  void _onContractAddressChanged(String address) {
    ref.read(addTokenProvider.notifier).onContractAddressChanged(address);
  }
}
