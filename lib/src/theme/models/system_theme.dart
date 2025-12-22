import 'package:flutter/material.dart';

/// System message theme (date dividers, notifications, etc.)
@immutable
class VBubbleSystemTheme {
  /// Background color for system messages
  final Color backgroundColor;
  /// Text color for system messages
  final Color textColor;
  /// Text style for system messages
  final TextStyle textStyle;
  const VBubbleSystemTheme({
    required this.backgroundColor,
    required this.textColor,
    required this.textStyle,
  });
  VBubbleSystemTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
  }) {
    return VBubbleSystemTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      textStyle: textStyle ?? this.textStyle,
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleSystemTheme telegramLight() => const VBubbleSystemTheme(
        backgroundColor: Color(0xCC3E3E3E),
        textColor: Colors.white,
        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      );
  static VBubbleSystemTheme telegramDark() => const VBubbleSystemTheme(
        backgroundColor: Color(0xFF1D2733),
        textColor: Colors.white,
        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleSystemTheme whatsappLight() => const VBubbleSystemTheme(
        backgroundColor: Color(0xFFFFE9A3),
        textColor: Color(0xFF54656F),
        textStyle: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w400),
      );
  static VBubbleSystemTheme whatsappDark() => const VBubbleSystemTheme(
        backgroundColor: Color(0xE6182229),
        textColor: Color(0xFFD1D7DB),
        textStyle: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w400),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleSystemTheme messengerLight() => const VBubbleSystemTheme(
        backgroundColor: Colors.transparent,
        textColor: Color(0xFF65676B),
        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      );
  static VBubbleSystemTheme messengerDark() => const VBubbleSystemTheme(
        backgroundColor: Colors.transparent,
        textColor: Color(0xFFB0B3B8),
        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleSystemTheme imessageLight() => const VBubbleSystemTheme(
        backgroundColor: Colors.transparent,
        textColor: Color(0xFF8E8E93),
        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      );
  static VBubbleSystemTheme imessageDark() => const VBubbleSystemTheme(
        backgroundColor: Colors.transparent,
        textColor: Color(0xFF8E8E93),
        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleSystemTheme &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          textColor == other.textColor &&
          textStyle == other.textStyle;
  @override
  int get hashCode =>
      backgroundColor.hashCode ^ textColor.hashCode ^ textStyle.hashCode;
}
