import 'package:flutter/material.dart';

/// Directional bubble colors for either outgoing or incoming messages
@immutable
class VDirectionalBubbleColors {
  /// Main bubble background color
  final Color bubbleColor;
  /// Optional gradient for bubble background (overrides bubbleColor if set)
  final Gradient? bubbleGradient;
  const VDirectionalBubbleColors({
    required this.bubbleColor,
    this.bubbleGradient,
  });
  VDirectionalBubbleColors copyWith({
    Color? bubbleColor,
    Gradient? bubbleGradient,
  }) {
    return VDirectionalBubbleColors(
      bubbleColor: bubbleColor ?? this.bubbleColor,
      bubbleGradient: bubbleGradient ?? this.bubbleGradient,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VDirectionalBubbleColors &&
          runtimeType == other.runtimeType &&
          bubbleColor == other.bubbleColor &&
          bubbleGradient == other.bubbleGradient;
  @override
  int get hashCode => bubbleColor.hashCode ^ bubbleGradient.hashCode;
}

/// Core bubble theme with outgoing/incoming colors
@immutable
class VBubbleCoreTheme {
  /// Colors for outgoing (sent) messages
  final VDirectionalBubbleColors outgoing;
  /// Colors for incoming (received) messages
  final VDirectionalBubbleColors incoming;
  const VBubbleCoreTheme({
    required this.outgoing,
    required this.incoming,
  });
  /// Get bubble color based on message direction
  Color bubbleColor(bool isMeSender) =>
      isMeSender ? outgoing.bubbleColor : incoming.bubbleColor;
  /// Get bubble gradient based on message direction
  Gradient? bubbleGradient(bool isMeSender) =>
      isMeSender ? outgoing.bubbleGradient : incoming.bubbleGradient;
  VBubbleCoreTheme copyWith({
    VDirectionalBubbleColors? outgoing,
    VDirectionalBubbleColors? incoming,
  }) {
    return VBubbleCoreTheme(
      outgoing: outgoing ?? this.outgoing,
      incoming: incoming ?? this.incoming,
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleCoreTheme telegramLight() => const VBubbleCoreTheme(
        outgoing: VDirectionalBubbleColors(bubbleColor: Color(0xFFE1FFC7)),
        incoming: VDirectionalBubbleColors(bubbleColor: Colors.white),
      );
  static VBubbleCoreTheme telegramDark() => const VBubbleCoreTheme(
        outgoing: VDirectionalBubbleColors(bubbleColor: Color(0xFF2B5278)),
        incoming: VDirectionalBubbleColors(bubbleColor: Color(0xFF182533)),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleCoreTheme whatsappLight() => const VBubbleCoreTheme(
        outgoing: VDirectionalBubbleColors(bubbleColor: Color(0xFFD9FDD3)),
        incoming: VDirectionalBubbleColors(bubbleColor: Colors.white),
      );
  static VBubbleCoreTheme whatsappDark() => const VBubbleCoreTheme(
        outgoing: VDirectionalBubbleColors(bubbleColor: Color(0xFF005C4B)),
        incoming: VDirectionalBubbleColors(bubbleColor: Color(0xFF202C33)),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleCoreTheme messengerLight() => const VBubbleCoreTheme(
        outgoing: VDirectionalBubbleColors(bubbleColor: Color(0xFF0084FF)),
        incoming: VDirectionalBubbleColors(bubbleColor: Color(0xFFE4E6EB)),
      );
  static VBubbleCoreTheme messengerDark() => const VBubbleCoreTheme(
        outgoing: VDirectionalBubbleColors(bubbleColor: Color(0xFF0084FF)),
        incoming: VDirectionalBubbleColors(bubbleColor: Color(0xFF3A3B3C)),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleCoreTheme imessageLight() => const VBubbleCoreTheme(
        outgoing: VDirectionalBubbleColors(bubbleColor: Color(0xFF007AFF)),
        incoming: VDirectionalBubbleColors(bubbleColor: Color(0xFFE5E5EA)),
      );
  static VBubbleCoreTheme imessageDark() => const VBubbleCoreTheme(
        outgoing: VDirectionalBubbleColors(bubbleColor: Color(0xFF0A84FF)),
        incoming: VDirectionalBubbleColors(bubbleColor: Color(0xFF3A3A3C)),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleCoreTheme &&
          runtimeType == other.runtimeType &&
          outgoing == other.outgoing &&
          incoming == other.incoming;
  @override
  int get hashCode => outgoing.hashCode ^ incoming.hashCode;
}
