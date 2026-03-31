import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/colors.dart';
import '../themes/font_weights.dart';
import '../themes/text_styles.dart';

class InputBox extends StatelessWidget {
  const InputBox({
    Key? key,
    this.controller,
    this.validator,
    this.hintText,
    this.labelText,
    this.errorText,
    this.icon,
    this.leadingIcon,
    this.leadingColor = AppColors.primaryText,
    this.fillColor = AppColors.background,
    this.maxLength,
    this.inputFormat,
    this.inputType,
    this.isPassword = false,
    this.raduis = 10.0,
    this.borderSide = const BorderSide(color: AppColors.grey),
    this.iconSize = 24.0,
    this.isWritable = true,
    this.enablePrefix = true,
    this.onChanged,
    this.value = '',
    this.onFieldSubmitted,
    this.focus,
    this.onIconClick,
  }) : super(key: key);

  final bool isWritable;
  final FormFieldValidator? validator;
  final List<TextInputFormatter>? inputFormat;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final int? maxLength;
  final FocusNode? focus;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isPassword;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final IconData? icon;
  final IconData? leadingIcon;
  final Color fillColor;
  final BorderSide borderSide;
  final double raduis;
  final VoidCallback? onIconClick;
  final String value;
  final Color leadingColor;
  final bool enablePrefix;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isWritable,
      validator: validator,
      inputFormatters: inputFormat,
      onChanged: onChanged,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: inputType,
      maxLength: maxLength,
      focusNode: focus,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: isPassword,
      style: AppTextStyle.overline.copyWith(color: AppColors.primaryText),
      decoration: InputDecoration(
        hintStyle: AppTextStyle.overline.copyWith(
          color: AppColors.primaryText.withOpacity(0.4),
          fontWeight: AppFontWeight.medium,
        ),
        counterText: '',
        hintText: hintText,
        labelText: labelText,
        labelStyle: AppTextStyle.overline.copyWith(
          color: AppColors.primaryText,
          fontSize: 18,
        ),
        fillColor: fillColor,
        filled: true,
        errorText: errorText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(raduis),
          borderSide: borderSide,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(raduis),
          borderSide: borderSide,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(raduis),
          borderSide: borderSide,
        ),
        contentPadding: const EdgeInsets.only(
          // left: 20,
          bottom: 20,
          top: 20,
        ),
        prefix: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(''),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: onIconClick,
            child: Icon(icon, color: AppColors.black, size: 30),
          ),
        ),
      ),
    );
  }
}
