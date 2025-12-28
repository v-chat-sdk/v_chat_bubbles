import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../painters/bubble_painter.dart';
import 'bubble_scope.dart';

/// Wrapper widget that provides styled bubble background
class VBubbleWrapper extends StatelessWidget {
  final bool isMeSender;
  final bool showTail;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final Color? backgroundColor;

  /// When true, clips content to bubble shape (for media bubbles)
  final bool clipContent;
  const VBubbleWrapper({
    super.key,
    required this.isMeSender,
    required this.child,
    this.showTail = true,
    this.padding,
    this.maxWidth,
    this.backgroundColor,
    this.clipContent = true,
  });
  @override
  Widget build(BuildContext context) {
    final scope = context.bubbleScope;
    final theme = scope.theme;
    final config = scope.config;
    final style = scope.style;
    // Detect RTL layout direction
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final defaultColor =
        isMeSender ? theme.outgoingBubbleColor : theme.incomingBubbleColor;
    final bubbleColor = backgroundColor ?? defaultColor;
    // Get gradient from theme (only used for Telegram style)
    final bubbleGradient = isMeSender
        ? theme.outgoingBubbleGradient
        : theme.incomingBubbleGradient;
    final gradient = style == VBubbleStyle.telegram ? bubbleGradient : null;
    final effectiveMaxWidth = maxWidth ??
        (MediaQuery.sizeOf(context).width * config.sizing.maxWidthFraction);
    final hPadding = config.spacing.contentPaddingHorizontal;
    final vPadding = config.spacing.contentPaddingVertical;
    final tailOffset = showTail ? config.spacing.tailSize : 0.0;
    // Determine which side gets tail padding based on isMeSender and RTL
    // In LTR: outgoing (isMeSender) = tail on right, incoming = tail on left
    // In RTL: outgoing (isMeSender) = tail on left, incoming = tail on right
    final tailOnRight = isMeSender != isRtl;
    final leftPadding = tailOnRight ? hPadding : hPadding + tailOffset;
    final rightPadding = tailOnRight ? hPadding + tailOffset : hPadding;
    final defaultPadding = EdgeInsets.only(
      left: leftPadding,
      right: rightPadding,
      top: vPadding,
      bottom: vPadding,
    );
    final bubbleRadius = config.spacing.bubbleRadius;
    Widget content = Padding(padding: padding ?? defaultPadding, child: child);
    // When clipping, wrap content in ClipRRect to match bubble shape
    if (clipContent) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(bubbleRadius),
        child: content,
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: effectiveMaxWidth,
        minWidth: config.sizing.minWidth,
      ),
      child: IntrinsicWidth(
        child: CustomPaint(
          painter: VBubblePainter.forStyle(
            style: style,
            color: bubbleColor,
            gradient: gradient,
            isMeSender: isMeSender,
            showTail: showTail,
            radius: bubbleRadius,
            tailSize: config.spacing.tailSize,
            isRtl: isRtl,
          ),
          child: content,
        ),
      ),
    );
  }
}
