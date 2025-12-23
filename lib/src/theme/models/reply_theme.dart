import 'package:flutter/material.dart';

/// Directional reply theme colors for outgoing or incoming messages
@immutable
class VDirectionalReplyTheme {
  /// Vertical bar color at the left of reply preview
  final Color barColor;

  /// Background color of the reply preview
  final Color backgroundColor;

  /// Text color in the reply preview
  final Color textColor;
  const VDirectionalReplyTheme({
    required this.barColor,
    required this.backgroundColor,
    required this.textColor,
  });
  VDirectionalReplyTheme copyWith({
    Color? barColor,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return VDirectionalReplyTheme(
      barColor: barColor ?? this.barColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VDirectionalReplyTheme &&
          runtimeType == other.runtimeType &&
          barColor == other.barColor &&
          backgroundColor == other.backgroundColor &&
          textColor == other.textColor;
  @override
  int get hashCode =>
      barColor.hashCode ^ backgroundColor.hashCode ^ textColor.hashCode;
}

/// Reply theme with outgoing/incoming colors
@immutable
class VBubbleReplyTheme {
  /// Reply colors for outgoing messages
  final VDirectionalReplyTheme outgoing;

  /// Reply colors for incoming messages
  final VDirectionalReplyTheme incoming;

  /// Width of the vertical reply bar
  final double barWidth;

  /// Padding for reply preview container
  final EdgeInsets padding;

  /// Border radius for reply preview
  final double borderRadius;

  /// Text style for reply sender name
  final TextStyle senderNameStyle;

  /// Text style for reply message content
  final TextStyle messageStyle;

  /// Maximum lines for reply message preview
  final int maxLines;
  const VBubbleReplyTheme({
    required this.outgoing,
    required this.incoming,
    this.barWidth = 3.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.borderRadius = 4.0,
    this.senderNameStyle =
        const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    this.messageStyle = const TextStyle(fontSize: 14),
    this.maxLines = 2,
  });

  /// Get reply bar color based on message direction
  Color barColor(bool isMeSender) =>
      isMeSender ? outgoing.barColor : incoming.barColor;

  /// Get reply background color based on message direction
  Color backgroundColor(bool isMeSender) =>
      isMeSender ? outgoing.backgroundColor : incoming.backgroundColor;

  /// Get reply text color based on message direction
  Color textColor(bool isMeSender) =>
      isMeSender ? outgoing.textColor : incoming.textColor;
  VBubbleReplyTheme copyWith({
    VDirectionalReplyTheme? outgoing,
    VDirectionalReplyTheme? incoming,
    double? barWidth,
    EdgeInsets? padding,
    double? borderRadius,
    TextStyle? senderNameStyle,
    TextStyle? messageStyle,
    int? maxLines,
  }) {
    return VBubbleReplyTheme(
      outgoing: outgoing ?? this.outgoing,
      incoming: incoming ?? this.incoming,
      barWidth: barWidth ?? this.barWidth,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      senderNameStyle: senderNameStyle ?? this.senderNameStyle,
      messageStyle: messageStyle ?? this.messageStyle,
      maxLines: maxLines ?? this.maxLines,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleReplyTheme telegramLight() => const VBubbleReplyTheme(
        outgoing: VDirectionalReplyTheme(
          barColor: Color(0xFF3FC33B),
          backgroundColor: Color(0x0F000000),
          textColor: Color(0xFF3FC33B),
        ),
        incoming: VDirectionalReplyTheme(
          barColor: Color(0xFF007EE5),
          backgroundColor: Color(0x0F000000),
          textColor: Color(0xFF007EE5),
        ),
      );
  static VBubbleReplyTheme telegramDark() => const VBubbleReplyTheme(
        outgoing: VDirectionalReplyTheme(
          barColor: Color(0xFF5EADEA),
          backgroundColor: Color(0x26FFFFFF),
          textColor: Colors.white,
        ),
        incoming: VDirectionalReplyTheme(
          barColor: Color(0xFF5EADEA),
          backgroundColor: Color(0x26FFFFFF),
          textColor: Colors.white,
        ),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleReplyTheme whatsappLight() => const VBubbleReplyTheme(
        outgoing: VDirectionalReplyTheme(
          barColor: Color(0xFF25D366),
          backgroundColor: Color(0x1A25D366),
          textColor: Color(0xFF06CF9C),
        ),
        incoming: VDirectionalReplyTheme(
          barColor: Color(0xFF25D366),
          backgroundColor: Color(0x0D000000),
          textColor: Color(0xFF06CF9C),
        ),
      );
  static VBubbleReplyTheme whatsappDark() => const VBubbleReplyTheme(
        outgoing: VDirectionalReplyTheme(
          barColor: Color(0xFF06CF9C),
          backgroundColor: Color(0x2606CF9C),
          textColor: Color(0xFF06CF9C),
        ),
        incoming: VDirectionalReplyTheme(
          barColor: Color(0xFF06CF9C),
          backgroundColor: Color(0x1AFFFFFF),
          textColor: Color(0xFF06CF9C),
        ),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleReplyTheme messengerLight() => const VBubbleReplyTheme(
        outgoing: VDirectionalReplyTheme(
          barColor: Color(0xFFB8D4FF),
          backgroundColor: Color(0x33FFFFFF),
          textColor: Color(0xFFB8D4FF),
        ),
        incoming: VDirectionalReplyTheme(
          barColor: Color(0xFF0084FF),
          backgroundColor: Color(0x0D000000),
          textColor: Color(0xFF0084FF),
        ),
      );
  static VBubbleReplyTheme messengerDark() => const VBubbleReplyTheme(
        outgoing: VDirectionalReplyTheme(
          barColor: Color(0xFFB8D4FF),
          backgroundColor: Color(0x33FFFFFF),
          textColor: Color(0xFFB8D4FF),
        ),
        incoming: VDirectionalReplyTheme(
          barColor: Color(0xFF4599FF),
          backgroundColor: Color(0x1AFFFFFF),
          textColor: Color(0xFF4599FF),
        ),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleReplyTheme imessageLight() => const VBubbleReplyTheme(
        outgoing: VDirectionalReplyTheme(
          barColor: Color(0xCCFFFFFF),
          backgroundColor: Color(0x33FFFFFF),
          textColor: Color(0xCCFFFFFF),
        ),
        incoming: VDirectionalReplyTheme(
          barColor: Color(0xFF007AFF),
          backgroundColor: Color(0x0D000000),
          textColor: Color(0xFF007AFF),
        ),
      );
  static VBubbleReplyTheme imessageDark() => const VBubbleReplyTheme(
        outgoing: VDirectionalReplyTheme(
          barColor: Color(0xB3FFFFFF),
          backgroundColor: Color(0x33FFFFFF),
          textColor: Color(0xB3FFFFFF),
        ),
        incoming: VDirectionalReplyTheme(
          barColor: Color(0xFF0A84FF),
          backgroundColor: Color(0x26FFFFFF),
          textColor: Color(0xFF0A84FF),
        ),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleReplyTheme &&
          runtimeType == other.runtimeType &&
          outgoing == other.outgoing &&
          incoming == other.incoming &&
          barWidth == other.barWidth &&
          padding == other.padding &&
          borderRadius == other.borderRadius &&
          senderNameStyle == other.senderNameStyle &&
          messageStyle == other.messageStyle &&
          maxLines == other.maxLines;
  @override
  int get hashCode =>
      outgoing.hashCode ^
      incoming.hashCode ^
      barWidth.hashCode ^
      padding.hashCode ^
      borderRadius.hashCode ^
      senderNameStyle.hashCode ^
      messageStyle.hashCode ^
      maxLines.hashCode;
}
