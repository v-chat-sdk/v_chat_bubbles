import 'package:flutter/material.dart';

/// Directional text colors for either outgoing or incoming messages
@immutable
class VDirectionalTextTheme {
  /// Primary text color
  final Color primaryColor;

  /// Secondary text color (timestamps, captions)
  final Color secondaryColor;

  /// Link text color
  final Color linkColor;
  const VDirectionalTextTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.linkColor,
  });
  VDirectionalTextTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? linkColor,
  }) {
    return VDirectionalTextTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      linkColor: linkColor ?? this.linkColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VDirectionalTextTheme &&
          runtimeType == other.runtimeType &&
          primaryColor == other.primaryColor &&
          secondaryColor == other.secondaryColor &&
          linkColor == other.linkColor;
  @override
  int get hashCode =>
      primaryColor.hashCode ^ secondaryColor.hashCode ^ linkColor.hashCode;
}

/// Text theme with typography styles and directional colors
@immutable
class VBubbleTextTheme {
  /// Text colors for outgoing messages
  final VDirectionalTextTheme outgoing;

  /// Text colors for incoming messages
  final VDirectionalTextTheme incoming;

  /// Main message text style
  final TextStyle messageTextStyle;

  /// Caption text style (for media captions)
  final TextStyle captionTextStyle;

  /// Link text style
  final TextStyle linkTextStyle;

  /// Sender name text style
  final TextStyle senderNameStyle;

  /// Time/timestamp text style
  final TextStyle timeTextStyle;

  /// Reply preview text style
  final TextStyle replyTextStyle;
  const VBubbleTextTheme({
    required this.outgoing,
    required this.incoming,
    required this.messageTextStyle,
    required this.captionTextStyle,
    required this.linkTextStyle,
    required this.senderNameStyle,
    required this.timeTextStyle,
    required this.replyTextStyle,
  });

  /// Get primary text color based on message direction
  Color textColor(bool isMeSender) =>
      isMeSender ? outgoing.primaryColor : incoming.primaryColor;

  /// Get secondary text color based on message direction
  Color secondaryTextColor(bool isMeSender) =>
      isMeSender ? outgoing.secondaryColor : incoming.secondaryColor;

  /// Get link color based on message direction
  Color linkColor(bool isMeSender) =>
      isMeSender ? outgoing.linkColor : incoming.linkColor;
  VBubbleTextTheme copyWith({
    VDirectionalTextTheme? outgoing,
    VDirectionalTextTheme? incoming,
    TextStyle? messageTextStyle,
    TextStyle? captionTextStyle,
    TextStyle? linkTextStyle,
    TextStyle? senderNameStyle,
    TextStyle? timeTextStyle,
    TextStyle? replyTextStyle,
  }) {
    return VBubbleTextTheme(
      outgoing: outgoing ?? this.outgoing,
      incoming: incoming ?? this.incoming,
      messageTextStyle: messageTextStyle ?? this.messageTextStyle,
      captionTextStyle: captionTextStyle ?? this.captionTextStyle,
      linkTextStyle: linkTextStyle ?? this.linkTextStyle,
      senderNameStyle: senderNameStyle ?? this.senderNameStyle,
      timeTextStyle: timeTextStyle ?? this.timeTextStyle,
      replyTextStyle: replyTextStyle ?? this.replyTextStyle,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleTextTheme telegramLight() => const VBubbleTextTheme(
        outgoing: VDirectionalTextTheme(
          primaryColor: Color(0xFF000000),
          secondaryColor: Color(0xCC008C09),
          linkColor: Color(0xFF004BAD),
        ),
        incoming: VDirectionalTextTheme(
          primaryColor: Color(0xFF000000),
          secondaryColor: Color(0x99525252),
          linkColor: Color(0xFF007EE5),
        ),
        messageTextStyle:
            TextStyle(fontSize: 17, height: 1.3125, letterSpacing: -0.41),
        timeTextStyle: TextStyle(fontSize: 12, letterSpacing: 0.07),
        senderNameStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        replyTextStyle: TextStyle(fontSize: 14),
        captionTextStyle: TextStyle(fontSize: 14),
        linkTextStyle: TextStyle(fontSize: 17, decoration: TextDecoration.none),
      );
  static VBubbleTextTheme telegramDark() => const VBubbleTextTheme(
        outgoing: VDirectionalTextTheme(
          primaryColor: Colors.white,
          secondaryColor: Color(0x99FFFFFF),
          linkColor: Color(0xFF5EADEA),
        ),
        incoming: VDirectionalTextTheme(
          primaryColor: Colors.white,
          secondaryColor: Color(0x99FFFFFF),
          linkColor: Color(0xFF5EADEA),
        ),
        messageTextStyle:
            TextStyle(fontSize: 17, height: 1.3125, letterSpacing: -0.41),
        timeTextStyle: TextStyle(fontSize: 12, letterSpacing: 0.07),
        senderNameStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        replyTextStyle: TextStyle(fontSize: 14),
        captionTextStyle: TextStyle(fontSize: 14),
        linkTextStyle: TextStyle(fontSize: 17, decoration: TextDecoration.none),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleTextTheme whatsappLight() => const VBubbleTextTheme(
        outgoing: VDirectionalTextTheme(
          primaryColor: Color(0xFF111B21),
          secondaryColor: Color(0xFF667781),
          linkColor: Color(0xFF027EB5),
        ),
        incoming: VDirectionalTextTheme(
          primaryColor: Color(0xFF111B21),
          secondaryColor: Color(0xFF667781),
          linkColor: Color(0xFF027EB5),
        ),
        messageTextStyle: TextStyle(fontSize: 16, height: 1.35),
        timeTextStyle: TextStyle(fontSize: 12),
        senderNameStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        replyTextStyle: TextStyle(fontSize: 14),
        captionTextStyle: TextStyle(fontSize: 14),
        linkTextStyle:
            TextStyle(fontSize: 15.5, decoration: TextDecoration.none),
      );
  static VBubbleTextTheme whatsappDark() => const VBubbleTextTheme(
        outgoing: VDirectionalTextTheme(
          primaryColor: Color(0xFFE9EDEF),
          secondaryColor: Color(0xFF8696A0),
          linkColor: Color(0xFF53BDEB),
        ),
        incoming: VDirectionalTextTheme(
          primaryColor: Color(0xFFE9EDEF),
          secondaryColor: Color(0xFF8696A0),
          linkColor: Color(0xFF53BDEB),
        ),
        messageTextStyle: TextStyle(fontSize: 16, height: 1.35),
        timeTextStyle: TextStyle(fontSize: 12),
        senderNameStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        replyTextStyle: TextStyle(fontSize: 14),
        captionTextStyle: TextStyle(fontSize: 14),
        linkTextStyle:
            TextStyle(fontSize: 15.5, decoration: TextDecoration.none),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleTextTheme messengerLight() => const VBubbleTextTheme(
        outgoing: VDirectionalTextTheme(
          primaryColor: Colors.white,
          secondaryColor: Color(0xFFB8D4FF),
          linkColor: Colors.white,
        ),
        incoming: VDirectionalTextTheme(
          primaryColor: Color(0xFF050505),
          secondaryColor: Color(0xFF65676B),
          linkColor: Color(0xFF0084FF),
        ),
        messageTextStyle: TextStyle(fontSize: 16, height: 1.33),
        timeTextStyle: TextStyle(fontSize: 12),
        senderNameStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        replyTextStyle: TextStyle(fontSize: 14),
        captionTextStyle: TextStyle(fontSize: 14),
        linkTextStyle: TextStyle(fontSize: 15, decoration: TextDecoration.none),
      );
  static VBubbleTextTheme messengerDark() => const VBubbleTextTheme(
        outgoing: VDirectionalTextTheme(
          primaryColor: Colors.white,
          secondaryColor: Color(0xFFB8D4FF),
          linkColor: Colors.white,
        ),
        incoming: VDirectionalTextTheme(
          primaryColor: Color(0xFFE4E6EB),
          secondaryColor: Color(0xFFB0B3B8),
          linkColor: Color(0xFF4599FF),
        ),
        messageTextStyle: TextStyle(fontSize: 16, height: 1.33),
        timeTextStyle: TextStyle(fontSize: 12),
        senderNameStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        replyTextStyle: TextStyle(fontSize: 14),
        captionTextStyle: TextStyle(fontSize: 14),
        linkTextStyle: TextStyle(fontSize: 15, decoration: TextDecoration.none),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleTextTheme imessageLight() => const VBubbleTextTheme(
        outgoing: VDirectionalTextTheme(
          primaryColor: Colors.white,
          secondaryColor: Color(0xCCFFFFFF),
          linkColor: Colors.white,
        ),
        incoming: VDirectionalTextTheme(
          primaryColor: Colors.black,
          secondaryColor: Color(0xFF8E8E93),
          linkColor: Color(0xFF007AFF),
        ),
        messageTextStyle:
            TextStyle(fontSize: 17, height: 1.29, letterSpacing: -0.43),
        timeTextStyle: TextStyle(fontSize: 12, letterSpacing: 0.07),
        senderNameStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        replyTextStyle: TextStyle(fontSize: 14),
        captionTextStyle: TextStyle(fontSize: 15),
        linkTextStyle:
            TextStyle(fontSize: 17, decoration: TextDecoration.underline),
      );
  static VBubbleTextTheme imessageDark() => const VBubbleTextTheme(
        outgoing: VDirectionalTextTheme(
          primaryColor: Colors.white,
          secondaryColor: Color(0xB3FFFFFF),
          linkColor: Colors.white,
        ),
        incoming: VDirectionalTextTheme(
          primaryColor: Colors.white,
          secondaryColor: Color(0xFF8E8E93),
          linkColor: Color(0xFF0A84FF),
        ),
        messageTextStyle:
            TextStyle(fontSize: 17, height: 1.29, letterSpacing: -0.43),
        timeTextStyle: TextStyle(fontSize: 12, letterSpacing: 0.07),
        senderNameStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        replyTextStyle: TextStyle(fontSize: 14),
        captionTextStyle: TextStyle(fontSize: 15),
        linkTextStyle:
            TextStyle(fontSize: 17, decoration: TextDecoration.underline),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleTextTheme &&
          runtimeType == other.runtimeType &&
          outgoing == other.outgoing &&
          incoming == other.incoming &&
          messageTextStyle == other.messageTextStyle &&
          captionTextStyle == other.captionTextStyle &&
          linkTextStyle == other.linkTextStyle &&
          senderNameStyle == other.senderNameStyle &&
          timeTextStyle == other.timeTextStyle &&
          replyTextStyle == other.replyTextStyle;
  @override
  int get hashCode =>
      outgoing.hashCode ^
      incoming.hashCode ^
      messageTextStyle.hashCode ^
      captionTextStyle.hashCode ^
      linkTextStyle.hashCode ^
      senderNameStyle.hashCode ^
      timeTextStyle.hashCode ^
      replyTextStyle.hashCode;
}
