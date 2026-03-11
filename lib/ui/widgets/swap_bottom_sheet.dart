import 'package:flutter/material.dart';

import '../core/themes/colors.dart';
import '../core/themes/font_weights.dart';
import '../core/themes/text_styles.dart';
import 'extension.dart';
import 'input_box.dart';
import 'solid_button.dart';

class SwapBottomSheet extends StatelessWidget {
  const SwapBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: context.screenHeight - (context.screenHeight / 3),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            child: Text(
              'Swap',
              style: AppTextStyle.headline2.copyWith(
                fontWeight: AppFontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: context.minBlockVertical * 2),
          Text(
            'Swap from',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const InputBox(hintText: 'Ethereum (ETH)'),
          SizedBox(height: context.minBlockVertical * 2),
          Text(
            'Swap to',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const InputBox(hintText: 'Search token...'),
          const Spacer(),
          SolidButton(
            text: 'Review',
            gradient: AppColors.primaryGradient,
            onPressed: () {},
          ),
          SizedBox(height: context.minBlockVertical * 4),
        ],
      ),
    );
  }
}
