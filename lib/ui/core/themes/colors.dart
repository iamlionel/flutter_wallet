import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const primary = Color(0xFF00E5FF); // Vibrant Cyan
  static const secondary = Color(0xFF1E1E2C); // Deep Slate
  static const accent = Color(0xFFFFD700); // Gold

  // Backgrounds
  static const background = Color(0xFF0A0C10); // Deep Navy/Black
  static const surface = Color(0xFF161B22); // Slightly lighter than background
  static const surfaceVariant = Color(0xFF21262D);

  // Logic Colors
  static const success = Color(0xFF00C853);
  static const warning = Color(0xFFFFAB00);
  static const danger = Color(0xFFFF5252);
  static const info = Color(0xFF2979FF);

  // Text Colors
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8B949E);
  static const textHint = Color(0xFF484F58);

  // Neutrals
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const grey = Color(0xFF8B949E);

  // Gradients
  static const primaryGradient = [Color(0xFF00E5FF), Color(0xFF2979FF)];

  static const backgroundGradient = [Color(0xFF0A0C10), Color(0xFF1E1E2C)];

  // Utility & Backward Compatibility Aliases
  static const scaffold = background;
  static const primaryIcon = primary;
  static const secondaryIcon = grey;
  static const primaryBorder = Color(0xFF30363D);
  static const secondaryBorder = Color(0xFF21262D);

  static const primaryText = textPrimary;
  static const secondaryText = textSecondary;
  static const secondaryButton = info;
}
