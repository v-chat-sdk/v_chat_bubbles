import 'package:flutter/material.dart';
import '../../core/enums.dart';
import '../../theme/bubble_theme.dart';

/// Displays message status as an icon.
///
/// Can use either a [VStatusIconsConfig] for custom icons or fall back to defaults.
class VMessageStatusIcon extends StatelessWidget {
  const VMessageStatusIcon({
    super.key,
    required this.status,
    this.color,
    this.size,
    this.readColor,
    this.errorColor,
    this.iconConfig,
  });

  final VMessageStatus status;
  final Color? color;
  final double? size;
  final Color? readColor;
  final Color? errorColor;

  /// Optional icon configuration for custom icons
  final VStatusIconsConfig? iconConfig;

  @override
  Widget build(BuildContext context) {
    final config = iconConfig ?? VStatusIconsConfig.standard;
    final iconSize = size ?? config.size;
    Color iconColor = color ?? Colors.white70;
    switch (status) {
      case VMessageStatus.sending:
        break;
      case VMessageStatus.sent:
      case VMessageStatus.delivered:
        break;
      case VMessageStatus.read:
        iconColor = readColor ?? Colors.blue;
      case VMessageStatus.error:
        iconColor = errorColor ?? Colors.red;
    }
    return Icon(
      config.iconFor(status),
      size: iconSize,
      color: iconColor,
    );
  }
}
