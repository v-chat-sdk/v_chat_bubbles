import 'package:flutter/material.dart';
import '../bubble_scope.dart';

class VMediaContainer extends StatelessWidget {
  final Widget child;
  final String messageId;
  final double? maxHeight;
  final VoidCallback? onTap;

  /// When true, media fills edge-to-edge without its own clipping
  /// Used when media is inside a bubble wrapper that handles clipping
  final bool fillBubble;

  /// Custom border radius for the media corners
  /// Only used when [fillBubble] is false
  final BorderRadius? borderRadius;

  const VMediaContainer({
    super.key,
    required this.child,
    required this.messageId,
    this.maxHeight,
    this.onTap,
    this.fillBubble = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final config = context.bubbleConfig;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final heroChild = Hero(tag: 'media_$messageId', child: child);
    return GestureDetector(
      onTap: isSelectionMode ? null : onTap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.sizeOf(context).width * config.sizing.maxWidthFraction,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: fillBubble
            ? heroChild
            : ClipRRect(
                borderRadius: borderRadius ??
                    BorderRadius.circular(config.media.cornerRadius),
                child: heroChild,
              ),
      ),
    );
  }
}
