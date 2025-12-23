import 'package:flutter/material.dart';

/// Forward header theme
@immutable
class VBubbleForwardTheme {
  /// Color for forward header text and icon
  final Color headerColor;

  /// Background color for forward header area
  final Color backgroundColor;

  /// Text style for forward header
  final TextStyle textStyle;

  /// Icon size for forward icon
  final double iconSize;

  /// Padding for forward header area
  final EdgeInsets padding;

  /// Border radius for forward header container
  final double borderRadius;
  const VBubbleForwardTheme({
    required this.headerColor,
    required this.backgroundColor,
    this.textStyle = const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    this.iconSize = 14.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = 4.0,
  });
  VBubbleForwardTheme copyWith({
    Color? headerColor,
    Color? backgroundColor,
    TextStyle? textStyle,
    double? iconSize,
    EdgeInsets? padding,
    double? borderRadius,
  }) {
    return VBubbleForwardTheme(
      headerColor: headerColor ?? this.headerColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleForwardTheme telegramLight() => const VBubbleForwardTheme(
        headerColor: Color(0xFF3FC33B),
        backgroundColor: Color(0x0F000000),
      );
  static VBubbleForwardTheme telegramDark() => const VBubbleForwardTheme(
        headerColor: Color(0xFF5EADEA),
        backgroundColor: Color(0x26FFFFFF),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleForwardTheme whatsappLight() => const VBubbleForwardTheme(
        headerColor: Color(0xFF667781),
        backgroundColor: Color(0x0D000000),
      );
  static VBubbleForwardTheme whatsappDark() => const VBubbleForwardTheme(
        headerColor: Color(0xFF8696A0),
        backgroundColor: Color(0x1AFFFFFF),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleForwardTheme messengerLight() => const VBubbleForwardTheme(
        headerColor: Color(0xFF65676B),
        backgroundColor: Color(0x0D000000),
      );
  static VBubbleForwardTheme messengerDark() => const VBubbleForwardTheme(
        headerColor: Color(0xFFB0B3B8),
        backgroundColor: Color(0x1AFFFFFF),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleForwardTheme imessageLight() => const VBubbleForwardTheme(
        headerColor: Color(0xFF8E8E93),
        backgroundColor: Color(0x0D000000),
      );
  static VBubbleForwardTheme imessageDark() => const VBubbleForwardTheme(
        headerColor: Color(0xFF8E8E93),
        backgroundColor: Color(0x26FFFFFF),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleForwardTheme &&
          runtimeType == other.runtimeType &&
          headerColor == other.headerColor &&
          backgroundColor == other.backgroundColor &&
          textStyle == other.textStyle &&
          iconSize == other.iconSize &&
          padding == other.padding &&
          borderRadius == other.borderRadius;
  @override
  int get hashCode =>
      headerColor.hashCode ^
      backgroundColor.hashCode ^
      textStyle.hashCode ^
      iconSize.hashCode ^
      padding.hashCode ^
      borderRadius.hashCode;
}
