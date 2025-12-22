import 'package:flutter/material.dart';

/// Context menu theme
@immutable
class VBubbleMenuTheme {
  /// Background color for context menu
  final Color backgroundColor;
  /// Text color for menu items
  final Color textColor;
  /// Icon color for menu items
  final Color iconColor;
  /// Color for destructive actions (delete, etc.)
  final Color destructiveColor;
  /// Divider color between menu items
  final Color? dividerColor;
  /// Font size for menu item text
  final double fontSize;
  /// Icon size for menu items
  final double iconSize;
  /// Padding for each menu item
  final EdgeInsets itemPadding;
  /// Border radius for menu container
  final double borderRadius;
  /// Elevation/shadow for menu
  final double elevation;
  const VBubbleMenuTheme({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.destructiveColor,
    this.dividerColor,
    this.fontSize = 16.0,
    this.iconSize = 22.0,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 12.0,
    this.elevation = 8.0,
  });
  VBubbleMenuTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? destructiveColor,
    Color? dividerColor,
    double? fontSize,
    double? iconSize,
    EdgeInsets? itemPadding,
    double? borderRadius,
    double? elevation,
  }) {
    return VBubbleMenuTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      iconColor: iconColor ?? this.iconColor,
      destructiveColor: destructiveColor ?? this.destructiveColor,
      dividerColor: dividerColor ?? this.dividerColor,
      fontSize: fontSize ?? this.fontSize,
      iconSize: iconSize ?? this.iconSize,
      itemPadding: itemPadding ?? this.itemPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleMenuTheme telegramLight() => const VBubbleMenuTheme(
        backgroundColor: Colors.white,
        textColor: Colors.black,
        iconColor: Colors.black,
        destructiveColor: Color(0xFFFF3B30),
      );
  static VBubbleMenuTheme telegramDark() => const VBubbleMenuTheme(
        backgroundColor: Color(0xFF17212B),
        textColor: Colors.white,
        iconColor: Colors.white,
        destructiveColor: Color(0xFFFF6B6B),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleMenuTheme whatsappLight() => const VBubbleMenuTheme(
        backgroundColor: Colors.white,
        textColor: Color(0xFF111B21),
        iconColor: Color(0xFF111B21),
        destructiveColor: Color(0xFFEA0038),
      );
  static VBubbleMenuTheme whatsappDark() => const VBubbleMenuTheme(
        backgroundColor: Color(0xFF233138),
        textColor: Color(0xFFE9EDEF),
        iconColor: Color(0xFFE9EDEF),
        destructiveColor: Color(0xFFFF4C4C),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleMenuTheme messengerLight() => const VBubbleMenuTheme(
        backgroundColor: Colors.white,
        textColor: Color(0xFF050505),
        iconColor: Color(0xFF050505),
        destructiveColor: Color(0xFFFA383E),
      );
  static VBubbleMenuTheme messengerDark() => const VBubbleMenuTheme(
        backgroundColor: Color(0xFF242526),
        textColor: Color(0xFFE4E6EB),
        iconColor: Color(0xFFE4E6EB),
        destructiveColor: Color(0xFFFA383E),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleMenuTheme imessageLight() => const VBubbleMenuTheme(
        backgroundColor: Color(0xFFF2F2F7),
        textColor: Colors.black,
        iconColor: Colors.black,
        destructiveColor: Color(0xFFFF3B30),
      );
  static VBubbleMenuTheme imessageDark() => const VBubbleMenuTheme(
        backgroundColor: Color(0xFF2C2C2E),
        textColor: Colors.white,
        iconColor: Colors.white,
        destructiveColor: Color(0xFFFF453A),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleMenuTheme &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          textColor == other.textColor &&
          iconColor == other.iconColor &&
          destructiveColor == other.destructiveColor &&
          dividerColor == other.dividerColor &&
          fontSize == other.fontSize &&
          iconSize == other.iconSize &&
          itemPadding == other.itemPadding &&
          borderRadius == other.borderRadius &&
          elevation == other.elevation;
  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      textColor.hashCode ^
      iconColor.hashCode ^
      destructiveColor.hashCode ^
      dividerColor.hashCode ^
      fontSize.hashCode ^
      iconSize.hashCode ^
      itemPadding.hashCode ^
      borderRadius.hashCode ^
      elevation.hashCode;
}
