import 'package:flutter/material.dart';

/// Date chip theme (date separators in chat)
@immutable
class VBubbleDateChipTheme {
  /// Background color for date chip
  final Color backgroundColor;
  /// Text color for date
  final Color textColor;
  /// Text style for date
  final TextStyle textStyle;
  const VBubbleDateChipTheme({
    required this.backgroundColor,
    required this.textColor,
    required this.textStyle,
  });
  VBubbleDateChipTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
  }) {
    return VBubbleDateChipTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      textStyle: textStyle ?? this.textStyle,
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleDateChipTheme telegramLight() => const VBubbleDateChipTheme(
        backgroundColor: Color(0xCC3E3E3E),
        textColor: Colors.white,
        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      );
  static VBubbleDateChipTheme telegramDark() => const VBubbleDateChipTheme(
        backgroundColor: Color(0xFF1D2733),
        textColor: Color(0x99FFFFFF),
        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleDateChipTheme whatsappLight() => const VBubbleDateChipTheme(
        backgroundColor: Color(0xE6FFFFFF),
        textColor: Color(0xFF667781),
        textStyle: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
      );
  static VBubbleDateChipTheme whatsappDark() => const VBubbleDateChipTheme(
        backgroundColor: Color(0xE6182229),
        textColor: Color(0xFF8696A0),
        textStyle: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleDateChipTheme messengerLight() => const VBubbleDateChipTheme(
        backgroundColor: Colors.transparent,
        textColor: Color(0xFF65676B),
        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      );
  static VBubbleDateChipTheme messengerDark() => const VBubbleDateChipTheme(
        backgroundColor: Colors.transparent,
        textColor: Color(0xFFB0B3B8),
        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleDateChipTheme imessageLight() => const VBubbleDateChipTheme(
        backgroundColor: Colors.transparent,
        textColor: Color(0xFF8E8E93),
        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      );
  static VBubbleDateChipTheme imessageDark() => const VBubbleDateChipTheme(
        backgroundColor: Colors.transparent,
        textColor: Color(0xFF8E8E93),
        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleDateChipTheme &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          textColor == other.textColor &&
          textStyle == other.textStyle;
  @override
  int get hashCode =>
      backgroundColor.hashCode ^ textColor.hashCode ^ textStyle.hashCode;
}
