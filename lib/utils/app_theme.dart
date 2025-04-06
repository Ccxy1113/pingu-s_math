import 'package:flutter/material.dart';

class AppTheme {
  // Main Theme Colors
  static const Color primaryColor = Color.fromARGB(255, 25, 118, 210);
  static const Color primaryLightColor = Color.fromARGB(255, 66, 165, 245);
  static const Color primaryDarkColor = Color.fromARGB(255, 13, 71, 161);

  // Background Gradients
  static const Color gradientTopColor = Color.fromARGB(255, 227, 242, 253);
  static const Color gradientMiddleColor = Color.fromARGB(255, 179, 229, 252);
  static const Color gradientBottomColor = Color.fromARGB(255, 129, 212, 250);

  // Accent Colors
  static const Color accentColor = Color.fromARGB(255, 41, 182, 246);
  static const Color snowColor = Colors.white;
  static const Color iceColor = Color.fromARGB(255, 225, 245, 254);

  // Game Button Colors
  static const Color compareButtonColor = Color.fromARGB(255, 60, 193, 255);
  static const Color symbolsButtonColor = Color.fromARGB(255, 57, 175, 248);
  static const Color orderButtonColor = Color.fromARGB(255, 55, 165, 234);
  static const Color composeButtonColor = Color.fromARGB(255, 30, 136, 229);

  // Text Colors
  static const Color primaryTextColor = Color.fromARGB(255, 13, 71, 161);
  static const Color secondaryTextColor = Color.fromARGB(255, 1, 87, 155);
  static const Color lightTextColor = Colors.white;

  // Shadow Colors
  static const Color shadowColor = Color.fromARGB(64, 0, 0, 0);
  static const Color blueShadowColor = Color.fromARGB(64, 79, 195, 247);

  // Border Settings
  static const double borderWidth = 2.0;
  static const double borderRadius = 20.0;
  static BorderRadius standardBorderRadius = BorderRadius.circular(
    borderRadius,
  );

  // Shadow Settings
  static List<BoxShadow> standardShadow = [
    BoxShadow(
      color: shadowColor.withValues(alpha: 0.2),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> blueShadow = [
    BoxShadow(
      color: blueShadowColor.withValues(alpha: 0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // Gradients
  static LinearGradient backgroundGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gradientTopColor, gradientMiddleColor, gradientBottomColor],
  );

  static LinearGradient buttonGradient(Color color) {
    return LinearGradient(
      colors: [color, color.withValues(alpha: 0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Border Decorations
  static BoxBorder iceBorder = Border.all(
    color: snowColor.withValues(alpha: 0.8),
    width: borderWidth,
  );

  // Container Decorations
  static BoxDecoration iceContainerDecoration = BoxDecoration(
    color: snowColor.withValues(alpha: 0.7),
    borderRadius: standardBorderRadius,
    border: iceBorder,
    boxShadow: blueShadow,
  );

  static BoxDecoration buttonDecoration(Color color) {
    return BoxDecoration(
      gradient: buttonGradient(color),
      borderRadius: standardBorderRadius,
      border: iceBorder,
    );
  }
}
