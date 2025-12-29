import 'package:flutter/material.dart';
import '../../core/enums.dart';

/// Configuration for message status icons
@immutable
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

/// Status theme with colors for message delivery states
@immutable
class VBubbleStatusTheme {
  /// Status icons configuration
  final VStatusIconsConfig icons;

  /// Color for pending/sending status
  final Color pendingColor;

  /// Color for sent status
  final Color sentColor;

  /// Color for delivered status
  final Color deliveredColor;

  /// Color for read status
  final Color readColor;

  /// Color for error status
  final Color errorColor;
  const VBubbleStatusTheme({
    this.icons = VStatusIconsConfig.standard,
    required this.pendingColor,
    required this.sentColor,
    required this.deliveredColor,
    required this.readColor,
    required this.errorColor,
  });

  /// Get color for a specific status
  Color colorFor(VMessageStatus status) {
    switch (status) {
      case VMessageStatus.sending:
        return pendingColor;
      case VMessageStatus.sent:
        return sentColor;
      case VMessageStatus.delivered:
        return deliveredColor;
      case VMessageStatus.read:
        return readColor;
      case VMessageStatus.error:
        return errorColor;
    }
  }

  VBubbleStatusTheme copyWith({
    VStatusIconsConfig? icons,
    Color? pendingColor,
    Color? sentColor,
    Color? deliveredColor,
    Color? readColor,
    Color? errorColor,
  }) {
    return VBubbleStatusTheme(
      icons: icons ?? this.icons,
      pendingColor: pendingColor ?? this.pendingColor,
      sentColor: sentColor ?? this.sentColor,
      deliveredColor: deliveredColor ?? this.deliveredColor,
      readColor: readColor ?? this.readColor,
      errorColor: errorColor ?? this.errorColor,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TELEGRAM PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleStatusTheme telegramLight() => const VBubbleStatusTheme(
        pendingColor: Color(0xFF999999),
        sentColor: Color(0xFF19C700),
        deliveredColor: Color(0xFF19C700),
        readColor: Color(0xFF19C700),
        errorColor: Color(0xFFFF3B30),
      );
  static VBubbleStatusTheme telegramDark() => VBubbleStatusTheme(
        pendingColor: const Color(0x80FFFFFF),
        sentColor: const Color(0xFF8696A0),
        deliveredColor: const Color(0xFF8696A0),
        readColor: const Color(0xFF5EADEA),
        errorColor: const Color(0xFFFF6B6B),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // WHATSAPP PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleStatusTheme whatsappLight() => const VBubbleStatusTheme(
        icons: VStatusIconsConfig.whatsapp,
        pendingColor: Color(0xFF8696A0),
        sentColor: Color(0xFF667781),
        deliveredColor: Color(0xFF667781),
        readColor: Color(0xFF53BDEB),
        errorColor: Color(0xFFEA0038),
      );
  static VBubbleStatusTheme whatsappDark() => const VBubbleStatusTheme(
        icons: VStatusIconsConfig.whatsapp,
        pendingColor: Color(0xFF8696A0),
        sentColor: Color(0xFF8696A0),
        deliveredColor: Color(0xFF8696A0),
        readColor: Color(0xFF53BDEB),
        errorColor: Color(0xFFFF4C4C),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MESSENGER PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleStatusTheme messengerLight() => const VBubbleStatusTheme(
        pendingColor: Color(0xFFBCC0C4),
        sentColor: Color(0xFFBCC0C4),
        deliveredColor: Color(0xFFBCC0C4),
        readColor: Color(0xFF0084FF),
        errorColor: Color(0xFFFA383E),
      );
  static VBubbleStatusTheme messengerDark() => const VBubbleStatusTheme(
        pendingColor: Color(0xFF65676B),
        sentColor: Color(0xFF65676B),
        deliveredColor: Color(0xFF65676B),
        readColor: Color(0xFF0084FF),
        errorColor: Color(0xFFFA383E),
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // IMESSAGE PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static VBubbleStatusTheme imessageLight() => const VBubbleStatusTheme(
        pendingColor: Color(0xFF8E8E93),
        sentColor: Color(0xFF8E8E93),
        deliveredColor: Color(0xFF8E8E93),
        readColor: Color(0xFF8E8E93),
        errorColor: Color(0xFFFF3B30),
      );
  static VBubbleStatusTheme imessageDark() => const VBubbleStatusTheme(
        pendingColor: Color(0xFF8E8E93),
        sentColor: Color(0xFF8E8E93),
        deliveredColor: Color(0xFF8E8E93),
        readColor: Color(0xFF8E8E93),
        errorColor: Color(0xFFFF453A),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VBubbleStatusTheme &&
          runtimeType == other.runtimeType &&
          icons == other.icons &&
          pendingColor == other.pendingColor &&
          sentColor == other.sentColor &&
          deliveredColor == other.deliveredColor &&
          readColor == other.readColor &&
          errorColor == other.errorColor;
  @override
  int get hashCode =>
      icons.hashCode ^
      pendingColor.hashCode ^
      sentColor.hashCode ^
      deliveredColor.hashCode ^
      readColor.hashCode ^
      errorColor.hashCode;
}
