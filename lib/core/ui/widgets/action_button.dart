import 'package:flutter/material.dart';

import '../themes/colors.dart';
import '../themes/font_weights.dart';
import '../themes/text_styles.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 30,
            child: Icon(icon, color: AppColors.white, size: 30),
          ),
          Text(
            text,
            style: AppTextStyle.overline.copyWith(
              fontSize: 18,
              fontWeight: AppFontWeight.medium,
            ),
          ),
        ],
      ),
    );
  }
}
