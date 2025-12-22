import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'models/models.dart';

// Re-export all model classes for convenience
export 'models/models.dart';

/// Theme data for bubble styling using nested model architecture
///
/// The theme is organized into 12 specialized sub-themes:
/// - [core] - Bubble background colors and gradients
/// - [text] - Text colors and typography styles
/// - [status] - Message status icons and colors
/// - [reply] - Reply preview styling
/// - [forward] - Forward header styling
/// - [voice] - Voice message styling
/// - [media] - Media shimmer and progress colors
/// - [reactions] - Reaction pill styling
/// - [menu] - Context menu styling
/// - [selection] - Selection mode styling
/// - [systemMessages] - System message styling
/// - [dateChip] - Date chip styling
///
/// Example usage:
/// ```dart
/// final theme = VBubbleTheme.telegramLight();
///
/// // Access nested models
/// final bubbleColor = theme.core.bubbleColor(isMeSender);
/// final textColor = theme.text.textColor(isMeSender);
///
/// // Or use convenience helpers
/// final color = theme.bubbleColor(isMeSender);
/// ```
@immutable
class VBubbleTheme {
  /// Core bubble background colors and gradients
  final VBubbleCoreTheme core;

  /// Text colors and typography
  final VBubbleTextTheme text;

  /// Message status icons and colors
  final VBubbleStatusTheme status;

  /// Reply preview styling
  final VBubbleReplyTheme reply;

  /// Forward header styling
  final VBubbleForwardTheme forward;

  /// Voice message styling
  final VBubbleVoiceTheme voice;

  /// Media loading and progress styling
  final VBubbleMediaTheme media;

  /// Reaction pill styling
  final VBubbleReactionTheme reactions;

  /// Context menu styling
  final VBubbleMenuTheme menu;

  /// Selection mode styling
  final VBubbleSelectionTheme selection;

  /// System message styling
  final VBubbleSystemTheme systemMessages;

  /// Date chip styling
  final VBubbleDateChipTheme dateChip;
  const VBubbleTheme({
    required this.core,
    required this.text,
    required this.status,
    required this.reply,
    required this.forward,
    required this.voice,
    required this.media,
    required this.reactions,
    required this.menu,
    required this.selection,
    required this.systemMessages,
    required this.dateChip,
  });
  // ═══════════════════════════════════════════════════════════════════════════
  // CONVENIENCE HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Get bubble background color based on message direction
  Color bubbleColor(bool isMeSender) => core.bubbleColor(isMeSender);

  /// Get bubble gradient based on message direction (may be null)
  Gradient? bubbleGradient(bool isMeSender) => core.bubbleGradient(isMeSender);

  /// Get primary text color based on message direction
  Color textColor(bool isMeSender) => text.textColor(isMeSender);

  /// Get secondary text color based on message direction
  Color secondaryTextColor(bool isMeSender) =>
      text.secondaryTextColor(isMeSender);

  /// Get link color based on message direction
  Color linkColor(bool isMeSender) => text.linkColor(isMeSender);

  /// Get reply bar color based on message direction
  Color replyBarColor(bool isMeSender) => reply.barColor(isMeSender);

  /// Get reply background color based on message direction
  Color replyBackgroundColor(bool isMeSender) =>
      reply.backgroundColor(isMeSender);

  /// Get shimmer colors based on message direction
  (Color base, Color highlight) shimmerColors(bool isMeSender) =>
      media.shimmerColors(isMeSender);
  // ═══════════════════════════════════════════════════════════════════════════
  // BACKWARD COMPATIBILITY GETTERS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Outgoing bubble color
  Color get outgoingBubbleColor => core.outgoing.bubbleColor;

  /// Incoming bubble color
  Color get incomingBubbleColor => core.incoming.bubbleColor;

  /// Outgoing bubble gradient
  Gradient? get outgoingBubbleGradient => core.outgoing.bubbleGradient;

  /// Incoming bubble gradient
  Gradient? get incomingBubbleGradient => core.incoming.bubbleGradient;

  /// Outgoing text color
  Color get outgoingTextColor => text.outgoing.primaryColor;

  /// Incoming text color
  Color get incomingTextColor => text.incoming.primaryColor;

  /// Outgoing secondary text color
  Color get outgoingSecondaryTextColor => text.outgoing.secondaryColor;

  /// Incoming secondary text color
  Color get incomingSecondaryTextColor => text.incoming.secondaryColor;

  /// Outgoing link color
  Color get outgoingLinkColor => text.outgoing.linkColor;

  /// Incoming link color
  Color get incomingLinkColor => text.incoming.linkColor;

  /// Sent icon color
  Color get sentIconColor => status.sentColor;

  /// Delivered icon color
  Color get deliveredIconColor => status.deliveredColor;

  /// Read icon color
  Color get readIconColor => status.readColor;

  /// Pending icon color
  Color get pendingIconColor => status.pendingColor;

  /// Error color
  Color get errorColor => status.errorColor;

  /// Status icons configuration
  VStatusIconsConfig get statusIcons => status.icons;

  /// Outgoing reply bar color
  Color get outgoingReplyBarColor => reply.outgoing.barColor;

  /// Incoming reply bar color
  Color get incomingReplyBarColor => reply.incoming.barColor;

  /// Outgoing reply background color
  Color get outgoingReplyBackgroundColor => reply.outgoing.backgroundColor;

  /// Incoming reply background color
  Color get incomingReplyBackgroundColor => reply.incoming.backgroundColor;

  /// Outgoing reply text color
  Color get outgoingReplyTextColor => reply.outgoing.textColor;

  /// Incoming reply text color
  Color get incomingReplyTextColor => reply.incoming.textColor;

  /// Forward header color
  Color get forwardHeaderColor => forward.headerColor;

  /// Forward header background color
  Color get forwardHeaderBackgroundColor => forward.backgroundColor;

  /// Selected bubble overlay color
  Color get selectedBubbleOverlay => selection.overlayColor;

  /// Selection checkmark color
  Color get selectionCheckmarkColor => selection.checkmarkColor;

  /// System message background color
  Color get systemMessageBackground => systemMessages.backgroundColor;

  /// System message text color
  Color get systemMessageTextColor => systemMessages.textColor;

  /// Date chip background color
  Color get dateChipBackground => dateChip.backgroundColor;

  /// Date chip text color
  Color get dateChipTextColor => dateChip.textColor;

  /// Outgoing waveform color (unplayed)
  Color get outgoingWaveformColor => voice.outgoing.waveformUnplayedColor;

  /// Incoming waveform color (unplayed)
  Color get incomingWaveformColor => voice.incoming.waveformUnplayedColor;

  /// Outgoing waveform played color
  Color get outgoingWaveformPlayedColor => voice.outgoing.waveformPlayedColor;

  /// Incoming waveform played color
  Color get incomingWaveformPlayedColor => voice.incoming.waveformPlayedColor;

  /// Outgoing voice button color
  Color get outgoingVoiceButtonColor => voice.outgoing.buttonColor;

  /// Incoming voice button color
  Color get incomingVoiceButtonColor => voice.incoming.buttonColor;

  /// Outgoing voice button icon color
  Color get outgoingVoiceButtonIconColor => voice.outgoing.buttonIconColor;

  /// Incoming voice button icon color
  Color get incomingVoiceButtonIconColor => voice.incoming.buttonIconColor;

  /// Outgoing voice speed button color
  Color get outgoingVoiceSpeedColor => voice.outgoing.speedButtonColor;

  /// Incoming voice speed button color
  Color get incomingVoiceSpeedColor => voice.incoming.speedButtonColor;

  /// Outgoing voice speed text color
  Color get outgoingVoiceSpeedTextColor => voice.outgoing.speedButtonTextColor;

  /// Incoming voice speed text color
  Color get incomingVoiceSpeedTextColor => voice.incoming.speedButtonTextColor;

  /// Reaction background color
  Color get reactionBackground => reactions.backgroundColor;

  /// Reaction selected background color
  Color get reactionSelectedBackground => reactions.selectedBackgroundColor;

  /// Reaction text color
  Color get reactionTextColor => reactions.textColor;

  /// Menu background color
  Color get menuBackground => menu.backgroundColor;

  /// Menu text color
  Color get menuTextColor => menu.textColor;

  /// Menu destructive action color
  Color get menuDestructiveColor => menu.destructiveColor;

  /// Progress track color
  Color get progressTrackColor => media.progressTrackColor;

  /// Progress color
  Color get progressColor => media.progressColor;

  /// Message text style
  TextStyle get messageTextStyle => text.messageTextStyle;

  /// Time text style
  TextStyle get timeTextStyle => text.timeTextStyle;

  /// Sender name style
  TextStyle get senderNameStyle => text.senderNameStyle;

  /// Reply text style
  TextStyle get replyTextStyle => text.replyTextStyle;

  /// System message text style
  TextStyle get systemTextStyle => systemMessages.textStyle;

  /// Link text style
  TextStyle get linkTextStyle => text.linkTextStyle;

  /// Caption text style
  TextStyle get captionTextStyle => text.captionTextStyle;
  // ═══════════════════════════════════════════════════════════════════════════
  // STYLE FACTORY CONSTRUCTORS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Get theme for specific style and brightness
  factory VBubbleTheme.fromStyle(VBubbleStyle style,
      {Brightness brightness = Brightness.light}) {
    switch (style) {
      case VBubbleStyle.telegram:
        return brightness == Brightness.light
            ? VBubbleTheme.telegramLight()
            : VBubbleTheme.telegramDark();
      case VBubbleStyle.whatsapp:
        return brightness == Brightness.light
            ? VBubbleTheme.whatsappLight()
            : VBubbleTheme.whatsappDark();
      case VBubbleStyle.messenger:
        return brightness == Brightness.light
            ? VBubbleTheme.messengerLight()
            : VBubbleTheme.messengerDark();
      case VBubbleStyle.imessage:
        return brightness == Brightness.light
            ? VBubbleTheme.imessageLight()
            : VBubbleTheme.imessageDark();
      case VBubbleStyle.custom:
        return VBubbleTheme.telegramLight();
    }
  }

  /// Telegram light theme
  factory VBubbleTheme.telegramLight() => VBubbleTheme(
        core: VBubbleCoreTheme.telegramLight(),
        text: VBubbleTextTheme.telegramLight(),
        status: VBubbleStatusTheme.telegramLight(),
        reply: VBubbleReplyTheme.telegramLight(),
        forward: VBubbleForwardTheme.telegramLight(),
        voice: VBubbleVoiceTheme.telegramLight(),
        media: VBubbleMediaTheme.telegramLight(),
        reactions: VBubbleReactionTheme.telegramLight(),
        menu: VBubbleMenuTheme.telegramLight(),
        selection: VBubbleSelectionTheme.telegramLight(),
        systemMessages: VBubbleSystemTheme.telegramLight(),
        dateChip: VBubbleDateChipTheme.telegramLight(),
      );

  /// Telegram dark theme
  factory VBubbleTheme.telegramDark() => VBubbleTheme(
        core: VBubbleCoreTheme.telegramDark(),
        text: VBubbleTextTheme.telegramDark(),
        status: VBubbleStatusTheme.telegramDark(),
        reply: VBubbleReplyTheme.telegramDark(),
        forward: VBubbleForwardTheme.telegramDark(),
        voice: VBubbleVoiceTheme.telegramDark(),
        media: VBubbleMediaTheme.telegramDark(),
        reactions: VBubbleReactionTheme.telegramDark(),
        menu: VBubbleMenuTheme.telegramDark(),
        selection: VBubbleSelectionTheme.telegramDark(),
        systemMessages: VBubbleSystemTheme.telegramDark(),
        dateChip: VBubbleDateChipTheme.telegramDark(),
      );

  /// WhatsApp light theme
  factory VBubbleTheme.whatsappLight() => VBubbleTheme(
        core: VBubbleCoreTheme.whatsappLight(),
        text: VBubbleTextTheme.whatsappLight(),
        status: VBubbleStatusTheme.whatsappLight(),
        reply: VBubbleReplyTheme.whatsappLight(),
        forward: VBubbleForwardTheme.whatsappLight(),
        voice: VBubbleVoiceTheme.whatsappLight(),
        media: VBubbleMediaTheme.whatsappLight(),
        reactions: VBubbleReactionTheme.whatsappLight(),
        menu: VBubbleMenuTheme.whatsappLight(),
        selection: VBubbleSelectionTheme.whatsappLight(),
        systemMessages: VBubbleSystemTheme.whatsappLight(),
        dateChip: VBubbleDateChipTheme.whatsappLight(),
      );

  /// WhatsApp dark theme
  factory VBubbleTheme.whatsappDark() => VBubbleTheme(
        core: VBubbleCoreTheme.whatsappDark(),
        text: VBubbleTextTheme.whatsappDark(),
        status: VBubbleStatusTheme.whatsappDark(),
        reply: VBubbleReplyTheme.whatsappDark(),
        forward: VBubbleForwardTheme.whatsappDark(),
        voice: VBubbleVoiceTheme.whatsappDark(),
        media: VBubbleMediaTheme.whatsappDark(),
        reactions: VBubbleReactionTheme.whatsappDark(),
        menu: VBubbleMenuTheme.whatsappDark(),
        selection: VBubbleSelectionTheme.whatsappDark(),
        systemMessages: VBubbleSystemTheme.whatsappDark(),
        dateChip: VBubbleDateChipTheme.whatsappDark(),
      );

  /// Messenger light theme
  factory VBubbleTheme.messengerLight() => VBubbleTheme(
        core: VBubbleCoreTheme.messengerLight(),
        text: VBubbleTextTheme.messengerLight(),
        status: VBubbleStatusTheme.messengerLight(),
        reply: VBubbleReplyTheme.messengerLight(),
        forward: VBubbleForwardTheme.messengerLight(),
        voice: VBubbleVoiceTheme.messengerLight(),
        media: VBubbleMediaTheme.messengerLight(),
        reactions: VBubbleReactionTheme.messengerLight(),
        menu: VBubbleMenuTheme.messengerLight(),
        selection: VBubbleSelectionTheme.messengerLight(),
        systemMessages: VBubbleSystemTheme.messengerLight(),
        dateChip: VBubbleDateChipTheme.messengerLight(),
      );

  /// Messenger dark theme
  factory VBubbleTheme.messengerDark() => VBubbleTheme(
        core: VBubbleCoreTheme.messengerDark(),
        text: VBubbleTextTheme.messengerDark(),
        status: VBubbleStatusTheme.messengerDark(),
        reply: VBubbleReplyTheme.messengerDark(),
        forward: VBubbleForwardTheme.messengerDark(),
        voice: VBubbleVoiceTheme.messengerDark(),
        media: VBubbleMediaTheme.messengerDark(),
        reactions: VBubbleReactionTheme.messengerDark(),
        menu: VBubbleMenuTheme.messengerDark(),
        selection: VBubbleSelectionTheme.messengerDark(),
        systemMessages: VBubbleSystemTheme.messengerDark(),
        dateChip: VBubbleDateChipTheme.messengerDark(),
      );

  /// iMessage light theme
  factory VBubbleTheme.imessageLight() => VBubbleTheme(
        core: VBubbleCoreTheme.imessageLight(),
        text: VBubbleTextTheme.imessageLight(),
        status: VBubbleStatusTheme.imessageLight(),
        reply: VBubbleReplyTheme.imessageLight(),
        forward: VBubbleForwardTheme.imessageLight(),
        voice: VBubbleVoiceTheme.imessageLight(),
        media: VBubbleMediaTheme.imessageLight(),
        reactions: VBubbleReactionTheme.imessageLight(),
        menu: VBubbleMenuTheme.imessageLight(),
        selection: VBubbleSelectionTheme.imessageLight(),
        systemMessages: VBubbleSystemTheme.imessageLight(),
        dateChip: VBubbleDateChipTheme.imessageLight(),
      );

  /// iMessage dark theme
  factory VBubbleTheme.imessageDark() => VBubbleTheme(
        core: VBubbleCoreTheme.imessageDark(),
        text: VBubbleTextTheme.imessageDark(),
        status: VBubbleStatusTheme.imessageDark(),
        reply: VBubbleReplyTheme.imessageDark(),
        forward: VBubbleForwardTheme.imessageDark(),
        voice: VBubbleVoiceTheme.imessageDark(),
        media: VBubbleMediaTheme.imessageDark(),
        reactions: VBubbleReactionTheme.imessageDark(),
        menu: VBubbleMenuTheme.imessageDark(),
        selection: VBubbleSelectionTheme.imessageDark(),
        systemMessages: VBubbleSystemTheme.imessageDark(),
        dateChip: VBubbleDateChipTheme.imessageDark(),
      );

  /// Create a custom theme with essential colors, deriving other values
  factory VBubbleTheme.custom({
    required Color outgoingBubbleColor,
    required Color incomingBubbleColor,
    Color? outgoingTextColor,
    Color? incomingTextColor,
    Color? accentColor,
    Color? errorColor,
    VStatusIconsConfig? statusIcons,
    Brightness brightness = Brightness.light,
  }) {
    final isDark = brightness == Brightness.dark;
    final defaultTextColor = isDark ? Colors.white : Colors.black;
    final defaultSecondaryColor = isDark ? Colors.white70 : Colors.black54;
    final accent = accentColor ?? Colors.blue;
    final outText = outgoingTextColor ?? defaultTextColor;
    final inText = incomingTextColor ?? defaultTextColor;
    return VBubbleTheme(
      core: VBubbleCoreTheme(
        outgoing: VDirectionalBubbleColors(bubbleColor: outgoingBubbleColor),
        incoming: VDirectionalBubbleColors(bubbleColor: incomingBubbleColor),
      ),
      text: VBubbleTextTheme(
        outgoing: VDirectionalTextTheme(
          primaryColor: outText,
          secondaryColor: defaultSecondaryColor,
          linkColor: accent,
        ),
        incoming: VDirectionalTextTheme(
          primaryColor: inText,
          secondaryColor: defaultSecondaryColor,
          linkColor: accent,
        ),
        messageTextStyle: TextStyle(fontSize: 16, color: defaultTextColor),
        captionTextStyle: TextStyle(fontSize: 14, color: defaultTextColor),
        linkTextStyle: TextStyle(
            fontSize: 16, color: accent, decoration: TextDecoration.underline),
        senderNameStyle:
            TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: accent),
        timeTextStyle: TextStyle(fontSize: 11, color: defaultSecondaryColor),
        replyTextStyle: TextStyle(fontSize: 14, color: defaultSecondaryColor),
      ),
      status: VBubbleStatusTheme(
        icons: statusIcons ?? VStatusIconsConfig.standard,
        pendingColor: defaultSecondaryColor,
        sentColor: accent,
        deliveredColor: accent,
        readColor: accent,
        errorColor: errorColor ?? Colors.red,
      ),
      reply: VBubbleReplyTheme(
        outgoing: VDirectionalReplyTheme(
          barColor: accent,
          backgroundColor: outgoingBubbleColor.withValues(alpha: 0.5),
          textColor: accent,
        ),
        incoming: VDirectionalReplyTheme(
          barColor: accent,
          backgroundColor: incomingBubbleColor.withValues(alpha: 0.5),
          textColor: accent,
        ),
      ),
      forward: VBubbleForwardTheme(
        headerColor: accent,
        backgroundColor: accent.withValues(alpha: 0.1),
      ),
      voice: VBubbleVoiceTheme(
        outgoing: VDirectionalVoiceTheme(
          waveformPlayedColor: accent,
          waveformUnplayedColor: defaultSecondaryColor,
          buttonColor: accent,
          buttonIconColor: outgoingBubbleColor,
          speedButtonColor: accent.withValues(alpha: 0.2),
          speedButtonTextColor: accent,
          durationTextColor: defaultSecondaryColor,
          loadingColor: accent,
        ),
        incoming: VDirectionalVoiceTheme(
          waveformPlayedColor: accent,
          waveformUnplayedColor: defaultSecondaryColor,
          buttonColor: accent,
          buttonIconColor: Colors.white,
          speedButtonColor: accent.withValues(alpha: 0.2),
          speedButtonTextColor: accent,
          durationTextColor: defaultSecondaryColor,
          loadingColor: accent,
        ),
      ),
      media: VBubbleMediaTheme(
        outgoing: VDirectionalMediaTheme(
          shimmerBaseColor: outgoingBubbleColor.withValues(alpha: 0.3),
          shimmerHighlightColor: outgoingBubbleColor.withValues(alpha: 0.1),
        ),
        incoming: VDirectionalMediaTheme(
          shimmerBaseColor: incomingBubbleColor.withValues(alpha: 0.3),
          shimmerHighlightColor: incomingBubbleColor.withValues(alpha: 0.1),
        ),
        progressTrackColor: defaultSecondaryColor.withValues(alpha: 0.3),
        progressColor: accent,
      ),
      reactions: VBubbleReactionTheme(
        backgroundColor:
            isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE8E8E8),
        selectedBackgroundColor: accent.withValues(alpha: 0.2),
        textColor: defaultTextColor,
      ),
      menu: VBubbleMenuTheme(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        textColor: defaultTextColor,
        iconColor: defaultTextColor,
        destructiveColor: Colors.red,
      ),
      selection: VBubbleSelectionTheme(
        overlayColor: accent.withValues(alpha: 0.2),
        checkmarkColor: accent,
      ),
      systemMessages: VBubbleSystemTheme(
        backgroundColor:
            isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
        textColor: defaultSecondaryColor,
        textStyle: TextStyle(fontSize: 13, color: defaultSecondaryColor),
      ),
      dateChip: VBubbleDateChipTheme(
        backgroundColor:
            isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
        textColor: defaultSecondaryColor,
        textStyle: TextStyle(fontSize: 13, color: defaultSecondaryColor),
      ),
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Predefined reactions for each style
  static List<String> reactionsForStyle(VBubbleStyle style) =>
      VBubbleReactionTheme.reactionsForStyle(style);

  /// Creates a copy of this theme with the given fields replaced
  VBubbleTheme copyWith({
    VBubbleCoreTheme? core,
    VBubbleTextTheme? text,
    VBubbleStatusTheme? status,
    VBubbleReplyTheme? reply,
    VBubbleForwardTheme? forward,
    VBubbleVoiceTheme? voice,
    VBubbleMediaTheme? media,
    VBubbleReactionTheme? reactions,
    VBubbleMenuTheme? menu,
    VBubbleSelectionTheme? selection,
    VBubbleSystemTheme? systemMessages,
    VBubbleDateChipTheme? dateChip,
  }) {
    return VBubbleTheme(
      core: core ?? this.core,
      text: text ?? this.text,
      status: status ?? this.status,
      reply: reply ?? this.reply,
      forward: forward ?? this.forward,
      voice: voice ?? this.voice,
      media: media ?? this.media,
      reactions: reactions ?? this.reactions,
      menu: menu ?? this.menu,
      selection: selection ?? this.selection,
      systemMessages: systemMessages ?? this.systemMessages,
      dateChip: dateChip ?? this.dateChip,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleTheme &&
          runtimeType == other.runtimeType &&
          core == other.core &&
          text == other.text &&
          status == other.status &&
          reply == other.reply &&
          forward == other.forward &&
          voice == other.voice &&
          media == other.media &&
          reactions == other.reactions &&
          menu == other.menu &&
          selection == other.selection &&
          systemMessages == other.systemMessages &&
          dateChip == other.dateChip;
  @override
  int get hashCode =>
      core.hashCode ^
      text.hashCode ^
      status.hashCode ^
      reply.hashCode ^
      forward.hashCode ^
      voice.hashCode ^
      media.hashCode ^
      reactions.hashCode ^
      menu.hashCode ^
      selection.hashCode ^
      systemMessages.hashCode ^
      dateChip.hashCode;
}

/// Extension for shimmer loading colors (backward compatibility)
extension VBubbleThemeShimmer on VBubbleTheme {
  /// Get shimmer base color for loading placeholders
  Color shimmerBaseColor(bool isMeSender) => media.shimmerBaseColor(isMeSender);

  /// Get shimmer highlight color for loading placeholders
  Color shimmerHighlightColor(bool isMeSender) =>
      media.shimmerHighlightColor(isMeSender);
}

/// Extension providing convenient color getters based on message direction.
extension VBubbleThemeColorHelpers on VBubbleTheme {
  /// Returns voice button color based on message direction.
  Color voiceButtonColor(bool isMeSender) => voice.buttonColor(isMeSender);

  /// Returns voice button icon color based on message direction.
  Color voiceButtonIconColor(bool isMeSender) =>
      voice.buttonIconColor(isMeSender);

  /// Returns voice speed button color based on message direction.
  Color voiceSpeedColor(bool isMeSender) => voice.speedButtonColor(isMeSender);

  /// Returns voice speed text color based on message direction.
  Color voiceSpeedTextColor(bool isMeSender) =>
      voice.speedButtonTextColor(isMeSender);
}
