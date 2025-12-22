import 'package:flutter/material.dart';

/// Directional voice theme colors for outgoing or incoming messages
@immutable
class VDirectionalVoiceTheme {
  /// Played portion of waveform
  final Color waveformPlayedColor;
  /// Unplayed portion of waveform
  final Color waveformUnplayedColor;
  /// Play/pause button background color
  final Color buttonColor;
  /// Play/pause button icon color
  final Color buttonIconColor;
  /// Speed control button background color
  final Color speedButtonColor;
  /// Speed control button text color
  final Color speedButtonTextColor;
  /// Duration text color
  final Color durationTextColor;
  /// Loading indicator color
  final Color loadingColor;
  const VDirectionalVoiceTheme({
    required this.waveformPlayedColor,
    required this.waveformUnplayedColor,
    required this.buttonColor,
    required this.buttonIconColor,
    required this.speedButtonColor,
    required this.speedButtonTextColor,
    required this.durationTextColor,
    required this.loadingColor,
  });
  VDirectionalVoiceTheme copyWith({
    Color? waveformPlayedColor,
    Color? waveformUnplayedColor,
    Color? buttonColor,
    Color? buttonIconColor,
    Color? speedButtonColor,
    Color? speedButtonTextColor,
    Color? durationTextColor,
    Color? loadingColor,
  }) {
    return VDirectionalVoiceTheme(
      waveformPlayedColor: waveformPlayedColor ?? this.waveformPlayedColor,
      waveformUnplayedColor:
          waveformUnplayedColor ?? this.waveformUnplayedColor,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonIconColor: buttonIconColor ?? this.buttonIconColor,
      speedButtonColor: speedButtonColor ?? this.speedButtonColor,
      speedButtonTextColor: speedButtonTextColor ?? this.speedButtonTextColor,
      durationTextColor: durationTextColor ?? this.durationTextColor,
      loadingColor: loadingColor ?? this.loadingColor,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VDirectionalVoiceTheme &&
          runtimeType == other.runtimeType &&
          waveformPlayedColor == other.waveformPlayedColor &&
          waveformUnplayedColor == other.waveformUnplayedColor &&
          buttonColor == other.buttonColor &&
          buttonIconColor == other.buttonIconColor &&
          speedButtonColor == other.speedButtonColor &&
          speedButtonTextColor == other.speedButtonTextColor &&
          durationTextColor == other.durationTextColor &&
          loadingColor == other.loadingColor;
  @override
  int get hashCode =>
      waveformPlayedColor.hashCode ^
      waveformUnplayedColor.hashCode ^
      buttonColor.hashCode ^
      buttonIconColor.hashCode ^
      speedButtonColor.hashCode ^
      speedButtonTextColor.hashCode ^
      durationTextColor.hashCode ^
      loadingColor.hashCode;
}

/// Visualizer configuration for voice messages
@immutable
class VVoiceVisualizerTheme {
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
  /// Size of the play/pause button
  final double buttonSize;
  /// Whether to use simple icon without circular background
  final bool useSimplePlayIcon;
  /// Size of simple icon (when useSimplePlayIcon is true)
  final double simpleIconSize;
  /// Whether to show speed control button
  final bool showSpeedControl;
  /// Border radius for speed button
  final double speedButtonBorderRadius;
  /// Padding for speed button
  final EdgeInsets speedButtonPadding;
  /// Text style for duration display
  final TextStyle durationTextStyle;
  const VVoiceVisualizerTheme({
    this.showVisualizer = true,
    this.visualizerHeight = 40.0,
    this.visualizerBarCount = 30,
    this.visualizerBarSpacing = 2.0,
    this.visualizerMinBarHeight = 4.0,
    this.enableBarAnimations = true,
    this.buttonSize = 40.0,
    this.useSimplePlayIcon = false,
    this.simpleIconSize = 24.0,
    this.showSpeedControl = true,
    this.speedButtonBorderRadius = 6.0,
    this.speedButtonPadding =
        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    this.durationTextStyle =
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
  });
  VVoiceVisualizerTheme copyWith({
    bool? showVisualizer,
    double? visualizerHeight,
    int? visualizerBarCount,
    double? visualizerBarSpacing,
    double? visualizerMinBarHeight,
    bool? enableBarAnimations,
    double? buttonSize,
    bool? useSimplePlayIcon,
    double? simpleIconSize,
    bool? showSpeedControl,
    double? speedButtonBorderRadius,
    EdgeInsets? speedButtonPadding,
    TextStyle? durationTextStyle,
  }) {
    return VVoiceVisualizerTheme(
      showVisualizer: showVisualizer ?? this.showVisualizer,
      visualizerHeight: visualizerHeight ?? this.visualizerHeight,
      visualizerBarCount: visualizerBarCount ?? this.visualizerBarCount,
      visualizerBarSpacing: visualizerBarSpacing ?? this.visualizerBarSpacing,
      visualizerMinBarHeight:
          visualizerMinBarHeight ?? this.visualizerMinBarHeight,
      enableBarAnimations: enableBarAnimations ?? this.enableBarAnimations,
      buttonSize: buttonSize ?? this.buttonSize,
      useSimplePlayIcon: useSimplePlayIcon ?? this.useSimplePlayIcon,
      simpleIconSize: simpleIconSize ?? this.simpleIconSize,
      showSpeedControl: showSpeedControl ?? this.showSpeedControl,
      speedButtonBorderRadius:
          speedButtonBorderRadius ?? this.speedButtonBorderRadius,
      speedButtonPadding: speedButtonPadding ?? this.speedButtonPadding,
      durationTextStyle: durationTextStyle ?? this.durationTextStyle,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VVoiceVisualizerTheme &&
          runtimeType == other.runtimeType &&
          showVisualizer == other.showVisualizer &&
          visualizerHeight == other.visualizerHeight &&
          visualizerBarCount == other.visualizerBarCount &&
          visualizerBarSpacing == other.visualizerBarSpacing &&
          visualizerMinBarHeight == other.visualizerMinBarHeight &&
          enableBarAnimations == other.enableBarAnimations &&
          buttonSize == other.buttonSize &&
          useSimplePlayIcon == other.useSimplePlayIcon &&
          simpleIconSize == other.simpleIconSize &&
          showSpeedControl == other.showSpeedControl &&
          speedButtonBorderRadius == other.speedButtonBorderRadius &&
          speedButtonPadding == other.speedButtonPadding &&
          durationTextStyle == other.durationTextStyle;
  @override
  int get hashCode =>
      showVisualizer.hashCode ^
      visualizerHeight.hashCode ^
      visualizerBarCount.hashCode ^
      visualizerBarSpacing.hashCode ^
      visualizerMinBarHeight.hashCode ^
      enableBarAnimations.hashCode ^
      buttonSize.hashCode ^
      useSimplePlayIcon.hashCode ^
      showSpeedControl.hashCode;
}

/// Complete voice message theme
@immutable
class VBubbleVoiceTheme {
  /// Voice colors for outgoing messages
  final VDirectionalVoiceTheme outgoing;
  /// Voice colors for incoming messages
  final VDirectionalVoiceTheme incoming;
  /// Visualizer configuration
  final VVoiceVisualizerTheme visualizer;
  const VBubbleVoiceTheme({
    required this.outgoing,
    required this.incoming,
    this.visualizer = const VVoiceVisualizerTheme(),
  });
  /// Get waveform played color based on message direction
  Color waveformPlayedColor(bool isMeSender) =>
      isMeSender ? outgoing.waveformPlayedColor : incoming.waveformPlayedColor;
  /// Get waveform unplayed color based on message direction
  Color waveformUnplayedColor(bool isMeSender) => isMeSender
      ? outgoing.waveformUnplayedColor
      : incoming.waveformUnplayedColor;
  /// Get button background color based on message direction
  Color buttonColor(bool isMeSender) =>
      isMeSender ? outgoing.buttonColor : incoming.buttonColor;
  /// Get button icon color based on message direction
  Color buttonIconColor(bool isMeSender) =>
      isMeSender ? outgoing.buttonIconColor : incoming.buttonIconColor;
  /// Get speed button background color based on message direction
  Color speedButtonColor(bool isMeSender) =>
      isMeSender ? outgoing.speedButtonColor : incoming.speedButtonColor;
  /// Get speed button text color based on message direction
  Color speedButtonTextColor(bool isMeSender) =>
      isMeSender ? outgoing.speedButtonTextColor : incoming.speedButtonTextColor;
  /// Get duration text color based on message direction
  Color durationTextColor(bool isMeSender) =>
      isMeSender ? outgoing.durationTextColor : incoming.durationTextColor;
  /// Get loading indicator color based on message direction
  Color loadingColor(bool isMeSender) =>
      isMeSender ? outgoing.loadingColor : incoming.loadingColor;
  // ═══════════════════════════════════════════════════════════════════════════
  // VISUALIZER CONVENIENCE GETTERS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Whether to show voice visualizer
  bool get showVisualizer => visualizer.showVisualizer;
  /// Height of the visualizer
  double get visualizerHeight => visualizer.visualizerHeight;
  /// Number of bars in the visualizer
  int get visualizerBarCount => visualizer.visualizerBarCount;
  /// Spacing between visualizer bars
  double get visualizerBarSpacing => visualizer.visualizerBarSpacing;
  /// Minimum height for visualizer bars
  double get visualizerMinBarHeight => visualizer.visualizerMinBarHeight;
  /// Whether to enable bar animations during playback
  bool get enableBarAnimations => visualizer.enableBarAnimations;
  /// Size of the play/pause button
  double get buttonSize => visualizer.buttonSize;
  /// Whether to use simple icon without circular background
  bool get useSimplePlayIcon => visualizer.useSimplePlayIcon;
  /// Size of simple icon (when useSimplePlayIcon is true)
  double get simpleIconSize => visualizer.simpleIconSize;
  /// Whether to show speed control button
  bool get showSpeedControl => visualizer.showSpeedControl;
  /// Border radius for speed button
  double get speedButtonBorderRadius => visualizer.speedButtonBorderRadius;
  /// Padding for speed button
  EdgeInsets get speedButtonPadding => visualizer.speedButtonPadding;
  /// Text style for duration display
  TextStyle get durationTextStyle => visualizer.durationTextStyle;
  VBubbleVoiceTheme copyWith({
    VDirectionalVoiceTheme? outgoing,
    VDirectionalVoiceTheme? incoming,
    VVoiceVisualizerTheme? visualizer,
  }) {
    return VBubbleVoiceTheme(
      outgoing: outgoing ?? this.outgoing,
      incoming: incoming ?? this.incoming,
      visualizer: visualizer ?? this.visualizer,
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleVoiceTheme telegramLight() => const VBubbleVoiceTheme(
        outgoing: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF4FAE4E),
          waveformUnplayedColor: Color(0xFF93D987),
          buttonColor: Color(0xFF4FAE4E),
          buttonIconColor: Colors.white,
          speedButtonColor: Color(0x334FAE4E),
          speedButtonTextColor: Color(0xFF4FAE4E),
          durationTextColor: Color(0xFF4FAE4E),
          loadingColor: Color(0xFF4FAE4E),
        ),
        incoming: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF2481CC),
          waveformUnplayedColor: Color(0xFFD4D4D4),
          buttonColor: Color(0xFF2481CC),
          buttonIconColor: Colors.white,
          speedButtonColor: Color(0x332481CC),
          speedButtonTextColor: Color(0xFF2481CC),
          durationTextColor: Color(0xFF999999),
          loadingColor: Color(0xFF2481CC),
        ),
        visualizer: VVoiceVisualizerTheme(
          visualizerBarCount: 25,
          visualizerHeight: 40.0,
        ),
      );
  static VBubbleVoiceTheme telegramDark() => const VBubbleVoiceTheme(
        outgoing: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF7EB3D1),
          waveformUnplayedColor: Color(0xFF5A8AA5),
          buttonColor: Color(0xFF7EB3D1),
          buttonIconColor: Color(0xFF232E3C),
          speedButtonColor: Color(0x337EB3D1),
          speedButtonTextColor: Color(0xFF7EB3D1),
          durationTextColor: Color(0xFF7EB3D1),
          loadingColor: Color(0xFF7EB3D1),
        ),
        incoming: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF6AB3F3),
          waveformUnplayedColor: Color(0xFF3D4A57),
          buttonColor: Color(0xFF6AB3F3),
          buttonIconColor: Color(0xFF232E3C),
          speedButtonColor: Color(0x336AB3F3),
          speedButtonTextColor: Color(0xFF6AB3F3),
          durationTextColor: Color(0xFF7E8B99),
          loadingColor: Color(0xFF6AB3F3),
        ),
        visualizer: VVoiceVisualizerTheme(
          visualizerBarCount: 25,
          visualizerHeight: 40.0,
        ),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleVoiceTheme whatsappLight() => const VBubbleVoiceTheme(
        outgoing: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF34B7F1),
          waveformUnplayedColor: Color(0xFF9CE1A8),
          buttonColor: Color(0xFF25D366),
          buttonIconColor: Colors.white,
          speedButtonColor: Color(0x3325D366),
          speedButtonTextColor: Color(0xFF25D366),
          durationTextColor: Color(0xFF667781),
          loadingColor: Color(0xFF25D366),
        ),
        incoming: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF34B7F1),
          waveformUnplayedColor: Color(0xFFD9DADB),
          buttonColor: Color(0xFF25D366),
          buttonIconColor: Colors.white,
          speedButtonColor: Color(0x33667781),
          speedButtonTextColor: Color(0xFF667781),
          durationTextColor: Color(0xFF667781),
          loadingColor: Color(0xFF25D366),
        ),
        visualizer: VVoiceVisualizerTheme(
          visualizerBarCount: 30,
          visualizerHeight: 38.0,
        ),
      );
  static VBubbleVoiceTheme whatsappDark() => const VBubbleVoiceTheme(
        outgoing: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF34B7F1),
          waveformUnplayedColor: Color(0xFF3B756B),
          buttonColor: Color(0xFF25D366),
          buttonIconColor: Colors.white,
          speedButtonColor: Color(0x3325D366),
          speedButtonTextColor: Color(0xFF25D366),
          durationTextColor: Color(0xFF8696A0),
          loadingColor: Color(0xFF25D366),
        ),
        incoming: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF34B7F1),
          waveformUnplayedColor: Color(0xFF374248),
          buttonColor: Color(0xFF25D366),
          buttonIconColor: Colors.white,
          speedButtonColor: Color(0x338696A0),
          speedButtonTextColor: Color(0xFF8696A0),
          durationTextColor: Color(0xFF8696A0),
          loadingColor: Color(0xFF25D366),
        ),
        visualizer: VVoiceVisualizerTheme(
          visualizerBarCount: 30,
          visualizerHeight: 38.0,
        ),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleVoiceTheme messengerLight() => const VBubbleVoiceTheme(
        outgoing: VDirectionalVoiceTheme(
          waveformPlayedColor: Colors.white,
          waveformUnplayedColor: Color(0xFFB8D4FF),
          buttonColor: Colors.white,
          buttonIconColor: Color(0xFF0084FF),
          speedButtonColor: Color(0x33FFFFFF),
          speedButtonTextColor: Colors.white,
          durationTextColor: Color(0xFFB8D4FF),
          loadingColor: Colors.white,
        ),
        incoming: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF0084FF),
          waveformUnplayedColor: Color(0xFFBCC0C4),
          buttonColor: Color(0xFF0084FF),
          buttonIconColor: Colors.white,
          speedButtonColor: Color(0x330084FF),
          speedButtonTextColor: Color(0xFF0084FF),
          durationTextColor: Color(0xFF65676B),
          loadingColor: Color(0xFF0084FF),
        ),
        visualizer: VVoiceVisualizerTheme(
          visualizerBarCount: 35,
          visualizerHeight: 36.0,
          useSimplePlayIcon: true,
        ),
      );
  static VBubbleVoiceTheme messengerDark() => const VBubbleVoiceTheme(
        outgoing: VDirectionalVoiceTheme(
          waveformPlayedColor: Colors.white,
          waveformUnplayedColor: Color(0xFFB8D4FF),
          buttonColor: Colors.white,
          buttonIconColor: Color(0xFF0084FF),
          speedButtonColor: Color(0x33FFFFFF),
          speedButtonTextColor: Colors.white,
          durationTextColor: Color(0xFFB8D4FF),
          loadingColor: Colors.white,
        ),
        incoming: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF4599FF),
          waveformUnplayedColor: Color(0xFF4E4F50),
          buttonColor: Color(0xFF4599FF),
          buttonIconColor: Color(0xFF242526),
          speedButtonColor: Color(0x334599FF),
          speedButtonTextColor: Color(0xFF4599FF),
          durationTextColor: Color(0xFFB0B3B8),
          loadingColor: Color(0xFF4599FF),
        ),
        visualizer: VVoiceVisualizerTheme(
          visualizerBarCount: 35,
          visualizerHeight: 36.0,
          useSimplePlayIcon: true,
        ),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleVoiceTheme imessageLight() => const VBubbleVoiceTheme(
        outgoing: VDirectionalVoiceTheme(
          waveformPlayedColor: Colors.white,
          waveformUnplayedColor: Color(0x99FFFFFF),
          buttonColor: Colors.white,
          buttonIconColor: Color(0xFF007AFF),
          speedButtonColor: Color(0x33FFFFFF),
          speedButtonTextColor: Colors.white,
          durationTextColor: Color(0xCCFFFFFF),
          loadingColor: Colors.white,
        ),
        incoming: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF007AFF),
          waveformUnplayedColor: Color(0xFFC7C7CC),
          buttonColor: Color(0xFF007AFF),
          buttonIconColor: Colors.white,
          speedButtonColor: Color(0x33007AFF),
          speedButtonTextColor: Color(0xFF007AFF),
          durationTextColor: Color(0xFF8E8E93),
          loadingColor: Color(0xFF007AFF),
        ),
        visualizer: VVoiceVisualizerTheme(
          visualizerBarCount: 20,
          visualizerHeight: 32.0,
          buttonSize: 36.0,
        ),
      );
  static VBubbleVoiceTheme imessageDark() => const VBubbleVoiceTheme(
        outgoing: VDirectionalVoiceTheme(
          waveformPlayedColor: Colors.white,
          waveformUnplayedColor: Color(0x80FFFFFF),
          buttonColor: Colors.white,
          buttonIconColor: Color(0xFF0A84FF),
          speedButtonColor: Color(0x33FFFFFF),
          speedButtonTextColor: Colors.white,
          durationTextColor: Color(0xB3FFFFFF),
          loadingColor: Colors.white,
        ),
        incoming: VDirectionalVoiceTheme(
          waveformPlayedColor: Color(0xFF0A84FF),
          waveformUnplayedColor: Color(0xFF48484A),
          buttonColor: Color(0xFF0A84FF),
          buttonIconColor: Color(0xFF1C1C1E),
          speedButtonColor: Color(0x330A84FF),
          speedButtonTextColor: Color(0xFF0A84FF),
          durationTextColor: Color(0xFF8E8E93),
          loadingColor: Color(0xFF0A84FF),
        ),
        visualizer: VVoiceVisualizerTheme(
          visualizerBarCount: 20,
          visualizerHeight: 32.0,
          buttonSize: 36.0,
        ),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleVoiceTheme &&
          runtimeType == other.runtimeType &&
          outgoing == other.outgoing &&
          incoming == other.incoming &&
          visualizer == other.visualizer;
  @override
  int get hashCode =>
      outgoing.hashCode ^ incoming.hashCode ^ visualizer.hashCode;
}
