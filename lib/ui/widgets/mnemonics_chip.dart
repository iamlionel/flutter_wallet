import 'package:flutter/material.dart';

import '../core/themes/colors.dart';
import '../core/themes/dimens.dart';
import '../core/themes/font_weights.dart';
import '../core/themes/text_styles.dart';

class MnemonicsChip extends StatelessWidget {
  const MnemonicsChip({
    Key? key,
    required this.text,
    this.onTap,
    this.index,
    this.isSelected = false,
  }) : super(key: key);

  final String text;
  final VoidCallback? onTap;
  final bool isSelected;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.primary.withOpacity(0.5),
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary),
          color: isSelected
              ? AppColors.primary.withOpacity(0.7)
              : AppColors.background,
        ),
        child: (index != null)
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    index.toString(),
                    style: AppTextStyle.caption.copyWith(
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.black.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(width: Dimens.of(context).minBlockVertical * 2),
                  Text(
                    text,
                    style: AppTextStyle.caption.copyWith(
                      fontSize: 18,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: AppTextStyle.caption.copyWith(
                  fontSize: 18,
                  fontWeight: AppFontWeight.semiBold,
                  color: isSelected ? Colors.transparent : AppColors.black,
                ),
              ),
      ),
    );
  }
}
