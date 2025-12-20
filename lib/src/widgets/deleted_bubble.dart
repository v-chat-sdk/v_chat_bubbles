import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'bubble_scope.dart';

/// Deleted message placeholder bubble
///
/// Displays a semi-transparent bubble indicating that a message
/// was deleted. Shows an icon, explanatory text, and timestamp.
class VDeletedBubble extends StatelessWidget {
  /// Whether this was sent by the current user
  final bool isMeSender;

  /// Timestamp of the original message
  final String time;

  const VDeletedBubble({
    super.key,
    required this.isMeSender,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final textColor = isMeSender
        ? theme.outgoingSecondaryTextColor
        : theme.incomingSecondaryTextColor;
    final bubbleColor =
        isMeSender ? theme.outgoingBubbleColor : theme.incomingBubbleColor;
    return Padding(
      padding: EdgeInsets.only(
        left: isMeSender ? 50 : config.spacing.horizontalMargin,
        right: isMeSender ? config.spacing.horizontalMargin : 50,
        top: config.spacing.sameSenderSpacing,
        bottom: config.spacing.sameSenderSpacing,
      ),
      child: Align(
        alignment: isMeSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bubbleColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(config.spacing.bubbleRadius),
            border: Border.all(
              color: textColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.block, size: BubbleSizes.iconMedium, color: textColor),
              BubbleSpacing.gapM,
              Text(
                config.translations.deletedMessage,
                style: theme.messageTextStyle.copyWith(
                  color: textColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
              BubbleSpacing.gapL,
              Text(
                time,
                style: theme.timeTextStyle.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
