import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'bubble_scope.dart';

/// Animated typing indicator bubble
///
/// Shows animated bouncing dots to indicate that someone is typing.
/// Uses a single animation controller for smooth, efficient animation.
class VTypingIndicator extends StatefulWidget {
  /// Whether this appears on the sender (right) side
  final bool isMeSender;

  /// Optional avatar widget to show alongside the indicator
  final Widget? avatar;

  const VTypingIndicator({
    super.key,
    this.isMeSender = false,
    this.avatar,
  });

  @override
  State<VTypingIndicator> createState() => _VTypingIndicatorState();
}

class _VTypingIndicatorState extends State<VTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// Number of dots in the animation
  static const int _dotCount = 3;

  /// Delay between each dot's animation start
  static const double _animationDelay = 0.2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    return Padding(
      padding: EdgeInsets.only(
        left: widget.isMeSender ? 50 : config.spacing.horizontalMargin,
        right: widget.isMeSender ? config.spacing.horizontalMargin : 50,
        top: config.spacing.sameSenderSpacing,
        bottom: config.spacing.sameSenderSpacing,
      ),
      child: Row(
        mainAxisAlignment:
            widget.isMeSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.isMeSender && config.avatar.show) ...[
            if (widget.avatar != null)
              widget.avatar!
            else
              SizedBox(width: config.avatar.size),
            const SizedBox(width: 8),
          ],
          Container(
            padding: BubbleSpacing.largePadding,
            decoration: BoxDecoration(
              color: widget.isMeSender
                  ? theme.outgoingBubbleColor
                  : theme.incomingBubbleColor,
              borderRadius: BorderRadius.circular(config.spacing.bubbleRadius),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => _buildDots(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots(BuildContext context) {
    final theme = context.bubbleTheme;
    final dotColor = widget.isMeSender
        ? theme.outgoingSecondaryTextColor
        : theme.incomingSecondaryTextColor;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_dotCount, (index) {
        final delay = index * _animationDelay;
        final animationValue = (_controller.value - delay).clamp(0.0, 1.0);
        final bounceValue =
            animationValue < 0.5 ? animationValue * 2 : 2 - animationValue * 2;
        return Container(
          margin: EdgeInsets.only(right: index < _dotCount - 1 ? 4 : 0),
          child: Transform.translate(
            offset: Offset(0, -4 * bounceValue),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor.withValues(alpha: 0.6 + 0.4 * bounceValue),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}
