import 'package:flutter/material.dart';

/// Directional media theme colors for outgoing or incoming messages
@immutable
class VDirectionalMediaTheme {
  /// Base color for shimmer loading animation
  final Color shimmerBaseColor;

  /// Highlight color for shimmer loading animation
  final Color shimmerHighlightColor;
  const VDirectionalMediaTheme({
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
  });
  VDirectionalMediaTheme copyWith({
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
  }) {
    return VDirectionalMediaTheme(
      shimmerBaseColor: shimmerBaseColor ?? this.shimmerBaseColor,
      shimmerHighlightColor:
          shimmerHighlightColor ?? this.shimmerHighlightColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VDirectionalMediaTheme &&
          runtimeType == other.runtimeType &&
          shimmerBaseColor == other.shimmerBaseColor &&
          shimmerHighlightColor == other.shimmerHighlightColor;
  @override
  int get hashCode =>
      shimmerBaseColor.hashCode ^ shimmerHighlightColor.hashCode;
}

/// Media theme with shimmer and progress colors
@immutable
class VBubbleMediaTheme {
  /// Media colors for outgoing messages
  final VDirectionalMediaTheme outgoing;

  /// Media colors for incoming messages
  final VDirectionalMediaTheme incoming;

  /// Track color for progress indicators
  final Color progressTrackColor;

  /// Color for progress indicators
  final Color progressColor;
  const VBubbleMediaTheme({
    required this.outgoing,
    required this.incoming,
    required this.progressTrackColor,
    required this.progressColor,
  });

  /// Get shimmer base color based on message direction
  Color shimmerBaseColor(bool isMeSender) =>
      isMeSender ? outgoing.shimmerBaseColor : incoming.shimmerBaseColor;

  /// Get shimmer highlight color based on message direction
  Color shimmerHighlightColor(bool isMeSender) => isMeSender
      ? outgoing.shimmerHighlightColor
      : incoming.shimmerHighlightColor;

  /// Get shimmer colors as tuple based on message direction
  (Color base, Color highlight) shimmerColors(bool isMeSender) {
    return isMeSender
        ? (outgoing.shimmerBaseColor, outgoing.shimmerHighlightColor)
        : (incoming.shimmerBaseColor, incoming.shimmerHighlightColor);
  }

  VBubbleMediaTheme copyWith({
    VDirectionalMediaTheme? outgoing,
    VDirectionalMediaTheme? incoming,
    Color? progressTrackColor,
    Color? progressColor,
  }) {
    return VBubbleMediaTheme(
      outgoing: outgoing ?? this.outgoing,
      incoming: incoming ?? this.incoming,
      progressTrackColor: progressTrackColor ?? this.progressTrackColor,
      progressColor: progressColor ?? this.progressColor,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleMediaTheme telegramLight() => VBubbleMediaTheme(
        outgoing: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFFE1FFC7).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFFE1FFC7).withValues(alpha: 0.1),
        ),
        incoming: VDirectionalMediaTheme(
          shimmerBaseColor: Colors.white.withValues(alpha: 0.3),
          shimmerHighlightColor: Colors.white.withValues(alpha: 0.1),
        ),
        progressTrackColor: const Color(0xFFE5E5E5),
        progressColor: const Color(0xFF007EE5),
      );
  static VBubbleMediaTheme telegramDark() => VBubbleMediaTheme(
        outgoing: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFF2B5278).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFF2B5278).withValues(alpha: 0.1),
        ),
        incoming: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFF182533).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFF182533).withValues(alpha: 0.1),
        ),
        progressTrackColor: const Color(0xFF2A3A4A),
        progressColor: const Color(0xFF5EADEA),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleMediaTheme whatsappLight() => VBubbleMediaTheme(
        outgoing: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFFD9FDD3).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFFD9FDD3).withValues(alpha: 0.1),
        ),
        incoming: VDirectionalMediaTheme(
          shimmerBaseColor: Colors.white.withValues(alpha: 0.3),
          shimmerHighlightColor: Colors.white.withValues(alpha: 0.1),
        ),
        progressTrackColor: const Color(0xFFD9DADB),
        progressColor: const Color(0xFF25D366),
      );
  static VBubbleMediaTheme whatsappDark() => VBubbleMediaTheme(
        outgoing: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFF005C4B).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFF005C4B).withValues(alpha: 0.1),
        ),
        incoming: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFF202C33).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFF202C33).withValues(alpha: 0.1),
        ),
        progressTrackColor: const Color(0xFF374248),
        progressColor: const Color(0xFF25D366),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleMediaTheme messengerLight() => VBubbleMediaTheme(
        outgoing: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFF0084FF).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFF0084FF).withValues(alpha: 0.1),
        ),
        incoming: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFFE4E6EB).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFFE4E6EB).withValues(alpha: 0.1),
        ),
        progressTrackColor: const Color(0xFFE4E6EB),
        progressColor: const Color(0xFF0084FF),
      );
  static VBubbleMediaTheme messengerDark() => VBubbleMediaTheme(
        outgoing: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFF0084FF).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFF0084FF).withValues(alpha: 0.1),
        ),
        incoming: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFF3A3B3C).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFF3A3B3C).withValues(alpha: 0.1),
        ),
        progressTrackColor: const Color(0xFF4E4F50),
        progressColor: const Color(0xFF0084FF),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleMediaTheme imessageLight() => VBubbleMediaTheme(
        outgoing: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFF007AFF).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFF007AFF).withValues(alpha: 0.1),
        ),
        incoming: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFFE5E5EA).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFFE5E5EA).withValues(alpha: 0.1),
        ),
        progressTrackColor: const Color(0xFFE5E5EA),
        progressColor: const Color(0xFF007AFF),
      );
  static VBubbleMediaTheme imessageDark() => VBubbleMediaTheme(
        outgoing: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFF0A84FF).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFF0A84FF).withValues(alpha: 0.1),
        ),
        incoming: VDirectionalMediaTheme(
          shimmerBaseColor: const Color(0xFF3A3A3C).withValues(alpha: 0.3),
          shimmerHighlightColor: const Color(0xFF3A3A3C).withValues(alpha: 0.1),
        ),
        progressTrackColor: const Color(0xFF48484A),
        progressColor: const Color(0xFF0A84FF),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleMediaTheme &&
          runtimeType == other.runtimeType &&
          outgoing == other.outgoing &&
          incoming == other.incoming &&
          progressTrackColor == other.progressTrackColor &&
          progressColor == other.progressColor;
  @override
  int get hashCode =>
      outgoing.hashCode ^
      incoming.hashCode ^
      progressTrackColor.hashCode ^
      progressColor.hashCode;
}
