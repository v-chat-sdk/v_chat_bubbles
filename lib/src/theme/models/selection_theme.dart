import 'package:flutter/material.dart';

/// Selection mode theme
@immutable
class VBubbleSelectionTheme {
  /// Overlay color when bubble is selected
  final Color overlayColor;
  /// Checkmark icon color
  final Color checkmarkColor;
  /// Border color for selection indicator (optional)
  final Color? borderColor;
  /// Size of the checkmark icon
  final double checkmarkSize;
  /// Background size of the checkmark circle
  final double checkmarkBackgroundSize;
  /// Border radius for overlay (0 to match bubble shape)
  final double overlayBorderRadius;
  const VBubbleSelectionTheme({
    required this.overlayColor,
    required this.checkmarkColor,
    this.borderColor,
    this.checkmarkSize = 18.0,
    this.checkmarkBackgroundSize = 24.0,
    this.overlayBorderRadius = 0.0,
  });
  VBubbleSelectionTheme copyWith({
    Color? overlayColor,
    Color? checkmarkColor,
    Color? borderColor,
    double? checkmarkSize,
    double? checkmarkBackgroundSize,
    double? overlayBorderRadius,
  }) {
    return VBubbleSelectionTheme(
      overlayColor: overlayColor ?? this.overlayColor,
      checkmarkColor: checkmarkColor ?? this.checkmarkColor,
      borderColor: borderColor ?? this.borderColor,
      checkmarkSize: checkmarkSize ?? this.checkmarkSize,
      checkmarkBackgroundSize:
          checkmarkBackgroundSize ?? this.checkmarkBackgroundSize,
      overlayBorderRadius: overlayBorderRadius ?? this.overlayBorderRadius,
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleSelectionTheme telegramLight() => const VBubbleSelectionTheme(
        overlayColor: Color(0x33007EE5),
        checkmarkColor: Color(0xFF007EE5),
      );
  static VBubbleSelectionTheme telegramDark() => const VBubbleSelectionTheme(
        overlayColor: Color(0x33FFFFFF),
        checkmarkColor: Color(0xFF5EADEA),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleSelectionTheme whatsappLight() => const VBubbleSelectionTheme(
        overlayColor: Color(0x3325D366),
        checkmarkColor: Color(0xFF25D366),
      );
  static VBubbleSelectionTheme whatsappDark() => const VBubbleSelectionTheme(
        overlayColor: Color(0x3325D366),
        checkmarkColor: Color(0xFF25D366),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleSelectionTheme messengerLight() => const VBubbleSelectionTheme(
        overlayColor: Color(0x220084FF),
        checkmarkColor: Color(0xFF0084FF),
      );
  static VBubbleSelectionTheme messengerDark() => const VBubbleSelectionTheme(
        overlayColor: Color(0x220084FF),
        checkmarkColor: Color(0xFF0084FF),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleSelectionTheme imessageLight() => const VBubbleSelectionTheme(
        overlayColor: Color(0x22007AFF),
        checkmarkColor: Color(0xFF007AFF),
      );
  static VBubbleSelectionTheme imessageDark() => const VBubbleSelectionTheme(
        overlayColor: Color(0x220A84FF),
        checkmarkColor: Color(0xFF0A84FF),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleSelectionTheme &&
          runtimeType == other.runtimeType &&
          overlayColor == other.overlayColor &&
          checkmarkColor == other.checkmarkColor &&
          borderColor == other.borderColor &&
          checkmarkSize == other.checkmarkSize &&
          checkmarkBackgroundSize == other.checkmarkBackgroundSize &&
          overlayBorderRadius == other.overlayBorderRadius;
  @override
  int get hashCode =>
      overlayColor.hashCode ^
      checkmarkColor.hashCode ^
      borderColor.hashCode ^
      checkmarkSize.hashCode ^
      checkmarkBackgroundSize.hashCode ^
      overlayBorderRadius.hashCode;
}
