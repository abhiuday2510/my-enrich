import 'package:flutter/material.dart';

class AppColors {
   static const lightColorScheme = ColorScheme.light(
  primary: Color(0xFF6A4CAF),      // Your pastel purple
  secondary: Color(0xFFFFD6A5),    // Soft peach
  background: Color(0xFFF8F8F8),   // Off-white background
  surface: Colors.white,
  onPrimary: Colors.white,
  onSecondary: Color(0xFF1E1E1E),
  onBackground: Color(0xFF1E1E1E),
  onSurface: Color(0xFF1E1E1E),
);

static const darkColorScheme = ColorScheme.dark(
  primary: Color(0xFF8E73D2),      // Muted purple (for dark mode)
  secondary: Color(0xFFFFC6A5),    // Muted peach
  background: Color(0xFF1C1C1E),   // Near black
  surface: Color(0xFF2C2C2E),
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onBackground: Colors.white,
  onSurface: Colors.white,
);


}
