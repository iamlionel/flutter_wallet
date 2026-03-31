import 'package:flutter/material.dart';

class Dimens {
  final BuildContext _context;

  const Dimens._(this._context);

  // 屏幕尺寸
  double get screenWidth => MediaQuery.of(_context).size.width;
  double get screenHeight => MediaQuery.of(_context).size.height;

  // 最小单位（屏幕的1%）
  double get minScreenWidth => screenWidth / 100;
  double get minScreenHeight => screenHeight / 100;

  // 安全区域 padding
  EdgeInsets get padding => MediaQuery.of(_context).padding;
  double get screenSymmetricHorizontal => padding.left + padding.right;
  double get screenSymmetricVertical => padding.top + padding.bottom;

  // 可用区域的最小单位（减去安全区域后的1%）
  double get minBlockHorizontal =>
      (screenWidth - screenSymmetricHorizontal) / 100;
  double get minBlockVertical => (screenHeight - screenSymmetricVertical) / 100;

  // 可用区域尺寸
  double get availableWidth => screenWidth - screenSymmetricHorizontal;
  double get availableHeight => screenHeight - screenSymmetricVertical;

  // 设备类型判断
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  // 响应式尺寸
  double responsive({required double mobile, double? tablet, double? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // 工厂方法
  factory Dimens.of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return switch (width) {
      _ => _DimensMobile._(context),
    };
  }
}

// 移动端特定尺寸
final class _DimensMobile extends Dimens {
  const _DimensMobile._(BuildContext context) : super._(context);

  // 移动端特定的尺寸定义
  double get smallPadding => 8.0;
  double get mediumPadding => 16.0;
  double get largePadding => 24.0;

  double get buttonHeight => 48.0;
  double get appBarHeight => 56.0;
}
