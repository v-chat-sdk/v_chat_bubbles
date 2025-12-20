import 'package:flutter/material.dart';
import 'bubble_scope.dart';

/// Unread messages divider
///
/// Displays a horizontal line with a count of unread messages,
/// used to separate read from unread messages in the chat.
class VUnreadDivider extends StatelessWidget {
  /// Number of unread messages
  final int count;

  /// Custom text to display instead of the default message
  final String? customText;

  /// Custom background color for line segments
  final Color? backgroundColor;

  /// Custom text color
  final Color? textColor;

  const VUnreadDivider({
    super.key,
    required this.count,
    this.customText,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final translations = config.translations;
    final messageLabel =
        count > 1 ? translations.unreadPlural : translations.unreadSingular;
    final displayText = customText ?? '$count $messageLabel';
    final lineColor =
        (textColor ?? theme.incomingLinkColor).withValues(alpha: 0.3);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(height: 1, color: lineColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              displayText,
              style: theme.systemTextStyle.copyWith(
                color: textColor ?? theme.incomingLinkColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(height: 1, color: lineColor),
          ),
        ],
      ),
    );
  }
}
