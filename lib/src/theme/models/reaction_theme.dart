import 'package:material_ui/material_ui.dart';

import '../../core/enums.dart';

/// Reaction theme for emoji reactions on messages
@immutable
class VBubbleReactionTheme {
  /// Background color for reaction pills
  final Color backgroundColor;

  /// Background color for selected/user's reaction
  final Color selectedBackgroundColor;

  /// Text color for reaction count
  final Color textColor;

  /// Border color for reaction pills (optional)
  final Color? borderColor;

  /// Font size for reaction count text
  final double countFontSize;

  /// Size for emoji display
  final double emojiSize;

  /// Padding inside reaction pill
  final EdgeInsets pillPadding;

  /// Border radius for reaction pill
  final double pillBorderRadius;

  /// Spacing between reaction pills
  final double pillSpacing;

  /// Height of reaction row
  final double rowHeight;
  const VBubbleReactionTheme({
    required this.backgroundColor,
    required this.selectedBackgroundColor,
    required this.textColor,
    this.borderColor,
    this.countFontSize = 12.0,
    this.emojiSize = 16.0,
    this.pillPadding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    this.pillBorderRadius = 12.0,
    this.pillSpacing = 4.0,
    this.rowHeight = 24.0,
  });
  VBubbleReactionTheme copyWith({
    Color? backgroundColor,
    Color? selectedBackgroundColor,
    Color? textColor,
    Color? borderColor,
    double? countFontSize,
    double? emojiSize,
    EdgeInsets? pillPadding,
    double? pillBorderRadius,
    double? pillSpacing,
    double? rowHeight,
  }) {
    return VBubbleReactionTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      countFontSize: countFontSize ?? this.countFontSize,
      emojiSize: emojiSize ?? this.emojiSize,
      pillPadding: pillPadding ?? this.pillPadding,
      pillBorderRadius: pillBorderRadius ?? this.pillBorderRadius,
      pillSpacing: pillSpacing ?? this.pillSpacing,
      rowHeight: rowHeight ?? this.rowHeight,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STYLE-SPECIFIC REACTION LISTS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Predefined reactions for each style
  static List<String> reactionsForStyle(VBubbleStyle style) {
    switch (style) {
      case VBubbleStyle.telegram:
        return ['👍', '👎', '❤️', '🔥', '🎉', '😂', '💩'];
      case VBubbleStyle.whatsapp:
        return ['👍', '❤️', '😂', '😮', '😢', '🙏'];
      case VBubbleStyle.messenger:
        return ['❤️', '😆', '😮', '😢', '😠', '👍', '👎'];
      case VBubbleStyle.imessage:
        return ['❤️', '👍', '👎', '😂', '‼️', '❓'];
      case VBubbleStyle.custom:
        return ['👍', '❤️', '😂', '😮', '😢', '🎉'];
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleReactionTheme telegramLight() => const VBubbleReactionTheme(
    backgroundColor: Colors.white,
    selectedBackgroundColor: Color(0xFFE1FFC7),
    textColor: Colors.black,
  );
  static VBubbleReactionTheme telegramDark() => const VBubbleReactionTheme(
    backgroundColor: Color(0xFF1D2733),
    selectedBackgroundColor: Color(0xFF2B5278),
    textColor: Colors.white,
  );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleReactionTheme whatsappLight() => const VBubbleReactionTheme(
    backgroundColor: Colors.white,
    selectedBackgroundColor: Color(0xFFD9FDD3),
    textColor: Color(0xFF111B21),
  );
  static VBubbleReactionTheme whatsappDark() => const VBubbleReactionTheme(
    backgroundColor: Color(0xFF202C33),
    selectedBackgroundColor: Color(0xFF005C4B),
    textColor: Color(0xFFE9EDEF),
  );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleReactionTheme messengerLight() => const VBubbleReactionTheme(
    backgroundColor: Colors.white,
    selectedBackgroundColor: Color(0xFFE4E6EB),
    textColor: Color(0xFF050505),
  );
  static VBubbleReactionTheme messengerDark() => const VBubbleReactionTheme(
    backgroundColor: Color(0xFF3A3B3C),
    selectedBackgroundColor: Color(0xFF4E4F50),
    textColor: Color(0xFFE4E6EB),
  );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleReactionTheme imessageLight() => const VBubbleReactionTheme(
    backgroundColor: Color(0xFFF2F2F7),
    selectedBackgroundColor: Color(0xFFE5E5EA),
    textColor: Colors.black,
  );
  static VBubbleReactionTheme imessageDark() => const VBubbleReactionTheme(
    backgroundColor: Color(0xFF2C2C2E),
    selectedBackgroundColor: Color(0xFF3A3A3C),
    textColor: Colors.white,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleReactionTheme &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          selectedBackgroundColor == other.selectedBackgroundColor &&
          textColor == other.textColor &&
          borderColor == other.borderColor &&
          countFontSize == other.countFontSize &&
          emojiSize == other.emojiSize &&
          pillPadding == other.pillPadding &&
          pillBorderRadius == other.pillBorderRadius &&
          pillSpacing == other.pillSpacing &&
          rowHeight == other.rowHeight;
  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      selectedBackgroundColor.hashCode ^
      textColor.hashCode ^
      borderColor.hashCode ^
      countFontSize.hashCode ^
      emojiSize.hashCode ^
      pillPadding.hashCode ^
      pillBorderRadius.hashCode ^
      pillSpacing.hashCode ^
      rowHeight.hashCode;
}
