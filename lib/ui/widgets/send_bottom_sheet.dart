import 'package:flutter/material.dart';

import '../core/themes/colors.dart';
import '../core/themes/font_weights.dart';
import '../core/themes/text_styles.dart';
import 'extension.dart';
import 'input_box.dart';
import 'solid_button.dart';

class SendBottomSheet extends StatelessWidget {
  const SendBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: context.screenHeight - (context.screenHeight / 3),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Align(
            child: Text(
              'Send',
              style: AppTextStyle.headline2.copyWith(
                fontWeight: AppFontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: context.minBlockVertical * 2),
          const InputBox(hintText: 'Search, public address (0x), ENS'),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: SolidButton(
                  text: 'Cancel',
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.shade100,
                  textColor: isDark ? Colors.white : Colors.black,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(width: context.minBlockHorizontal * 5),
              Expanded(
                child: SolidButton(
                  text: 'Next',
                  gradient: AppColors.primaryGradient,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: context.minBlockVertical * 4),
        ],
      ),
    );
  }
}
