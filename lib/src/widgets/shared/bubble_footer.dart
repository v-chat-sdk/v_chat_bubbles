import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/enums.dart';
import '../bubble_scope.dart';

class VBubbleFooter extends StatelessWidget {
  final bool isMeSender;
  final String time;
  final VMessageStatus status;
  final bool isStarred;
  final bool isPinned;
  final bool isEdited;
  final Color? overrideColor;

  const VBubbleFooter({
    super.key,
    required this.isMeSender,
    required this.time,
    this.status = VMessageStatus.sent,
    this.isStarred = false,
    this.isPinned = false,
    this.isEdited = false,
    this.overrideColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final defaultMetaColor = isMeSender
        ? theme.outgoingSecondaryTextColor
        : theme.incomingSecondaryTextColor;
    final metaColor = overrideColor ?? defaultMetaColor;
    // Inline meta row - matches Telegram iOS style
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pin indicator (before star, per Telegram iOS)
        if (isPinned) ...[
          Icon(Icons.push_pin, size: BubbleSizes.iconTiny, color: metaColor),
          BubbleSpacing.gapXS,
        ],
        // Star indicator
        if (isStarred) ...[
          Icon(Icons.star, size: BubbleSizes.iconTiny, color: metaColor),
          BubbleSpacing.gapXS,
        ],
        // Edited label
        if (isEdited) ...[
          Text(
            config.translations.statusEdited,
            style: theme.timeTextStyle.copyWith(color: metaColor),
          ),
          BubbleSpacing.gapXS,
        ],
        // Timestamp
        Text(time, style: theme.timeTextStyle.copyWith(color: metaColor)),
        // Status icon (outgoing only)
        if (isMeSender) ...[
          BubbleSpacing.gapXS,
          _buildStatusIcon(context, metaColor),
        ],
      ],
    );
  }

  Widget _buildStatusIcon(BuildContext context, Color color) {
    final theme = context.bubbleTheme;
    final statusConfig = theme.statusIcons;

    // Determine color based on status if not overridden by the footer color
    // But since the design often wants the status icon to match the footer text color or have specific status colors
    // We should check if we need to use status-specific colors or the metaColor

    // In the original BaseBubble, it logic was:
    // Color color;
    // if (overrideColor != null) color = overrideColor;
    // else switch(status) { ... }

    // Here we passed `metaColor` which is `overrideColor ?? defaultMetaColor`.
    // So we need to reconstruct the logic to respect specific status colors if overrideColor was null.

    Color iconColor = color;
    if (overrideColor == null) {
      switch (status) {
        case VMessageStatus.sending:
          iconColor = theme.pendingIconColor;
        case VMessageStatus.sent:
          iconColor = theme.sentIconColor;
        case VMessageStatus.delivered:
          iconColor = theme.deliveredIconColor;
        case VMessageStatus.read:
          iconColor = theme.readIconColor;
        case VMessageStatus.error:
          iconColor = theme.errorColor;
      }
    }

    return Icon(
      statusConfig.iconFor(status),
      size: statusConfig.size,
      color: iconColor,
    );
  }
}
