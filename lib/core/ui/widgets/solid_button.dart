import 'package:flutter/material.dart';

class SolidButton extends StatelessWidget {
  const SolidButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.textSize = 16.0,
    this.radius = 24,
    this.padding = const EdgeInsets.symmetric(vertical: 18),
    this.gradient,
    this.loading = false,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double textSize;
  final double radius;
  final EdgeInsets padding;
  final List<Color>? gradient;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;
    final contentColor =
        textColor ??
        (buttonColor == theme.colorScheme.primary
            ? Colors.black
            : Colors.white);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: gradient != null ? LinearGradient(colors: gradient!) : null,
        boxShadow: [
          if (onPressed != null)
            BoxShadow(
              color: (gradient?.first ?? buttonColor).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: gradient != null ? Colors.transparent : buttonColor,
          foregroundColor: contentColor,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
