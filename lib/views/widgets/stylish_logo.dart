import 'package:flutter/material.dart';

class StylishLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final double iconSize;
  final double fontSize;
  final bool showText;
  final Color? textColor;

  const StylishLogo({
    super.key,
    this.width,
    this.height = 36,
    this.iconSize = 36,
    this.fontSize = 24,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: height,
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback in case asset cannot be loaded
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF4392F9), Color(0xFFF83758)],
                ),
              ),
            ),
            if (showText) ...[
              const SizedBox(width: 8),
              Text(
                'Stylish',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? const Color(0xFFF83758),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
