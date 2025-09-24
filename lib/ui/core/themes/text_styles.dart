import 'package:flutter/material.dart';

import 'colors.dart';
import 'font_weights.dart';
// import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static const TextStyle _textStyle = TextStyle(
    color: AppColors.primaryText,
    fontWeight: AppFontWeight.regular,
  );

  /// Headline 1 Text Style
  static TextStyle get headline1 {
    return _textStyle.copyWith(fontSize: 56, fontWeight: AppFontWeight.medium);
  }

  /// Headline 2 Text Style
  static TextStyle get headline2 {
    return _textStyle.copyWith(fontSize: 30, fontWeight: AppFontWeight.regular);
  }

  /// Headline 3 Text Style
  static TextStyle get headline3 {
    return _textStyle.copyWith(fontSize: 24, fontWeight: AppFontWeight.regular);
  }

  /// Headline 4 Text Style
  static TextStyle get headline4 {
    return _textStyle.copyWith(fontSize: 22, fontWeight: AppFontWeight.bold);
  }

  /// Headline 5 Text Style
  static TextStyle get headline5 {
    return _textStyle.copyWith(fontSize: 22, fontWeight: AppFontWeight.medium);
  }

  /// Headline 6 Text Style
  static TextStyle get headline6 {
    return _textStyle.copyWith(fontSize: 20, fontWeight: AppFontWeight.medium);
  }

  /// Subtitle 1 Text Style
  static TextStyle get subtitle1 {
    return _textStyle.copyWith(fontSize: 16, fontWeight: AppFontWeight.bold);
  }

  /// Subtitle 2 Text Style
  static TextStyle get subtitle2 {
    return _textStyle.copyWith(fontSize: 14, fontWeight: AppFontWeight.bold);
  }

  /// Body Text 1 Text Style
  static TextStyle get bodyText1 {
    return _textStyle.copyWith(fontSize: 18, fontWeight: AppFontWeight.medium);
  }

  /// Body Text 2 Text Style (the default)
  static TextStyle get bodyText2 {
    return _textStyle.copyWith(fontSize: 16, fontWeight: AppFontWeight.regular);
  }

  /// Caption Text Style
  static TextStyle get caption {
    return _textStyle.copyWith(fontSize: 14, fontWeight: AppFontWeight.regular);
  }

  /// Overline Text Style
  static TextStyle get overline {
    return _textStyle.copyWith(fontSize: 16, fontWeight: AppFontWeight.regular);
  }

  /// Button Text Style
  static TextStyle get button {
    return _textStyle.copyWith(fontSize: 18, fontWeight: AppFontWeight.medium);
  }

  /// Text Button Text Style
  static TextStyle get textButton {
    return _textStyle.copyWith(fontSize: 16, fontWeight: AppFontWeight.medium);
  }

  ///Big Text
  static TextStyle get bigText =>
      _textStyle.copyWith(fontSize: 27, fontWeight: AppFontWeight.black);

  ///Small Text
  static TextStyle get smallText =>
      _textStyle.copyWith(fontSize: 14, fontWeight: AppFontWeight.regular);
}
