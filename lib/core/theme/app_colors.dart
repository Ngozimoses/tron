import 'package:flutter/material.dart';

class AppColors {
  // ═══════════════════════════════════════════════════════
  // PRIMARY ORANGE PALETTE (Your Brand Colors)
  // ═══════════════════════════════════════════════════════

  /// Main brand color - Primary buttons, active states, key accents
  /// #f97316 - Normal (7.49 AAA contrast)
  static const Color primary = Color(0xFFF97316);

  static const Color primaryblack = Colors.black;

  /// Light variant - Hover states, light backgrounds, disabled active
  /// #feeadc - Normal :hover (6.16 AAA contrast)
  static const Color primaryLight = Color(0xFFFEeadc);

  /// Dark variant - Active states, pressed buttons, strong accents
  /// #c75c12 - Normal :active (4.97 AAA contrast)
  static const Color primaryDark = Color(0xFFC75C12);

  /// Extra dark - Focus rings, strong borders
  /// #bb5611 - Dark (4.45 AA contrast)
  static const Color primaryDarker = Color(0xFFBB5611);

  /// Darkest - Text on light backgrounds, strong emphasis
  /// #572808 - Darkest (12.26 AAA contrast)
  static const Color primaryDarkest = Color(0xFF572808);


  // ═══════════════════════════════════════════════════════
  // BACKGROUND & SURFACE COLORS (Orange-tinted neutrals)
  // ═══════════════════════════════════════════════════════

  /// Main app background - Very light orange tint
  /// #fef1e8 - Light (18.96 AAA contrast)
  static const Color background = Colors.white;

  /// Card/surface background - Pure white for contrast
  /// #FFFFFF - Light (21.00 AAA contrast)
  static const Color surface = Color(0xFFFFFFFF);

  /// Secondary surface - Slight orange tint for depth
  /// #feeadc - Light :hover (18.02 AAA contrast)
  static const Color surfaceLight = Color(0xFFFEeadc);

  /// Card background variant
  /// #fdd4b7 - Light :active (15.28 AAA contrast)
  static const Color cardBackground = Color(0xFFFDD4B7);


  // ═══════════════════════════════════════════════════════
  // TEXT COLORS (Orange-brown scale for readability)
  // ═══════════════════════════════════════════════════════

  /// Primary text - Darkest orange-brown for main content
  /// #572808 - Darkest (12.26 AAA contrast on background)
  static const Color textPrimary = Color(0xFF572808);

  /// Secondary text - Dark orange for subtitles, labels
  /// #70340a - Dark :active (9.61 AAA contrast)
  static const Color textSecondary = Color(0xFF70340A);

  /// Hint/disabled text - Medium-dark orange
  /// #95450d - Dark :hover (6.70 AAA contrast)
  static const Color textHint = Color(0xFF95450D);

  /// White text - For use on primary/dark backgrounds
  static const Color textWhite = Color(0xFFFFFFFF);

  /// Text on primary button (ensure contrast)
  static const Color textOnPrimary = Color(0xFFFFFFFF);


  // ═══════════════════════════════════════════════════════
  // STATUS & SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════

  /// Success - Green (complementary to orange, good contrast)
  static const Color success = Color(0xFF22C55E);

  /// Warning - Use primary orange (your brand color)
  static const Color warning = Color(0xFFF97316);

  /// Error - Red-orange for urgency
  static const Color error = Color(0xFFDC2626);

  /// Error light variant for backgrounds
  static const Color errorLight = Color(0xFFFEE2E2);

  /// Info - Blue (complementary, good for notices)
  static const Color info = Color(0xFF3B82F6);

  /// Info light variant for backgrounds
  static const Color infoLight = Color(0xFFDBEAFE);


  // ═══════════════════════════════════════════════════════
  // UI ELEMENT COLORS
  // ═══════════════════════════════════════════════════════

  /// Divider lines - Light orange tint
  /// #fdd4b7 - Light :active (15.28 AAA contrast)
  static const Color divider = Color(0xFFFDD4B7);

  /// Border color - Medium light orange
  static const Color border = Color(0xFFFDD4B7);

  /// Border focused - Primary color
  static const Color borderFocused = Color(0xFFF97316);

  /// Shadow color - Black with low opacity (works on orange bg)
  static const Color shadow = Color(0x1A000000);

  /// Overlay/backdrop - Dark orange-brown with opacity
  static const Color overlay = Color(0x80572808);


  // ═══════════════════════════════════════════════════════
  // BUTTON & INTERACTION STATES
  // ═══════════════════════════════════════════════════════

  /// Button background - Normal state
  static const Color buttonPrimary = Color(0xFFF97316);

  /// Button background - Hover state
  static const Color buttonPrimaryHover = Color(0xFFE06814);

  /// Button background - Pressed/Active state
  static const Color buttonPrimaryActive = Color(0xFFC75C12);

  /// Button background - Disabled state
  static const Color buttonDisabled = Color(0xFFFDD4B7);

  /// Button text - Disabled state
  static const Color buttonTextDisabled = Color(0xFF95450D);

  /// Outline button border - Normal
  static const Color buttonOutline = Color(0xFFF97316);

  /// Outline button border - Hover
  static const Color buttonOutlineHover = Color(0xFFE06814);


  // ═══════════════════════════════════════════════════════
  // INPUT FIELD COLORS
  // ═══════════════════════════════════════════════════════

  /// Input field background
  static const Color inputBackground = Color(0xFFFFFFFF);

  /// Input field border - Normal
  static const Color inputBorder = Color(0xFFFDD4B7);

  /// Input field border - Focused
  static const Color inputBorderFocused = Color(0xFFF97316);
// Add this inside the PRIMARY ORANGE PALETTE section:

  /// Secondary color - Complementary darker orange for gradients
  /// #E06814 - Normal :hover (6.16 AAA contrast)
  static const Color secondary = Color(0xFFE06814);

  /// Secondary light - For subtle accents
  /// #FEeadc - Light :hover (18.02 AAA contrast)
  static const Color secondaryLight = Color(0xFFFEeadc);

  /// Secondary dark - For strong accents
  /// #95450d - Dark :hover (6.70 AAA contrast)
  static const Color secondaryDark = Color(0xFF95450D);
  /// Input field border - Error
  static const Color inputBorderError = Color(0xFFDC2626);

  /// Input placeholder text
  static const Color inputPlaceholder = Color(0xFF95450D);


  // ═══════════════════════════════════════════════════════
  // GRADIENTS (Pre-defined for common use cases)
  // ═══════════════════════════════════════════════════════

  /// Primary gradient for headers, cards, CTAs
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF97316), // primary
      Color(0xFFC75C12), // primaryDark
    ],
  );

  /// Subtle background gradient for app background
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFEF1E8), // background
      Color(0xFFFEeadc), // surfaceLight
    ],
  );

  /// Dark gradient for overlays, modals
  static const LinearGradient overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x40572808), // overlay light
      Color(0x80572808), // overlay
    ],
  );


  // ═══════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════

  /// Get primary color with opacity
  static Color primaryWithOpacity(double opacity) {
    return primary.withOpacity(opacity);
  }

  /// Get contrasting text color for a given background
  static Color getContrastingText(Color background) {
    // Use white text on dark orange backgrounds, dark text on light
    final brightness = ThemeData.estimateBrightnessForColor(background);
    return brightness == Brightness.dark ? textWhite : textPrimary;
  }

  /// Check if a color is "light" (for determining text contrast)
  static bool isLightColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.light;
  }
}