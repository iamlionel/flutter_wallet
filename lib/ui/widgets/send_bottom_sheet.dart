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
    return Container(
      height: context.screenHeight - (context.screenHeight / 3),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Align(
            child: Text(
              'Send',
              style: AppTextStyle.headline2.copyWith(
                fontWeight: AppFontWeight.bold,
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
                  color: Colors.white,
                  textColor: AppColors.primary,
                  border: const BorderSide(color: AppColors.primary),
                  onPressed: () {},
                ),
              ),
              SizedBox(width: context.minBlockHorizontal * 5),
              Expanded(
                child: SolidButton(text: 'Next', onPressed: () {}),
              ),
            ],
          ),
          SizedBox(height: context.minBlockVertical * 4),
        ],
      ),
    );
  }
}
