import 'package:flutter/material.dart';
import '../theme/bubble_theme.dart';

/// Helper for calculating shimmer loading colors
class VShimmerHelper {
  static ({Color base, Color highlight}) getShimmerColors(
    VBubbleTheme theme,
    bool isMeSender,
  ) {
    final bubbleColor =
        isMeSender ? theme.outgoingBubbleColor : theme.incomingBubbleColor;
    return (
      base: bubbleColor.withValues(alpha: 0.3),
      highlight: bubbleColor.withValues(alpha: 0.1),
    );
  }
}
