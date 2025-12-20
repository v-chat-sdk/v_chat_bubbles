import 'package:flutter/material.dart';
import '../core/enums.dart';

/// Configuration for message status icons
class VStatusIconsConfig {
  /// Icon for pending/sending status
  final IconData pendingIcon;

  /// Icon for sent status
  final IconData sentIcon;

  /// Icon for delivered status
  final IconData deliveredIcon;

  /// Icon for read status
  final IconData readIcon;

  /// Icon for error status
  final IconData errorIcon;

  /// Size of status icons
  final double size;
  const VStatusIconsConfig({
    this.pendingIcon = Icons.access_time,
    this.sentIcon = Icons.check,
    this.deliveredIcon = Icons.done_all,
    this.readIcon = Icons.done_all,
    this.errorIcon = Icons.error_outline,
    this.size = 14,
  });

  /// Default status icons (standard check marks)
  static const standard = VStatusIconsConfig();

  /// WhatsApp-style icons
  static const whatsapp = VStatusIconsConfig(
    pendingIcon: Icons.schedule,
    sentIcon: Icons.check,
    deliveredIcon: Icons.done_all,
    readIcon: Icons.done_all,
    errorIcon: Icons.error,
  );

  /// Minimal style with smaller icons
  static const minimal = VStatusIconsConfig(
    pendingIcon: Icons.schedule_outlined,
    sentIcon: Icons.check,
    deliveredIcon: Icons.done_all_outlined,
    readIcon: Icons.done_all,
    errorIcon: Icons.warning_amber_outlined,
    size: 12,
  );
  VStatusIconsConfig copyWith({
    IconData? pendingIcon,
    IconData? sentIcon,
    IconData? deliveredIcon,
    IconData? readIcon,
    IconData? errorIcon,
    double? size,
  }) {
    return VStatusIconsConfig(
      pendingIcon: pendingIcon ?? this.pendingIcon,
      sentIcon: sentIcon ?? this.sentIcon,
      deliveredIcon: deliveredIcon ?? this.deliveredIcon,
      readIcon: readIcon ?? this.readIcon,
      errorIcon: errorIcon ?? this.errorIcon,
      size: size ?? this.size,
    );
  }

  /// Get icon for a specific status
  IconData iconFor(VMessageStatus status) {
    switch (status) {
      case VMessageStatus.sending:
        return pendingIcon;
      case VMessageStatus.sent:
        return sentIcon;
      case VMessageStatus.delivered:
        return deliveredIcon;
      case VMessageStatus.read:
        return readIcon;
      case VMessageStatus.error:
        return errorIcon;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VStatusIconsConfig &&
          runtimeType == other.runtimeType &&
          pendingIcon == other.pendingIcon &&
          sentIcon == other.sentIcon &&
          deliveredIcon == other.deliveredIcon &&
          readIcon == other.readIcon &&
          errorIcon == other.errorIcon &&
          size == other.size;
  @override
  int get hashCode =>
      pendingIcon.hashCode ^
      sentIcon.hashCode ^
      deliveredIcon.hashCode ^
      readIcon.hashCode ^
      errorIcon.hashCode ^
      size.hashCode;
}

/// Theme configuration for voice message bubbles
///
/// Provides complete customization for voice message UI including:
/// - Waveform colors (played/unplayed)
/// - Play/pause button styling
/// - Speed control button styling
/// - Duration text styling
/// - Visualizer dimensions and behavior
///
/// Example usage:
/// ```dart
/// VVoiceMessageTheme(
///   outgoingWaveformPlayedColor: Colors.green,
///   outgoingWaveformUnplayedColor: Colors.green.withOpacity(0.3),
///   // ... other properties
/// )
/// ```
@immutable
class VVoiceMessageTheme {
  // ═══════════════════════════════════════════════════════════════════════════
  // WAVEFORM COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Played portion of waveform for outgoing messages
  final Color outgoingWaveformPlayedColor;

  /// Unplayed portion of waveform for outgoing messages
  final Color outgoingWaveformUnplayedColor;

  /// Played portion of waveform for incoming messages
  final Color incomingWaveformPlayedColor;

  /// Unplayed portion of waveform for incoming messages
  final Color incomingWaveformUnplayedColor;
  // ═══════════════════════════════════════════════════════════════════════════
  // PLAY/PAUSE BUTTON
  // ═══════════════════════════════════════════════════════════════════════════
  /// Background color for play/pause button (outgoing)
  final Color outgoingButtonColor;

  /// Icon color for play/pause button (outgoing)
  final Color outgoingButtonIconColor;

  /// Background color for play/pause button (incoming)
  final Color incomingButtonColor;

  /// Icon color for play/pause button (incoming)
  final Color incomingButtonIconColor;

  /// Size of the play/pause button
  final double buttonSize;

  /// Whether to use simple icon without circular background
  final bool useSimplePlayIcon;

  /// Size of simple icon (when useSimplePlayIcon is true)
  final double simpleIconSize;
  // ═══════════════════════════════════════════════════════════════════════════
  // SPEED CONTROL BUTTON
  // ═══════════════════════════════════════════════════════════════════════════
  /// Whether to show speed control button
  final bool showSpeedControl;

  /// Background color for speed button (outgoing)
  final Color outgoingSpeedButtonColor;

  /// Text color for speed button (outgoing)
  final Color outgoingSpeedButtonTextColor;

  /// Background color for speed button (incoming)
  final Color incomingSpeedButtonColor;

  /// Text color for speed button (incoming)
  final Color incomingSpeedButtonTextColor;

  /// Border radius for speed button
  final double speedButtonBorderRadius;

  /// Padding for speed button
  final EdgeInsets speedButtonPadding;
  // ═══════════════════════════════════════════════════════════════════════════
  // DURATION TEXT
  // ═══════════════════════════════════════════════════════════════════════════
  /// Text color for duration display (outgoing)
  final Color outgoingDurationTextColor;

  /// Text color for duration display (incoming)
  final Color incomingDurationTextColor;

  /// Text style for duration display
  final TextStyle durationTextStyle;
  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING INDICATOR
  // ═══════════════════════════════════════════════════════════════════════════
  /// Color for loading indicator (outgoing)
  final Color outgoingLoadingColor;

  /// Color for loading indicator (incoming)
  final Color incomingLoadingColor;
  // ═══════════════════════════════════════════════════════════════════════════
  // VISUALIZER DIMENSIONS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Whether to show voice visualizer
  final bool showVisualizer;

  /// Height of the visualizer
  final double visualizerHeight;

  /// Number of bars in the visualizer
  final int visualizerBarCount;

  /// Spacing between visualizer bars
  final double visualizerBarSpacing;

  /// Minimum height for visualizer bars
  final double visualizerMinBarHeight;

  /// Whether to enable bar animations during playback
  final bool enableBarAnimations;
  const VVoiceMessageTheme({
    // Waveform colors
    required this.outgoingWaveformPlayedColor,
    required this.outgoingWaveformUnplayedColor,
    required this.incomingWaveformPlayedColor,
    required this.incomingWaveformUnplayedColor,
    // Button
    required this.outgoingButtonColor,
    required this.outgoingButtonIconColor,
    required this.incomingButtonColor,
    required this.incomingButtonIconColor,
    this.buttonSize = 40.0,
    this.useSimplePlayIcon = false,
    this.simpleIconSize = 24.0,
    // Speed control
    this.showSpeedControl = true,
    required this.outgoingSpeedButtonColor,
    required this.outgoingSpeedButtonTextColor,
    required this.incomingSpeedButtonColor,
    required this.incomingSpeedButtonTextColor,
    this.speedButtonBorderRadius = 6.0,
    this.speedButtonPadding =
        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    // Duration text
    required this.outgoingDurationTextColor,
    required this.incomingDurationTextColor,
    this.durationTextStyle =
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
    // Loading
    required this.outgoingLoadingColor,
    required this.incomingLoadingColor,
    // Visualizer
    this.showVisualizer = true,
    this.visualizerHeight = 40.0,
    this.visualizerBarCount = 30,
    this.visualizerBarSpacing = 2.0,
    this.visualizerMinBarHeight = 4.0,
    this.enableBarAnimations = true,
  });
  // ═══════════════════════════════════════════════════════════════════════════
  // DIRECTION-BASED HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Get waveform played color based on message direction
  Color waveformPlayedColor(bool isMeSender) =>
      isMeSender ? outgoingWaveformPlayedColor : incomingWaveformPlayedColor;

  /// Get waveform unplayed color based on message direction
  Color waveformUnplayedColor(bool isMeSender) => isMeSender
      ? outgoingWaveformUnplayedColor
      : incomingWaveformUnplayedColor;

  /// Get button background color based on message direction
  Color buttonColor(bool isMeSender) =>
      isMeSender ? outgoingButtonColor : incomingButtonColor;

  /// Get button icon color based on message direction
  Color buttonIconColor(bool isMeSender) =>
      isMeSender ? outgoingButtonIconColor : incomingButtonIconColor;

  /// Get speed button background color based on message direction
  Color speedButtonColor(bool isMeSender) =>
      isMeSender ? outgoingSpeedButtonColor : incomingSpeedButtonColor;

  /// Get speed button text color based on message direction
  Color speedButtonTextColor(bool isMeSender) =>
      isMeSender ? outgoingSpeedButtonTextColor : incomingSpeedButtonTextColor;

  /// Get duration text color based on message direction
  Color durationTextColor(bool isMeSender) =>
      isMeSender ? outgoingDurationTextColor : incomingDurationTextColor;

  /// Get loading indicator color based on message direction
  Color loadingColor(bool isMeSender) =>
      isMeSender ? outgoingLoadingColor : incomingLoadingColor;
  // ═══════════════════════════════════════════════════════════════════════════
  // STYLE-SPECIFIC FACTORY CONSTRUCTORS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Telegram light voice theme
  factory VVoiceMessageTheme.telegramLight() => const VVoiceMessageTheme(
        outgoingWaveformPlayedColor: Color(0xFF4FAE4E),
        outgoingWaveformUnplayedColor: Color(0xFF93D987),
        incomingWaveformPlayedColor: Color(0xFF2481CC),
        incomingWaveformUnplayedColor: Color(0xFFD4D4D4),
        outgoingButtonColor: Color(0xFF4FAE4E),
        outgoingButtonIconColor: Colors.white,
        incomingButtonColor: Color(0xFF2481CC),
        incomingButtonIconColor: Colors.white,
        outgoingSpeedButtonColor: Color(0x334FAE4E),
        outgoingSpeedButtonTextColor: Color(0xFF4FAE4E),
        incomingSpeedButtonColor: Color(0x332481CC),
        incomingSpeedButtonTextColor: Color(0xFF2481CC),
        outgoingDurationTextColor: Color(0xFF4FAE4E),
        incomingDurationTextColor: Color(0xFF999999),
        outgoingLoadingColor: Color(0xFF4FAE4E),
        incomingLoadingColor: Color(0xFF2481CC),
        visualizerBarCount: 25,
        visualizerHeight: 40.0,
      );

  /// Telegram dark voice theme
  factory VVoiceMessageTheme.telegramDark() => const VVoiceMessageTheme(
        outgoingWaveformPlayedColor: Color(0xFF7EB3D1),
        outgoingWaveformUnplayedColor: Color(0xFF5A8AA5),
        incomingWaveformPlayedColor: Color(0xFF6AB3F3),
        incomingWaveformUnplayedColor: Color(0xFF3D4A57),
        outgoingButtonColor: Color(0xFF7EB3D1),
        outgoingButtonIconColor: Color(0xFF232E3C),
        incomingButtonColor: Color(0xFF6AB3F3),
        incomingButtonIconColor: Color(0xFF232E3C),
        outgoingSpeedButtonColor: Color(0x337EB3D1),
        outgoingSpeedButtonTextColor: Color(0xFF7EB3D1),
        incomingSpeedButtonColor: Color(0x336AB3F3),
        incomingSpeedButtonTextColor: Color(0xFF6AB3F3),
        outgoingDurationTextColor: Color(0xFF7EB3D1),
        incomingDurationTextColor: Color(0xFF7E8B99),
        outgoingLoadingColor: Color(0xFF7EB3D1),
        incomingLoadingColor: Color(0xFF6AB3F3),
        visualizerBarCount: 25,
        visualizerHeight: 40.0,
      );

  /// WhatsApp light voice theme
  factory VVoiceMessageTheme.whatsappLight() => const VVoiceMessageTheme(
        outgoingWaveformPlayedColor: Color(0xFF34B7F1),
        outgoingWaveformUnplayedColor: Color(0xFF9CE1A8),
        incomingWaveformPlayedColor: Color(0xFF34B7F1),
        incomingWaveformUnplayedColor: Color(0xFFD9DADB),
        outgoingButtonColor: Color(0xFF25D366),
        outgoingButtonIconColor: Colors.white,
        incomingButtonColor: Color(0xFF25D366),
        incomingButtonIconColor: Colors.white,
        outgoingSpeedButtonColor: Color(0x3325D366),
        outgoingSpeedButtonTextColor: Color(0xFF25D366),
        incomingSpeedButtonColor: Color(0x33667781),
        incomingSpeedButtonTextColor: Color(0xFF667781),
        outgoingDurationTextColor: Color(0xFF667781),
        incomingDurationTextColor: Color(0xFF667781),
        outgoingLoadingColor: Color(0xFF25D366),
        incomingLoadingColor: Color(0xFF25D366),
        visualizerBarCount: 30,
        visualizerHeight: 38.0,
      );

  /// WhatsApp dark voice theme
  factory VVoiceMessageTheme.whatsappDark() => const VVoiceMessageTheme(
        outgoingWaveformPlayedColor: Color(0xFF34B7F1),
        outgoingWaveformUnplayedColor: Color(0xFF3B756B),
        incomingWaveformPlayedColor: Color(0xFF34B7F1),
        incomingWaveformUnplayedColor: Color(0xFF374248),
        outgoingButtonColor: Color(0xFF25D366),
        outgoingButtonIconColor: Colors.white,
        incomingButtonColor: Color(0xFF25D366),
        incomingButtonIconColor: Colors.white,
        outgoingSpeedButtonColor: Color(0x3325D366),
        outgoingSpeedButtonTextColor: Color(0xFF25D366),
        incomingSpeedButtonColor: Color(0x338696A0),
        incomingSpeedButtonTextColor: Color(0xFF8696A0),
        outgoingDurationTextColor: Color(0xFF8696A0),
        incomingDurationTextColor: Color(0xFF8696A0),
        outgoingLoadingColor: Color(0xFF25D366),
        incomingLoadingColor: Color(0xFF25D366),
        visualizerBarCount: 30,
        visualizerHeight: 38.0,
      );

  /// Messenger light voice theme
  factory VVoiceMessageTheme.messengerLight() => const VVoiceMessageTheme(
        outgoingWaveformPlayedColor: Colors.white,
        outgoingWaveformUnplayedColor: Color(0xFFB8D4FF),
        incomingWaveformPlayedColor: Color(0xFF0084FF),
        incomingWaveformUnplayedColor: Color(0xFFBCC0C4),
        outgoingButtonColor: Colors.white,
        outgoingButtonIconColor: Color(0xFF0084FF),
        incomingButtonColor: Color(0xFF0084FF),
        incomingButtonIconColor: Colors.white,
        outgoingSpeedButtonColor: Color(0x33FFFFFF),
        outgoingSpeedButtonTextColor: Colors.white,
        incomingSpeedButtonColor: Color(0x330084FF),
        incomingSpeedButtonTextColor: Color(0xFF0084FF),
        outgoingDurationTextColor: Color(0xFFB8D4FF),
        incomingDurationTextColor: Color(0xFF65676B),
        outgoingLoadingColor: Colors.white,
        incomingLoadingColor: Color(0xFF0084FF),
        visualizerBarCount: 35,
        visualizerHeight: 36.0,
        useSimplePlayIcon: true,
      );

  /// Messenger dark voice theme
  factory VVoiceMessageTheme.messengerDark() => const VVoiceMessageTheme(
        outgoingWaveformPlayedColor: Colors.white,
        outgoingWaveformUnplayedColor: Color(0xFFB8D4FF),
        incomingWaveformPlayedColor: Color(0xFF4599FF),
        incomingWaveformUnplayedColor: Color(0xFF4E4F50),
        outgoingButtonColor: Colors.white,
        outgoingButtonIconColor: Color(0xFF0084FF),
        incomingButtonColor: Color(0xFF4599FF),
        incomingButtonIconColor: Color(0xFF242526),
        outgoingSpeedButtonColor: Color(0x33FFFFFF),
        outgoingSpeedButtonTextColor: Colors.white,
        incomingSpeedButtonColor: Color(0x334599FF),
        incomingSpeedButtonTextColor: Color(0xFF4599FF),
        outgoingDurationTextColor: Color(0xFFB8D4FF),
        incomingDurationTextColor: Color(0xFFB0B3B8),
        outgoingLoadingColor: Colors.white,
        incomingLoadingColor: Color(0xFF4599FF),
        visualizerBarCount: 35,
        visualizerHeight: 36.0,
        useSimplePlayIcon: true,
      );

  /// iMessage light voice theme
  factory VVoiceMessageTheme.imessageLight() => const VVoiceMessageTheme(
        outgoingWaveformPlayedColor: Colors.white,
        outgoingWaveformUnplayedColor: Color(0x99FFFFFF),
        incomingWaveformPlayedColor: Color(0xFF007AFF),
        incomingWaveformUnplayedColor: Color(0xFFC7C7CC),
        outgoingButtonColor: Colors.white,
        outgoingButtonIconColor: Color(0xFF007AFF),
        incomingButtonColor: Color(0xFF007AFF),
        incomingButtonIconColor: Colors.white,
        outgoingSpeedButtonColor: Color(0x33FFFFFF),
        outgoingSpeedButtonTextColor: Colors.white,
        incomingSpeedButtonColor: Color(0x33007AFF),
        incomingSpeedButtonTextColor: Color(0xFF007AFF),
        outgoingDurationTextColor: Color(0xCCFFFFFF),
        incomingDurationTextColor: Color(0xFF8E8E93),
        outgoingLoadingColor: Colors.white,
        incomingLoadingColor: Color(0xFF007AFF),
        visualizerBarCount: 20,
        visualizerHeight: 32.0,
        buttonSize: 36.0,
      );

  /// iMessage dark voice theme
  factory VVoiceMessageTheme.imessageDark() => const VVoiceMessageTheme(
        outgoingWaveformPlayedColor: Colors.white,
        outgoingWaveformUnplayedColor: Color(0x80FFFFFF),
        incomingWaveformPlayedColor: Color(0xFF0A84FF),
        incomingWaveformUnplayedColor: Color(0xFF48484A),
        outgoingButtonColor: Colors.white,
        outgoingButtonIconColor: Color(0xFF0A84FF),
        incomingButtonColor: Color(0xFF0A84FF),
        incomingButtonIconColor: Color(0xFF1C1C1E),
        outgoingSpeedButtonColor: Color(0x33FFFFFF),
        outgoingSpeedButtonTextColor: Colors.white,
        incomingSpeedButtonColor: Color(0x330A84FF),
        incomingSpeedButtonTextColor: Color(0xFF0A84FF),
        outgoingDurationTextColor: Color(0xB3FFFFFF),
        incomingDurationTextColor: Color(0xFF8E8E93),
        outgoingLoadingColor: Colors.white,
        incomingLoadingColor: Color(0xFF0A84FF),
        visualizerBarCount: 20,
        visualizerHeight: 32.0,
        buttonSize: 36.0,
      );

  /// Get voice theme for a specific bubble style
  static VVoiceMessageTheme fromStyle(VBubbleStyle style,
      {Brightness brightness = Brightness.light}) {
    switch (style) {
      case VBubbleStyle.telegram:
        return brightness == Brightness.light
            ? VVoiceMessageTheme.telegramLight()
            : VVoiceMessageTheme.telegramDark();
      case VBubbleStyle.whatsapp:
        return brightness == Brightness.light
            ? VVoiceMessageTheme.whatsappLight()
            : VVoiceMessageTheme.whatsappDark();
      case VBubbleStyle.messenger:
        return brightness == Brightness.light
            ? VVoiceMessageTheme.messengerLight()
            : VVoiceMessageTheme.messengerDark();
      case VBubbleStyle.imessage:
        return brightness == Brightness.light
            ? VVoiceMessageTheme.imessageLight()
            : VVoiceMessageTheme.imessageDark();
      case VBubbleStyle.custom:
        return VVoiceMessageTheme.telegramLight();
    }
  }

  /// Creates a copy of this theme with the given fields replaced
  VVoiceMessageTheme copyWith({
    Color? outgoingWaveformPlayedColor,
    Color? outgoingWaveformUnplayedColor,
    Color? incomingWaveformPlayedColor,
    Color? incomingWaveformUnplayedColor,
    Color? outgoingButtonColor,
    Color? outgoingButtonIconColor,
    Color? incomingButtonColor,
    Color? incomingButtonIconColor,
    double? buttonSize,
    bool? useSimplePlayIcon,
    double? simpleIconSize,
    bool? showSpeedControl,
    Color? outgoingSpeedButtonColor,
    Color? outgoingSpeedButtonTextColor,
    Color? incomingSpeedButtonColor,
    Color? incomingSpeedButtonTextColor,
    double? speedButtonBorderRadius,
    EdgeInsets? speedButtonPadding,
    Color? outgoingDurationTextColor,
    Color? incomingDurationTextColor,
    TextStyle? durationTextStyle,
    Color? outgoingLoadingColor,
    Color? incomingLoadingColor,
    bool? showVisualizer,
    double? visualizerHeight,
    int? visualizerBarCount,
    double? visualizerBarSpacing,
    double? visualizerMinBarHeight,
    bool? enableBarAnimations,
  }) {
    return VVoiceMessageTheme(
      outgoingWaveformPlayedColor:
          outgoingWaveformPlayedColor ?? this.outgoingWaveformPlayedColor,
      outgoingWaveformUnplayedColor:
          outgoingWaveformUnplayedColor ?? this.outgoingWaveformUnplayedColor,
      incomingWaveformPlayedColor:
          incomingWaveformPlayedColor ?? this.incomingWaveformPlayedColor,
      incomingWaveformUnplayedColor:
          incomingWaveformUnplayedColor ?? this.incomingWaveformUnplayedColor,
      outgoingButtonColor: outgoingButtonColor ?? this.outgoingButtonColor,
      outgoingButtonIconColor:
          outgoingButtonIconColor ?? this.outgoingButtonIconColor,
      incomingButtonColor: incomingButtonColor ?? this.incomingButtonColor,
      incomingButtonIconColor:
          incomingButtonIconColor ?? this.incomingButtonIconColor,
      buttonSize: buttonSize ?? this.buttonSize,
      useSimplePlayIcon: useSimplePlayIcon ?? this.useSimplePlayIcon,
      simpleIconSize: simpleIconSize ?? this.simpleIconSize,
      showSpeedControl: showSpeedControl ?? this.showSpeedControl,
      outgoingSpeedButtonColor:
          outgoingSpeedButtonColor ?? this.outgoingSpeedButtonColor,
      outgoingSpeedButtonTextColor:
          outgoingSpeedButtonTextColor ?? this.outgoingSpeedButtonTextColor,
      incomingSpeedButtonColor:
          incomingSpeedButtonColor ?? this.incomingSpeedButtonColor,
      incomingSpeedButtonTextColor:
          incomingSpeedButtonTextColor ?? this.incomingSpeedButtonTextColor,
      speedButtonBorderRadius:
          speedButtonBorderRadius ?? this.speedButtonBorderRadius,
      speedButtonPadding: speedButtonPadding ?? this.speedButtonPadding,
      outgoingDurationTextColor:
          outgoingDurationTextColor ?? this.outgoingDurationTextColor,
      incomingDurationTextColor:
          incomingDurationTextColor ?? this.incomingDurationTextColor,
      durationTextStyle: durationTextStyle ?? this.durationTextStyle,
      outgoingLoadingColor: outgoingLoadingColor ?? this.outgoingLoadingColor,
      incomingLoadingColor: incomingLoadingColor ?? this.incomingLoadingColor,
      showVisualizer: showVisualizer ?? this.showVisualizer,
      visualizerHeight: visualizerHeight ?? this.visualizerHeight,
      visualizerBarCount: visualizerBarCount ?? this.visualizerBarCount,
      visualizerBarSpacing: visualizerBarSpacing ?? this.visualizerBarSpacing,
      visualizerMinBarHeight:
          visualizerMinBarHeight ?? this.visualizerMinBarHeight,
      enableBarAnimations: enableBarAnimations ?? this.enableBarAnimations,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VVoiceMessageTheme &&
          runtimeType == other.runtimeType &&
          outgoingWaveformPlayedColor == other.outgoingWaveformPlayedColor &&
          outgoingWaveformUnplayedColor ==
              other.outgoingWaveformUnplayedColor &&
          incomingWaveformPlayedColor == other.incomingWaveformPlayedColor &&
          incomingWaveformUnplayedColor ==
              other.incomingWaveformUnplayedColor &&
          outgoingButtonColor == other.outgoingButtonColor &&
          outgoingButtonIconColor == other.outgoingButtonIconColor &&
          incomingButtonColor == other.incomingButtonColor &&
          incomingButtonIconColor == other.incomingButtonIconColor &&
          buttonSize == other.buttonSize &&
          useSimplePlayIcon == other.useSimplePlayIcon &&
          simpleIconSize == other.simpleIconSize &&
          showSpeedControl == other.showSpeedControl &&
          outgoingSpeedButtonColor == other.outgoingSpeedButtonColor &&
          outgoingSpeedButtonTextColor == other.outgoingSpeedButtonTextColor &&
          incomingSpeedButtonColor == other.incomingSpeedButtonColor &&
          incomingSpeedButtonTextColor == other.incomingSpeedButtonTextColor &&
          speedButtonBorderRadius == other.speedButtonBorderRadius &&
          speedButtonPadding == other.speedButtonPadding &&
          outgoingDurationTextColor == other.outgoingDurationTextColor &&
          incomingDurationTextColor == other.incomingDurationTextColor &&
          durationTextStyle == other.durationTextStyle &&
          outgoingLoadingColor == other.outgoingLoadingColor &&
          incomingLoadingColor == other.incomingLoadingColor &&
          showVisualizer == other.showVisualizer &&
          visualizerHeight == other.visualizerHeight &&
          visualizerBarCount == other.visualizerBarCount &&
          visualizerBarSpacing == other.visualizerBarSpacing &&
          visualizerMinBarHeight == other.visualizerMinBarHeight &&
          enableBarAnimations == other.enableBarAnimations;
  @override
  int get hashCode =>
      outgoingWaveformPlayedColor.hashCode ^
      outgoingWaveformUnplayedColor.hashCode ^
      incomingWaveformPlayedColor.hashCode ^
      incomingWaveformUnplayedColor.hashCode ^
      outgoingButtonColor.hashCode ^
      outgoingButtonIconColor.hashCode ^
      incomingButtonColor.hashCode ^
      incomingButtonIconColor.hashCode ^
      buttonSize.hashCode ^
      useSimplePlayIcon.hashCode ^
      showSpeedControl.hashCode ^
      outgoingSpeedButtonColor.hashCode ^
      outgoingSpeedButtonTextColor.hashCode ^
      visualizerBarCount.hashCode;
}

/// Theme data for bubble styling
@immutable
class VBubbleTheme {
  // Typography constants for each style
  static const _telegramTypography = (
    messageTextStyle:
        TextStyle(fontSize: 17, height: 1.3125, letterSpacing: -0.41),
    timeTextStyle: TextStyle(fontSize: 12, letterSpacing: 0.07),
    senderNameTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    replyTextStyle: TextStyle(fontSize: 14),
    forwardTextStyle: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
    captionTextStyle: TextStyle(fontSize: 14),
  );

  static const _whatsappTypography = (
    messageTextStyle: TextStyle(fontSize: 16, height: 1.35),
    timeTextStyle: TextStyle(fontSize: 12),
    senderNameTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    replyTextStyle: TextStyle(fontSize: 14),
    forwardTextStyle: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
    captionTextStyle: TextStyle(fontSize: 14),
  );

  static const _messengerTypography = (
    messageTextStyle: TextStyle(fontSize: 16, height: 1.33),
    timeTextStyle: TextStyle(fontSize: 12),
    senderNameTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    replyTextStyle: TextStyle(fontSize: 14),
    forwardTextStyle: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
    captionTextStyle: TextStyle(fontSize: 14),
  );

  static const _imessageTypography = (
    messageTextStyle:
        TextStyle(fontSize: 17, height: 1.29, letterSpacing: -0.43),
    timeTextStyle: TextStyle(fontSize: 12, letterSpacing: 0.07),
    senderNameTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    replyTextStyle: TextStyle(fontSize: 14),
    forwardTextStyle: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
    captionTextStyle: TextStyle(fontSize: 15),
  );

  // Bubble colors
  final Color outgoingBubbleColor;
  final Color incomingBubbleColor;
  // Bubble gradients (optional, Telegram style only)
  final Gradient? outgoingBubbleGradient;
  final Gradient? incomingBubbleGradient;
  final Color outgoingTextColor;
  final Color incomingTextColor;
  final Color outgoingSecondaryTextColor;
  final Color incomingSecondaryTextColor;
  // Status colors
  final Color sentIconColor;
  final Color deliveredIconColor;
  final Color readIconColor;
  final Color pendingIconColor;
  final Color errorColor;
  // Link colors
  final Color outgoingLinkColor;
  final Color incomingLinkColor;
  // Reply box
  final Color outgoingReplyBarColor;
  final Color incomingReplyBarColor;
  final Color outgoingReplyBackgroundColor;
  final Color incomingReplyBackgroundColor;
  final Color outgoingReplyTextColor;
  final Color incomingReplyTextColor;
  // Forward header
  final Color forwardHeaderColor;
  final Color forwardHeaderBackgroundColor;
  // Selection
  final Color selectedBubbleOverlay;
  final Color selectionCheckmarkColor;
  // System messages
  final Color systemMessageBackground;
  final Color systemMessageTextColor;
  // Date chip
  final Color dateChipBackground;
  final Color dateChipTextColor;
  // Voice message waveform
  final Color outgoingWaveformColor;
  final Color incomingWaveformColor;
  final Color outgoingWaveformPlayedColor;
  final Color incomingWaveformPlayedColor;
  // Voice button colors (play/pause circular button)
  final Color outgoingVoiceButtonColor;
  final Color incomingVoiceButtonColor;
  final Color outgoingVoiceButtonIconColor;
  final Color incomingVoiceButtonIconColor;
  // Voice speed control colors
  final Color outgoingVoiceSpeedColor;
  final Color incomingVoiceSpeedColor;
  final Color outgoingVoiceSpeedTextColor;
  final Color incomingVoiceSpeedTextColor;
  // Reactions
  final Color reactionBackground;
  final Color reactionSelectedBackground;
  final Color reactionTextColor;
  // Menu
  final Color menuBackground;
  final Color menuTextColor;
  final Color menuDestructiveColor;
  // Progress
  final Color progressTrackColor;
  final Color progressColor;
  // Typography
  final TextStyle messageTextStyle;
  final TextStyle timeTextStyle;
  final TextStyle senderNameStyle;
  final TextStyle replyTextStyle;
  final TextStyle systemTextStyle;
  final TextStyle linkTextStyle;
  final TextStyle captionTextStyle;
  // Status icons configuration
  final VStatusIconsConfig statusIcons;
  const VBubbleTheme({
    required this.outgoingBubbleColor,
    required this.incomingBubbleColor,
    this.outgoingBubbleGradient,
    this.incomingBubbleGradient,
    required this.outgoingTextColor,
    required this.incomingTextColor,
    required this.outgoingSecondaryTextColor,
    required this.incomingSecondaryTextColor,
    required this.sentIconColor,
    required this.deliveredIconColor,
    required this.readIconColor,
    required this.pendingIconColor,
    required this.errorColor,
    required this.outgoingLinkColor,
    required this.incomingLinkColor,
    required this.outgoingReplyBarColor,
    required this.incomingReplyBarColor,
    required this.outgoingReplyBackgroundColor,
    required this.incomingReplyBackgroundColor,
    required this.outgoingReplyTextColor,
    required this.incomingReplyTextColor,
    required this.forwardHeaderColor,
    required this.forwardHeaderBackgroundColor,
    required this.selectedBubbleOverlay,
    required this.selectionCheckmarkColor,
    required this.systemMessageBackground,
    required this.systemMessageTextColor,
    required this.dateChipBackground,
    required this.dateChipTextColor,
    required this.outgoingWaveformColor,
    required this.incomingWaveformColor,
    required this.outgoingWaveformPlayedColor,
    required this.incomingWaveformPlayedColor,
    required this.outgoingVoiceButtonColor,
    required this.incomingVoiceButtonColor,
    required this.outgoingVoiceButtonIconColor,
    required this.incomingVoiceButtonIconColor,
    required this.outgoingVoiceSpeedColor,
    required this.incomingVoiceSpeedColor,
    required this.outgoingVoiceSpeedTextColor,
    required this.incomingVoiceSpeedTextColor,
    required this.reactionBackground,
    required this.reactionSelectedBackground,
    required this.reactionTextColor,
    required this.menuBackground,
    required this.menuTextColor,
    required this.menuDestructiveColor,
    required this.progressTrackColor,
    required this.progressColor,
    required this.messageTextStyle,
    required this.timeTextStyle,
    required this.senderNameStyle,
    required this.replyTextStyle,
    required this.systemTextStyle,
    required this.linkTextStyle,
    required this.captionTextStyle,
    this.statusIcons = VStatusIconsConfig.standard,
  });
  // ═══════════════════════════════════════════════════════════════════════════
  // VOICE THEME ACCESSOR
  // ═══════════════════════════════════════════════════════════════════════════
  /// Voice message theme configuration
  ///
  /// Provides unified access to all voice message styling through [VVoiceMessageTheme].
  /// This is the recommended way to access voice styling for new code.
  ///
  /// Example:
  /// ```dart
  /// final buttonColor = theme.voice.buttonColor(isMeSender);
  /// final barCount = theme.voice.visualizerBarCount;
  /// ```
  ///
  /// For backward compatibility, individual voice properties like
  /// [outgoingVoiceButtonColor] continue to work.
  VVoiceMessageTheme get voice => VVoiceMessageTheme(
        outgoingWaveformPlayedColor: outgoingWaveformPlayedColor,
        outgoingWaveformUnplayedColor: outgoingWaveformColor,
        incomingWaveformPlayedColor: incomingWaveformPlayedColor,
        incomingWaveformUnplayedColor: incomingWaveformColor,
        outgoingButtonColor: outgoingVoiceButtonColor,
        outgoingButtonIconColor: outgoingVoiceButtonIconColor,
        incomingButtonColor: incomingVoiceButtonColor,
        incomingButtonIconColor: incomingVoiceButtonIconColor,
        outgoingSpeedButtonColor: outgoingVoiceSpeedColor,
        outgoingSpeedButtonTextColor: outgoingVoiceSpeedTextColor,
        incomingSpeedButtonColor: incomingVoiceSpeedColor,
        incomingSpeedButtonTextColor: incomingVoiceSpeedTextColor,
        outgoingDurationTextColor: outgoingSecondaryTextColor,
        incomingDurationTextColor: incomingSecondaryTextColor,
        outgoingLoadingColor: outgoingVoiceButtonColor,
        incomingLoadingColor: incomingVoiceButtonColor,
      );

  /// Get theme for specific style
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

  /// Create a custom theme with only the essential colors
  /// Uses sensible defaults for all other values based on provided colors
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
    return VBubbleTheme(
      outgoingBubbleColor: outgoingBubbleColor,
      incomingBubbleColor: incomingBubbleColor,
      outgoingTextColor: outgoingTextColor ?? defaultTextColor,
      incomingTextColor: incomingTextColor ?? defaultTextColor,
      outgoingSecondaryTextColor: defaultSecondaryColor,
      incomingSecondaryTextColor: defaultSecondaryColor,
      sentIconColor: accent,
      deliveredIconColor: accent,
      readIconColor: accent,
      pendingIconColor: defaultSecondaryColor,
      errorColor: errorColor ?? Colors.red,
      outgoingLinkColor: accent,
      incomingLinkColor: accent,
      outgoingReplyBarColor: accent,
      incomingReplyBarColor: accent,
      outgoingReplyBackgroundColor: outgoingBubbleColor.withValues(alpha: 0.5),
      incomingReplyBackgroundColor: incomingBubbleColor.withValues(alpha: 0.5),
      outgoingReplyTextColor: accent,
      incomingReplyTextColor: accent,
      forwardHeaderColor: accent,
      forwardHeaderBackgroundColor: accent.withValues(alpha: 0.1),
      selectedBubbleOverlay: accent.withValues(alpha: 0.2),
      selectionCheckmarkColor: accent,
      systemMessageBackground:
          isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
      systemMessageTextColor: defaultSecondaryColor,
      dateChipBackground:
          isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
      dateChipTextColor: defaultSecondaryColor,
      outgoingWaveformColor: defaultSecondaryColor,
      incomingWaveformColor: defaultSecondaryColor,
      outgoingWaveformPlayedColor: accent,
      incomingWaveformPlayedColor: accent,
      outgoingVoiceButtonColor: accent,
      incomingVoiceButtonColor: accent,
      outgoingVoiceButtonIconColor: outgoingBubbleColor,
      incomingVoiceButtonIconColor: Colors.white,
      outgoingVoiceSpeedColor: accent.withValues(alpha: 0.2),
      incomingVoiceSpeedColor: accent.withValues(alpha: 0.2),
      outgoingVoiceSpeedTextColor: accent,
      incomingVoiceSpeedTextColor: accent,
      reactionBackground:
          isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE8E8E8),
      reactionSelectedBackground: accent.withValues(alpha: 0.2),
      reactionTextColor: defaultTextColor,
      menuBackground: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      menuTextColor: defaultTextColor,
      menuDestructiveColor: Colors.red,
      progressTrackColor: defaultSecondaryColor.withValues(alpha: 0.3),
      progressColor: accent,
      messageTextStyle: TextStyle(fontSize: 16, color: defaultTextColor),
      timeTextStyle: TextStyle(fontSize: 11, color: defaultSecondaryColor),
      senderNameStyle:
          TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: accent),
      replyTextStyle: TextStyle(fontSize: 14, color: defaultSecondaryColor),
      systemTextStyle: TextStyle(fontSize: 13, color: defaultSecondaryColor),
      linkTextStyle: TextStyle(
          fontSize: 16, color: accent, decoration: TextDecoration.underline),
      captionTextStyle: TextStyle(fontSize: 14, color: defaultTextColor),
      statusIcons: statusIcons ?? VStatusIconsConfig.standard,
    );
  }

  /// Telegram light theme (iOS Day Classic)
  /// Colors from official Telegram iOS source: DefaultPresentationTheme.swift
  factory VBubbleTheme.telegramLight() {
    const typo = _telegramTypography;
    return VBubbleTheme(
      // Official Telegram iOS outgoing bubble: #E1FFC7
      outgoingBubbleColor: const Color(0xFFE1FFC7),
      incomingBubbleColor: Colors.white,
      // Telegram Day theme uses flat colors (no gradients)
      outgoingTextColor: const Color(0xFF000000),
      incomingTextColor: const Color(0xFF000000),
      // Official: outgoing secondary #008C09 (80% alpha), incoming #525252 (60% alpha)
      outgoingSecondaryTextColor: const Color(0xCC008C09),
      incomingSecondaryTextColor: const Color(0x99525252),
      // Official check mark color: #19C700
      sentIconColor: const Color(0xFF19C700),
      deliveredIconColor: const Color(0xFF19C700),
      readIconColor: const Color(0xFF19C700),
      pendingIconColor: const Color(0xFF999999),
      errorColor: const Color(0xFFFF3B30),
      // Official link color: #004BAD (outgoing), #007EE5 (incoming/accent)
      outgoingLinkColor: const Color(0xFF004BAD),
      incomingLinkColor: const Color(0xFF007EE5),
      // Official reply bar: outgoing #3FC33B, incoming #007EE5
      outgoingReplyBarColor: const Color(0xFF3FC33B),
      incomingReplyBarColor: const Color(0xFF007EE5),
      outgoingReplyBackgroundColor: const Color(0x0F000000),
      incomingReplyBackgroundColor: const Color(0x0F000000),
      outgoingReplyTextColor: const Color(0xFF3FC33B),
      incomingReplyTextColor: const Color(0xFF007EE5),
      forwardHeaderColor: const Color(0xFF3FC33B),
      forwardHeaderBackgroundColor: const Color(0x0F000000),
      selectedBubbleOverlay: const Color(0x33007EE5),
      selectionCheckmarkColor: const Color(0xFF007EE5),
      // Service messages use semi-transparent dark background
      systemMessageBackground: const Color(0xCC3E3E3E),
      systemMessageTextColor: Colors.white,
      dateChipBackground: const Color(0xCC3E3E3E),
      dateChipTextColor: Colors.white,
      // Official waveform: outgoing #D2F2B6, played #3FC33B
      outgoingWaveformColor: const Color(0xFFD2F2B6),
      incomingWaveformColor: const Color(0xFFE8ECF0),
      outgoingWaveformPlayedColor: const Color(0xFF3FC33B),
      incomingWaveformPlayedColor: const Color(0xFF007EE5),
      // Voice button colors
      outgoingVoiceButtonColor: const Color(0xFF3FC33B),
      incomingVoiceButtonColor: const Color(0xFF007EE5),
      outgoingVoiceButtonIconColor: Colors.white,
      incomingVoiceButtonIconColor: Colors.white,
      outgoingVoiceSpeedColor: const Color(0x333FC33B),
      incomingVoiceSpeedColor: const Color(0x33007EE5),
      outgoingVoiceSpeedTextColor: const Color(0xFF3FC33B),
      incomingVoiceSpeedTextColor: const Color(0xFF007EE5),
      reactionBackground: Colors.white,
      reactionSelectedBackground: const Color(0xFFE1FFC7),
      reactionTextColor: Colors.black,
      menuBackground: Colors.white,
      menuTextColor: Colors.black,
      menuDestructiveColor: const Color(0xFFFF3B30),
      progressTrackColor: const Color(0xFFE5E5E5),
      progressColor: const Color(0xFF007EE5),
      // Telegram iOS uses 17pt for messages (SF Pro)
      messageTextStyle: typo.messageTextStyle,
      timeTextStyle: typo.timeTextStyle,
      senderNameStyle: typo.senderNameTextStyle,
      replyTextStyle: typo.replyTextStyle,
      systemTextStyle:
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      linkTextStyle:
          const TextStyle(fontSize: 17, decoration: TextDecoration.none),
      captionTextStyle: typo.captionTextStyle,
    );
  }

  /// Telegram dark theme (iOS Dark Blue)
  /// Colors from Telegram Dark Blue theme: blue outgoing bubbles
  factory VBubbleTheme.telegramDark() {
    const typo = _telegramTypography;
    // Telegram Dark Blue theme accent color
    const accentBlue = Color(0xFF5EADEA);
    return VBubbleTheme(
      // Telegram Dark Blue: outgoing #2B5278 (blue), incoming #182533 (dark blue-gray)
      outgoingBubbleColor: const Color(0xFF2B5278),
      incomingBubbleColor: const Color(0xFF182533),
      outgoingTextColor: Colors.white,
      incomingTextColor: Colors.white,
      // Secondary text is white at 60% alpha
      outgoingSecondaryTextColor: const Color(0x99FFFFFF),
      incomingSecondaryTextColor: const Color(0x99FFFFFF),
      // Check marks use accent blue
      sentIconColor: accentBlue,
      deliveredIconColor: accentBlue,
      readIconColor: accentBlue,
      pendingIconColor: const Color(0x80FFFFFF),
      // Destructive color
      errorColor: const Color(0xFFFF6B6B),
      // Links use accent blue
      outgoingLinkColor: accentBlue,
      incomingLinkColor: accentBlue,
      // Reply box styling - accent blue bar
      outgoingReplyBarColor: accentBlue,
      incomingReplyBarColor: accentBlue,
      outgoingReplyBackgroundColor: const Color(0x26FFFFFF),
      incomingReplyBackgroundColor: const Color(0x26FFFFFF),
      outgoingReplyTextColor: Colors.white,
      incomingReplyTextColor: Colors.white,
      forwardHeaderColor: accentBlue,
      forwardHeaderBackgroundColor: const Color(0x26FFFFFF),
      selectedBubbleOverlay: const Color(0x33FFFFFF),
      selectionCheckmarkColor: accentBlue,
      // System messages on dark background
      systemMessageBackground: const Color(0xFF1D2733),
      systemMessageTextColor: Colors.white,
      dateChipBackground: const Color(0xFF1D2733),
      dateChipTextColor: const Color(0x99FFFFFF),
      // Voice waveform colors matching dark blue theme
      outgoingWaveformColor: const Color(0xFF3D6A8F),
      incomingWaveformColor: const Color(0xFF2A3A4A),
      outgoingWaveformPlayedColor: accentBlue,
      incomingWaveformPlayedColor: accentBlue,
      // Voice button colors
      outgoingVoiceButtonColor: accentBlue,
      incomingVoiceButtonColor: accentBlue,
      outgoingVoiceButtonIconColor: const Color(0xFF2B5278),
      incomingVoiceButtonIconColor: const Color(0xFF182533),
      outgoingVoiceSpeedColor: const Color(0x33FFFFFF),
      incomingVoiceSpeedColor: const Color(0x33FFFFFF),
      outgoingVoiceSpeedTextColor: Colors.white,
      incomingVoiceSpeedTextColor: Colors.white,
      reactionBackground: const Color(0xFF1D2733),
      reactionSelectedBackground: const Color(0xFF2B5278),
      reactionTextColor: Colors.white,
      // Menu background matching theme
      menuBackground: const Color(0xFF17212B),
      menuTextColor: Colors.white,
      menuDestructiveColor: const Color(0xFFFF6B6B),
      progressTrackColor: const Color(0xFF2A3A4A),
      progressColor: accentBlue,
      // Same typography as light
      messageTextStyle: typo.messageTextStyle,
      timeTextStyle: typo.timeTextStyle,
      senderNameStyle: typo.senderNameTextStyle,
      replyTextStyle: typo.replyTextStyle,
      systemTextStyle:
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      linkTextStyle:
          const TextStyle(fontSize: 17, decoration: TextDecoration.none),
      captionTextStyle: typo.captionTextStyle,
    );
  }

  /// WhatsApp light theme (iOS 2024)
  /// Colors extracted from WhatsApp iOS app
  factory VBubbleTheme.whatsappLight() {
    const typo = _whatsappTypography;
    return VBubbleTheme(
      // WhatsApp iOS outgoing: #D9FDD3 (light mint green)
      outgoingBubbleColor: const Color(0xFFD9FDD3),
      incomingBubbleColor: Colors.white,
      // WhatsApp uses very dark text #111B21
      outgoingTextColor: const Color(0xFF111B21),
      incomingTextColor: const Color(0xFF111B21),
      // Secondary text (time, etc)
      outgoingSecondaryTextColor: const Color(0xFF667781),
      incomingSecondaryTextColor: const Color(0xFF667781),
      // WhatsApp checkmarks: gray for sent/delivered, blue for read
      sentIconColor: const Color(0xFF667781),
      deliveredIconColor: const Color(0xFF667781),
      readIconColor: const Color(0xFF53BDEB), // WhatsApp blue ticks
      pendingIconColor: const Color(0xFF8696A0),
      errorColor: const Color(0xFFEA0038),
      // Links use teal blue
      outgoingLinkColor: const Color(0xFF027EB5),
      incomingLinkColor: const Color(0xFF027EB5),
      // Reply box styling - WhatsApp uses light tint background
      outgoingReplyBarColor: const Color(0xFF25D366),
      incomingReplyBarColor: const Color(0xFF25D366),
      outgoingReplyBackgroundColor: const Color(0x1A25D366),
      incomingReplyBackgroundColor: const Color(0x0D000000),
      outgoingReplyTextColor: const Color(0xFF06CF9C),
      incomingReplyTextColor: const Color(0xFF06CF9C),
      forwardHeaderColor: const Color(0xFF667781),
      forwardHeaderBackgroundColor: const Color(0x0D000000),
      selectedBubbleOverlay: const Color(0x3325D366),
      selectionCheckmarkColor: const Color(0xFF25D366),
      // System messages use yellow/cream background
      systemMessageBackground: const Color(0xFFFFE9A3),
      systemMessageTextColor: const Color(0xFF54656F),
      // Date chip with shadow
      dateChipBackground: const Color(0xE6FFFFFF),
      dateChipTextColor: const Color(0xFF667781),
      // Voice waveform
      outgoingWaveformColor: const Color(0xFF9CE1A8),
      incomingWaveformColor: const Color(0xFFD9DADB),
      outgoingWaveformPlayedColor: const Color(0xFF34B7F1),
      incomingWaveformPlayedColor: const Color(0xFF34B7F1),
      // Voice button colors
      outgoingVoiceButtonColor: const Color(0xFF25D366),
      incomingVoiceButtonColor: const Color(0xFF25D366),
      outgoingVoiceButtonIconColor: Colors.white,
      incomingVoiceButtonIconColor: Colors.white,
      outgoingVoiceSpeedColor: const Color(0x3325D366),
      incomingVoiceSpeedColor: const Color(0x33667781),
      outgoingVoiceSpeedTextColor: const Color(0xFF25D366),
      incomingVoiceSpeedTextColor: const Color(0xFF667781),
      reactionBackground: Colors.white,
      reactionSelectedBackground: const Color(0xFFD9FDD3),
      reactionTextColor: const Color(0xFF111B21),
      menuBackground: Colors.white,
      menuTextColor: const Color(0xFF111B21),
      menuDestructiveColor: const Color(0xFFEA0038),
      progressTrackColor: const Color(0xFFD9DADB),
      progressColor: const Color(0xFF25D366),
      // WhatsApp iOS uses ~15.5pt for message text
      messageTextStyle: typo.messageTextStyle,
      timeTextStyle: typo.timeTextStyle,
      senderNameStyle: typo.senderNameTextStyle,
      replyTextStyle: typo.replyTextStyle,
      systemTextStyle:
          const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w400),
      linkTextStyle:
          const TextStyle(fontSize: 15.5, decoration: TextDecoration.none),
      captionTextStyle: typo.captionTextStyle,
    );
  }

  /// WhatsApp dark theme (iOS 2024)
  /// Colors extracted from WhatsApp iOS dark mode
  factory VBubbleTheme.whatsappDark() {
    const typo = _whatsappTypography;
    return VBubbleTheme(
      // WhatsApp iOS dark outgoing: #005C4B (dark teal green)
      outgoingBubbleColor: const Color(0xFF005C4B),
      // Incoming bubble: #202C33 (dark blue-gray)
      incomingBubbleColor: const Color(0xFF202C33),
      // Light text for dark mode
      outgoingTextColor: const Color(0xFFE9EDEF),
      incomingTextColor: const Color(0xFFE9EDEF),
      // Secondary text slightly dimmer
      outgoingSecondaryTextColor: const Color(0xFF8696A0),
      incomingSecondaryTextColor: const Color(0xFF8696A0),
      // Same checkmark colors as light mode
      sentIconColor: const Color(0xFF8696A0),
      deliveredIconColor: const Color(0xFF8696A0),
      readIconColor: const Color(0xFF53BDEB),
      pendingIconColor: const Color(0xFF8696A0),
      errorColor: const Color(0xFFFF4C4C),
      // Links use light blue in dark mode
      outgoingLinkColor: const Color(0xFF53BDEB),
      incomingLinkColor: const Color(0xFF53BDEB),
      // Reply box styling
      outgoingReplyBarColor: const Color(0xFF06CF9C),
      incomingReplyBarColor: const Color(0xFF06CF9C),
      outgoingReplyBackgroundColor: const Color(0x2606CF9C),
      incomingReplyBackgroundColor: const Color(0x1AFFFFFF),
      outgoingReplyTextColor: const Color(0xFF06CF9C),
      incomingReplyTextColor: const Color(0xFF06CF9C),
      forwardHeaderColor: const Color(0xFF8696A0),
      forwardHeaderBackgroundColor: const Color(0x1AFFFFFF),
      selectedBubbleOverlay: const Color(0x3325D366),
      selectionCheckmarkColor: const Color(0xFF25D366),
      // System message dark
      systemMessageBackground: const Color(0xE6182229),
      systemMessageTextColor: const Color(0xFFD1D7DB),
      dateChipBackground: const Color(0xE6182229),
      dateChipTextColor: const Color(0xFF8696A0),
      // Voice waveform dark
      outgoingWaveformColor: const Color(0xFF3B756B),
      incomingWaveformColor: const Color(0xFF374248),
      outgoingWaveformPlayedColor: const Color(0xFF34B7F1),
      incomingWaveformPlayedColor: const Color(0xFF34B7F1),
      // Voice button colors
      outgoingVoiceButtonColor: const Color(0xFF25D366),
      incomingVoiceButtonColor: const Color(0xFF25D366),
      outgoingVoiceButtonIconColor: Colors.white,
      incomingVoiceButtonIconColor: Colors.white,
      outgoingVoiceSpeedColor: const Color(0x3325D366),
      incomingVoiceSpeedColor: const Color(0x338696A0),
      outgoingVoiceSpeedTextColor: const Color(0xFF25D366),
      incomingVoiceSpeedTextColor: const Color(0xFF8696A0),
      reactionBackground: const Color(0xFF202C33),
      reactionSelectedBackground: const Color(0xFF005C4B),
      reactionTextColor: const Color(0xFFE9EDEF),
      menuBackground: const Color(0xFF233138),
      menuTextColor: const Color(0xFFE9EDEF),
      menuDestructiveColor: const Color(0xFFFF4C4C),
      progressTrackColor: const Color(0xFF374248),
      progressColor: const Color(0xFF25D366),
      // Same typography as light
      messageTextStyle: typo.messageTextStyle,
      timeTextStyle: typo.timeTextStyle,
      senderNameStyle: typo.senderNameTextStyle,
      replyTextStyle: typo.replyTextStyle,
      systemTextStyle:
          const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w400),
      linkTextStyle:
          const TextStyle(fontSize: 15.5, decoration: TextDecoration.none),
      captionTextStyle: typo.captionTextStyle,
    );
  }

  /// Messenger light theme (iOS 2024)
  /// Colors extracted from Facebook Messenger iOS app
  factory VBubbleTheme.messengerLight() {
    const typo = _messengerTypography;
    return VBubbleTheme(
      // Messenger signature blue #0084FF
      outgoingBubbleColor: const Color(0xFF0084FF),
      // Light gray incoming bubble
      incomingBubbleColor: const Color(0xFFE4E6EB),
      outgoingTextColor: Colors.white,
      // Near black for incoming text
      incomingTextColor: const Color(0xFF050505),
      // Secondary text colors
      outgoingSecondaryTextColor: const Color(0xFFB8D4FF),
      incomingSecondaryTextColor: const Color(0xFF65676B),
      // Messenger uses avatar-based read receipts, but for icon fallback:
      sentIconColor: const Color(0xFFBCC0C4),
      deliveredIconColor: const Color(0xFFBCC0C4),
      readIconColor: const Color(0xFF0084FF),
      pendingIconColor: const Color(0xFFBCC0C4),
      errorColor: const Color(0xFFFA383E),
      // Links - white on blue, blue on gray
      outgoingLinkColor: Colors.white,
      incomingLinkColor: const Color(0xFF0084FF),
      // Reply box styling - Messenger uses rounded gray background
      outgoingReplyBarColor: const Color(0xFFB8D4FF),
      incomingReplyBarColor: const Color(0xFF0084FF),
      outgoingReplyBackgroundColor: const Color(0x33FFFFFF),
      incomingReplyBackgroundColor: const Color(0x0D000000),
      outgoingReplyTextColor: const Color(0xFFB8D4FF),
      incomingReplyTextColor: const Color(0xFF0084FF),
      forwardHeaderColor: const Color(0xFF65676B),
      forwardHeaderBackgroundColor: const Color(0x0D000000),
      selectedBubbleOverlay: const Color(0x220084FF),
      selectionCheckmarkColor: const Color(0xFF0084FF),
      // System messages subtle
      systemMessageBackground: Colors.transparent,
      systemMessageTextColor: const Color(0xFF65676B),
      // Messenger shows time inline, not in chips
      dateChipBackground: Colors.transparent,
      dateChipTextColor: const Color(0xFF65676B),
      // Voice waveform
      outgoingWaveformColor: const Color(0xFFB8D4FF),
      incomingWaveformColor: const Color(0xFFBCC0C4),
      outgoingWaveformPlayedColor: Colors.white,
      incomingWaveformPlayedColor: const Color(0xFF0084FF),
      // Voice button colors
      outgoingVoiceButtonColor: Colors.white,
      incomingVoiceButtonColor: const Color(0xFF0084FF),
      outgoingVoiceButtonIconColor: const Color(0xFF0084FF),
      incomingVoiceButtonIconColor: Colors.white,
      outgoingVoiceSpeedColor: const Color(0x33FFFFFF),
      incomingVoiceSpeedColor: const Color(0x330084FF),
      outgoingVoiceSpeedTextColor: Colors.white,
      incomingVoiceSpeedTextColor: const Color(0xFF0084FF),
      reactionBackground: Colors.white,
      reactionSelectedBackground: const Color(0xFFE4E6EB),
      reactionTextColor: const Color(0xFF050505),
      menuBackground: Colors.white,
      menuTextColor: const Color(0xFF050505),
      menuDestructiveColor: const Color(0xFFFA383E),
      progressTrackColor: const Color(0xFFE4E6EB),
      progressColor: const Color(0xFF0084FF),
      // Messenger uses ~15pt with rounded bubble aesthetic
      messageTextStyle: typo.messageTextStyle,
      timeTextStyle: typo.timeTextStyle,
      senderNameStyle: typo.senderNameTextStyle,
      replyTextStyle: typo.replyTextStyle,
      systemTextStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      linkTextStyle:
          const TextStyle(fontSize: 15, decoration: TextDecoration.none),
      captionTextStyle: typo.captionTextStyle,
    );
  }

  /// Messenger dark theme (iOS 2024)
  /// Colors extracted from Facebook Messenger iOS dark mode
  factory VBubbleTheme.messengerDark() {
    const typo = _messengerTypography;
    return VBubbleTheme(
      // Same blue in dark mode
      outgoingBubbleColor: const Color(0xFF0084FF),
      // Dark gray incoming bubble
      incomingBubbleColor: const Color(0xFF3A3B3C),
      outgoingTextColor: Colors.white,
      // Light gray text on dark bubble
      incomingTextColor: const Color(0xFFE4E6EB),
      outgoingSecondaryTextColor: const Color(0xFFB8D4FF),
      incomingSecondaryTextColor: const Color(0xFFB0B3B8),
      sentIconColor: const Color(0xFF65676B),
      deliveredIconColor: const Color(0xFF65676B),
      readIconColor: const Color(0xFF0084FF),
      pendingIconColor: const Color(0xFF65676B),
      errorColor: const Color(0xFFFA383E),
      outgoingLinkColor: Colors.white,
      incomingLinkColor: const Color(0xFF4599FF),
      // Reply box styling
      outgoingReplyBarColor: const Color(0xFFB8D4FF),
      incomingReplyBarColor: const Color(0xFF4599FF),
      outgoingReplyBackgroundColor: const Color(0x33FFFFFF),
      incomingReplyBackgroundColor: const Color(0x1AFFFFFF),
      outgoingReplyTextColor: const Color(0xFFB8D4FF),
      incomingReplyTextColor: const Color(0xFF4599FF),
      forwardHeaderColor: const Color(0xFFB0B3B8),
      forwardHeaderBackgroundColor: const Color(0x1AFFFFFF),
      selectedBubbleOverlay: const Color(0x220084FF),
      selectionCheckmarkColor: const Color(0xFF0084FF),
      // System messages
      systemMessageBackground: Colors.transparent,
      systemMessageTextColor: const Color(0xFFB0B3B8),
      dateChipBackground: Colors.transparent,
      dateChipTextColor: const Color(0xFFB0B3B8),
      // Voice waveform
      outgoingWaveformColor: const Color(0xFFB8D4FF),
      incomingWaveformColor: const Color(0xFF4E4F50),
      outgoingWaveformPlayedColor: Colors.white,
      incomingWaveformPlayedColor: const Color(0xFF4599FF),
      // Voice button colors
      outgoingVoiceButtonColor: Colors.white,
      incomingVoiceButtonColor: const Color(0xFF4599FF),
      outgoingVoiceButtonIconColor: const Color(0xFF0084FF),
      incomingVoiceButtonIconColor: const Color(0xFF242526),
      outgoingVoiceSpeedColor: const Color(0x33FFFFFF),
      incomingVoiceSpeedColor: const Color(0x334599FF),
      outgoingVoiceSpeedTextColor: Colors.white,
      incomingVoiceSpeedTextColor: const Color(0xFF4599FF),
      reactionBackground: const Color(0xFF3A3B3C),
      reactionSelectedBackground: const Color(0xFF4E4F50),
      reactionTextColor: const Color(0xFFE4E6EB),
      menuBackground: const Color(0xFF242526),
      menuTextColor: const Color(0xFFE4E6EB),
      menuDestructiveColor: const Color(0xFFFA383E),
      progressTrackColor: const Color(0xFF4E4F50),
      progressColor: const Color(0xFF0084FF),
      // Same typography as light
      messageTextStyle: typo.messageTextStyle,
      timeTextStyle: typo.timeTextStyle,
      senderNameStyle: typo.senderNameTextStyle,
      replyTextStyle: typo.replyTextStyle,
      systemTextStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      linkTextStyle:
          const TextStyle(fontSize: 15, decoration: TextDecoration.none),
      captionTextStyle: typo.captionTextStyle,
    );
  }

  /// iMessage light theme (iOS 17/18)
  /// Colors from Apple Human Interface Guidelines
  factory VBubbleTheme.imessageLight() {
    const typo = _imessageTypography;
    return VBubbleTheme(
      // iOS System Blue #007AFF
      outgoingBubbleColor: const Color(0xFF007AFF),
      // iOS System Gray 5 #E5E5EA for incoming
      incomingBubbleColor: const Color(0xFFE5E5EA),
      outgoingTextColor: Colors.white,
      incomingTextColor: Colors.black,
      // Time/secondary - lighter on blue, gray on incoming
      outgoingSecondaryTextColor: const Color(0xCCFFFFFF), // 80% white
      incomingSecondaryTextColor: const Color(0xFF8E8E93), // iOS systemGray
      // iMessage shows "Delivered"/"Read" text, not icons typically
      sentIconColor: const Color(0xFF8E8E93),
      deliveredIconColor: const Color(0xFF8E8E93),
      readIconColor: const Color(0xFF8E8E93),
      pendingIconColor: const Color(0xFF8E8E93),
      errorColor: const Color(0xFFFF3B30), // iOS systemRed
      // Links
      outgoingLinkColor: Colors.white,
      incomingLinkColor: const Color(0xFF007AFF),
      // Reply box styling - iMessage uses subtle background
      outgoingReplyBarColor: const Color(0xCCFFFFFF),
      incomingReplyBarColor: const Color(0xFF007AFF),
      outgoingReplyBackgroundColor: const Color(0x33FFFFFF),
      incomingReplyBackgroundColor: const Color(0x0D000000),
      outgoingReplyTextColor: const Color(0xCCFFFFFF),
      incomingReplyTextColor: const Color(0xFF007AFF),
      forwardHeaderColor: const Color(0xFF8E8E93),
      forwardHeaderBackgroundColor: const Color(0x0D000000),
      selectedBubbleOverlay: const Color(0x22007AFF),
      selectionCheckmarkColor: const Color(0xFF007AFF),
      // System messages (date dividers, etc)
      systemMessageBackground: Colors.transparent,
      systemMessageTextColor: const Color(0xFF8E8E93),
      // Date chips are minimal in iMessage
      dateChipBackground: Colors.transparent,
      dateChipTextColor: const Color(0xFF8E8E93),
      // Audio message waveform
      outgoingWaveformColor: const Color(0x99FFFFFF),
      incomingWaveformColor: const Color(0xFFC7C7CC), // iOS systemGray3
      outgoingWaveformPlayedColor: Colors.white,
      incomingWaveformPlayedColor: const Color(0xFF007AFF),
      // Voice button colors
      outgoingVoiceButtonColor: Colors.white,
      incomingVoiceButtonColor: const Color(0xFF007AFF),
      outgoingVoiceButtonIconColor: const Color(0xFF007AFF),
      incomingVoiceButtonIconColor: Colors.white,
      outgoingVoiceSpeedColor: const Color(0x33FFFFFF),
      incomingVoiceSpeedColor: const Color(0x33007AFF),
      outgoingVoiceSpeedTextColor: Colors.white,
      incomingVoiceSpeedTextColor: const Color(0xFF007AFF),
      // Tapback reactions
      reactionBackground:
          const Color(0xFFF2F2F7), // iOS secondarySystemBackground
      reactionSelectedBackground: const Color(0xFFE5E5EA),
      reactionTextColor: Colors.black,
      // Context menu
      menuBackground: const Color(0xFFF2F2F7),
      menuTextColor: Colors.black,
      menuDestructiveColor: const Color(0xFFFF3B30),
      progressTrackColor: const Color(0xFFE5E5EA),
      progressColor: const Color(0xFF007AFF),
      // iOS uses 17pt SF Pro for messages
      messageTextStyle: typo.messageTextStyle,
      timeTextStyle: typo.timeTextStyle,
      senderNameStyle: typo.senderNameTextStyle,
      replyTextStyle: typo.replyTextStyle,
      systemTextStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      linkTextStyle:
          const TextStyle(fontSize: 17, decoration: TextDecoration.underline),
      captionTextStyle: typo.captionTextStyle,
    );
  }

  /// iMessage dark theme (iOS 17/18)
  /// Colors from Apple Human Interface Guidelines (Dark Mode)
  factory VBubbleTheme.imessageDark() {
    const typo = _imessageTypography;
    return VBubbleTheme(
      // iOS System Blue Dark #0A84FF
      outgoingBubbleColor: const Color(0xFF0A84FF),
      // iOS Tertiary System Fill #3A3A3C
      incomingBubbleColor: const Color(0xFF3A3A3C),
      outgoingTextColor: Colors.white,
      incomingTextColor: Colors.white,
      // Time/secondary
      outgoingSecondaryTextColor: const Color(0xB3FFFFFF), // 70% white
      incomingSecondaryTextColor:
          const Color(0xFF8E8E93), // iOS systemGray (same in dark)
      sentIconColor: const Color(0xFF8E8E93),
      deliveredIconColor: const Color(0xFF8E8E93),
      readIconColor: const Color(0xFF8E8E93),
      pendingIconColor: const Color(0xFF8E8E93),
      errorColor: const Color(0xFFFF453A), // iOS systemRed dark
      // Links
      outgoingLinkColor: Colors.white,
      incomingLinkColor: const Color(0xFF0A84FF),
      // Reply box styling
      outgoingReplyBarColor: const Color(0xB3FFFFFF),
      incomingReplyBarColor: const Color(0xFF0A84FF),
      outgoingReplyBackgroundColor: const Color(0x33FFFFFF),
      incomingReplyBackgroundColor: const Color(0x26FFFFFF),
      outgoingReplyTextColor: const Color(0xB3FFFFFF),
      incomingReplyTextColor: const Color(0xFF0A84FF),
      forwardHeaderColor: const Color(0xFF8E8E93),
      forwardHeaderBackgroundColor: const Color(0x26FFFFFF),
      selectedBubbleOverlay: const Color(0x220A84FF),
      selectionCheckmarkColor: const Color(0xFF0A84FF),
      // System messages
      systemMessageBackground: Colors.transparent,
      systemMessageTextColor: const Color(0xFF8E8E93),
      dateChipBackground: Colors.transparent,
      dateChipTextColor: const Color(0xFF8E8E93),
      // Audio waveform
      outgoingWaveformColor: const Color(0x80FFFFFF),
      incomingWaveformColor: const Color(0xFF48484A), // iOS systemGray3 dark
      outgoingWaveformPlayedColor: Colors.white,
      incomingWaveformPlayedColor: const Color(0xFF0A84FF),
      // Voice button colors
      outgoingVoiceButtonColor: Colors.white,
      incomingVoiceButtonColor: const Color(0xFF0A84FF),
      outgoingVoiceButtonIconColor: const Color(0xFF0A84FF),
      incomingVoiceButtonIconColor: const Color(0xFF1C1C1E),
      outgoingVoiceSpeedColor: const Color(0x33FFFFFF),
      incomingVoiceSpeedColor: const Color(0x330A84FF),
      outgoingVoiceSpeedTextColor: Colors.white,
      incomingVoiceSpeedTextColor: const Color(0xFF0A84FF),
      // Tapback reactions
      reactionBackground:
          const Color(0xFF2C2C2E), // iOS tertiarySystemBackground dark
      reactionSelectedBackground: const Color(0xFF3A3A3C),
      reactionTextColor: Colors.white,
      // Context menu
      menuBackground: const Color(0xFF2C2C2E),
      menuTextColor: Colors.white,
      menuDestructiveColor: const Color(0xFFFF453A),
      progressTrackColor: const Color(0xFF48484A),
      progressColor: const Color(0xFF0A84FF),
      // Same typography as light
      messageTextStyle: typo.messageTextStyle,
      timeTextStyle: typo.timeTextStyle,
      senderNameStyle: typo.senderNameTextStyle,
      replyTextStyle: typo.replyTextStyle,
      systemTextStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      linkTextStyle:
          const TextStyle(fontSize: 17, decoration: TextDecoration.underline),
      captionTextStyle: typo.captionTextStyle,
    );
  }

  /// Creates a copy of this theme with the given fields replaced
  VBubbleTheme copyWith({
    Color? outgoingBubbleColor,
    Color? incomingBubbleColor,
    Gradient? outgoingBubbleGradient,
    Gradient? incomingBubbleGradient,
    Color? outgoingTextColor,
    Color? incomingTextColor,
    Color? outgoingSecondaryTextColor,
    Color? incomingSecondaryTextColor,
    Color? sentIconColor,
    Color? deliveredIconColor,
    Color? readIconColor,
    Color? pendingIconColor,
    Color? errorColor,
    Color? outgoingLinkColor,
    Color? incomingLinkColor,
    Color? outgoingReplyBarColor,
    Color? incomingReplyBarColor,
    Color? outgoingReplyBackgroundColor,
    Color? incomingReplyBackgroundColor,
    Color? outgoingReplyTextColor,
    Color? incomingReplyTextColor,
    Color? forwardHeaderColor,
    Color? forwardHeaderBackgroundColor,
    Color? selectedBubbleOverlay,
    Color? selectionCheckmarkColor,
    Color? systemMessageBackground,
    Color? systemMessageTextColor,
    Color? dateChipBackground,
    Color? dateChipTextColor,
    Color? outgoingWaveformColor,
    Color? incomingWaveformColor,
    Color? outgoingWaveformPlayedColor,
    Color? incomingWaveformPlayedColor,
    Color? outgoingVoiceButtonColor,
    Color? incomingVoiceButtonColor,
    Color? outgoingVoiceButtonIconColor,
    Color? incomingVoiceButtonIconColor,
    Color? outgoingVoiceSpeedColor,
    Color? incomingVoiceSpeedColor,
    Color? outgoingVoiceSpeedTextColor,
    Color? incomingVoiceSpeedTextColor,
    Color? reactionBackground,
    Color? reactionSelectedBackground,
    Color? reactionTextColor,
    Color? menuBackground,
    Color? menuTextColor,
    Color? menuDestructiveColor,
    Color? progressTrackColor,
    Color? progressColor,
    TextStyle? messageTextStyle,
    TextStyle? timeTextStyle,
    TextStyle? senderNameStyle,
    TextStyle? replyTextStyle,
    TextStyle? systemTextStyle,
    TextStyle? linkTextStyle,
    TextStyle? captionTextStyle,
    VStatusIconsConfig? statusIcons,
  }) {
    return VBubbleTheme(
      outgoingBubbleColor: outgoingBubbleColor ?? this.outgoingBubbleColor,
      incomingBubbleColor: incomingBubbleColor ?? this.incomingBubbleColor,
      outgoingBubbleGradient:
          outgoingBubbleGradient ?? this.outgoingBubbleGradient,
      incomingBubbleGradient:
          incomingBubbleGradient ?? this.incomingBubbleGradient,
      outgoingTextColor: outgoingTextColor ?? this.outgoingTextColor,
      incomingTextColor: incomingTextColor ?? this.incomingTextColor,
      outgoingSecondaryTextColor:
          outgoingSecondaryTextColor ?? this.outgoingSecondaryTextColor,
      incomingSecondaryTextColor:
          incomingSecondaryTextColor ?? this.incomingSecondaryTextColor,
      sentIconColor: sentIconColor ?? this.sentIconColor,
      deliveredIconColor: deliveredIconColor ?? this.deliveredIconColor,
      readIconColor: readIconColor ?? this.readIconColor,
      pendingIconColor: pendingIconColor ?? this.pendingIconColor,
      errorColor: errorColor ?? this.errorColor,
      outgoingLinkColor: outgoingLinkColor ?? this.outgoingLinkColor,
      incomingLinkColor: incomingLinkColor ?? this.incomingLinkColor,
      outgoingReplyBarColor:
          outgoingReplyBarColor ?? this.outgoingReplyBarColor,
      incomingReplyBarColor:
          incomingReplyBarColor ?? this.incomingReplyBarColor,
      outgoingReplyBackgroundColor:
          outgoingReplyBackgroundColor ?? this.outgoingReplyBackgroundColor,
      incomingReplyBackgroundColor:
          incomingReplyBackgroundColor ?? this.incomingReplyBackgroundColor,
      outgoingReplyTextColor:
          outgoingReplyTextColor ?? this.outgoingReplyTextColor,
      incomingReplyTextColor:
          incomingReplyTextColor ?? this.incomingReplyTextColor,
      forwardHeaderColor: forwardHeaderColor ?? this.forwardHeaderColor,
      forwardHeaderBackgroundColor:
          forwardHeaderBackgroundColor ?? this.forwardHeaderBackgroundColor,
      selectedBubbleOverlay:
          selectedBubbleOverlay ?? this.selectedBubbleOverlay,
      selectionCheckmarkColor:
          selectionCheckmarkColor ?? this.selectionCheckmarkColor,
      systemMessageBackground:
          systemMessageBackground ?? this.systemMessageBackground,
      systemMessageTextColor:
          systemMessageTextColor ?? this.systemMessageTextColor,
      dateChipBackground: dateChipBackground ?? this.dateChipBackground,
      dateChipTextColor: dateChipTextColor ?? this.dateChipTextColor,
      outgoingWaveformColor:
          outgoingWaveformColor ?? this.outgoingWaveformColor,
      incomingWaveformColor:
          incomingWaveformColor ?? this.incomingWaveformColor,
      outgoingWaveformPlayedColor:
          outgoingWaveformPlayedColor ?? this.outgoingWaveformPlayedColor,
      incomingWaveformPlayedColor:
          incomingWaveformPlayedColor ?? this.incomingWaveformPlayedColor,
      outgoingVoiceButtonColor:
          outgoingVoiceButtonColor ?? this.outgoingVoiceButtonColor,
      incomingVoiceButtonColor:
          incomingVoiceButtonColor ?? this.incomingVoiceButtonColor,
      outgoingVoiceButtonIconColor:
          outgoingVoiceButtonIconColor ?? this.outgoingVoiceButtonIconColor,
      incomingVoiceButtonIconColor:
          incomingVoiceButtonIconColor ?? this.incomingVoiceButtonIconColor,
      outgoingVoiceSpeedColor:
          outgoingVoiceSpeedColor ?? this.outgoingVoiceSpeedColor,
      incomingVoiceSpeedColor:
          incomingVoiceSpeedColor ?? this.incomingVoiceSpeedColor,
      outgoingVoiceSpeedTextColor:
          outgoingVoiceSpeedTextColor ?? this.outgoingVoiceSpeedTextColor,
      incomingVoiceSpeedTextColor:
          incomingVoiceSpeedTextColor ?? this.incomingVoiceSpeedTextColor,
      reactionBackground: reactionBackground ?? this.reactionBackground,
      reactionSelectedBackground:
          reactionSelectedBackground ?? this.reactionSelectedBackground,
      reactionTextColor: reactionTextColor ?? this.reactionTextColor,
      menuBackground: menuBackground ?? this.menuBackground,
      menuTextColor: menuTextColor ?? this.menuTextColor,
      menuDestructiveColor: menuDestructiveColor ?? this.menuDestructiveColor,
      progressTrackColor: progressTrackColor ?? this.progressTrackColor,
      progressColor: progressColor ?? this.progressColor,
      messageTextStyle: messageTextStyle ?? this.messageTextStyle,
      timeTextStyle: timeTextStyle ?? this.timeTextStyle,
      senderNameStyle: senderNameStyle ?? this.senderNameStyle,
      replyTextStyle: replyTextStyle ?? this.replyTextStyle,
      systemTextStyle: systemTextStyle ?? this.systemTextStyle,
      linkTextStyle: linkTextStyle ?? this.linkTextStyle,
      captionTextStyle: captionTextStyle ?? this.captionTextStyle,
      statusIcons: statusIcons ?? this.statusIcons,
    );
  }

  /// Predefined reactions for each style
  static List<String> reactionsForStyle(VBubbleStyle style) {
    switch (style) {
      case VBubbleStyle.telegram:
        return ['👍', '👎', '❤️', '🔥', '🎉', '😢', '💩'];
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
}

/// Extension for shimmer loading colors
///
/// Provides helper methods to get shimmer colors based on bubble direction
extension VBubbleThemeShimmer on VBubbleTheme {
  /// Get shimmer base color for loading placeholders
  ///
  /// Returns outgoing or incoming bubble color with 30% opacity
  Color shimmerBaseColor(bool isMeSender) {
    return isMeSender
        ? outgoingBubbleColor.withValues(alpha: 0.3)
        : incomingBubbleColor.withValues(alpha: 0.3);
  }

  /// Get shimmer highlight color for loading placeholders
  ///
  /// Returns outgoing or incoming bubble color with 10% opacity
  Color shimmerHighlightColor(bool isMeSender) {
    return isMeSender
        ? outgoingBubbleColor.withValues(alpha: 0.1)
        : incomingBubbleColor.withValues(alpha: 0.1);
  }
}

/// Extension providing convenient color getters based on message direction.
extension VBubbleThemeColorHelpers on VBubbleTheme {
  /// Returns text color based on message direction.
  Color textColor(bool isMeSender) =>
      isMeSender ? outgoingTextColor : incomingTextColor;

  /// Returns secondary text color based on message direction.
  Color secondaryTextColor(bool isMeSender) =>
      isMeSender ? outgoingSecondaryTextColor : incomingSecondaryTextColor;

  /// Returns link color based on message direction.
  Color linkColor(bool isMeSender) =>
      isMeSender ? outgoingLinkColor : incomingLinkColor;

  /// Returns bubble background color based on message direction.
  Color bubbleColor(bool isMeSender) =>
      isMeSender ? outgoingBubbleColor : incomingBubbleColor;

  /// Returns reply bar color based on message direction.
  Color replyBarColor(bool isMeSender) =>
      isMeSender ? outgoingReplyBarColor : incomingReplyBarColor;

  /// Returns reply background color based on message direction.
  Color replyBackgroundColor(bool isMeSender) =>
      isMeSender ? outgoingReplyBackgroundColor : incomingReplyBackgroundColor;

  /// Returns voice button color based on message direction.
  Color voiceButtonColor(bool isMeSender) =>
      isMeSender ? outgoingVoiceButtonColor : incomingVoiceButtonColor;

  /// Returns voice button icon color based on message direction.
  Color voiceButtonIconColor(bool isMeSender) =>
      isMeSender ? outgoingVoiceButtonIconColor : incomingVoiceButtonIconColor;

  /// Returns voice speed button color based on message direction.
  Color voiceSpeedColor(bool isMeSender) =>
      isMeSender ? outgoingVoiceSpeedColor : incomingVoiceSpeedColor;

  /// Returns voice speed text color based on message direction.
  Color voiceSpeedTextColor(bool isMeSender) =>
      isMeSender ? outgoingVoiceSpeedTextColor : incomingVoiceSpeedTextColor;

  /// Returns shimmer colors for loading states.
  (Color base, Color highlight) shimmerColors(bool isMeSender) {
    final color = isMeSender ? outgoingBubbleColor : incomingBubbleColor;
    return (
      color.withValues(alpha: 0.3),
      color.withValues(alpha: 0.1),
    );
  }
}
