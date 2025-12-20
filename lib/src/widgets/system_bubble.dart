import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'bubble_scope.dart';

/// System message bubble with customizable appearance
///
/// Displays system-generated messages (e.g., "User joined the chat",
/// "Settings changed", etc.) centered in the chat view with
/// configurable styling.
class VSystemBubble extends StatelessWidget {
  /// The message text to display
  final String text;

  /// Custom background color (defaults to theme systemMessageBackground)
  final Color? backgroundColor;

  /// Custom text color (defaults to theme systemMessageTextColor)
  final Color? textColor;

  /// Custom padding around the text
  final EdgeInsetsGeometry? padding;

  /// Custom margin around the bubble
  final EdgeInsetsGeometry? margin;

  /// Custom border radius (defaults to 16)
  final double? borderRadius;

  const VSystemBubble({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.bubbleTheme;
    return Center(
      child: Container(
        margin: margin ?? BubbleSpacing.chipMargin,
        padding: padding ?? BubbleSpacing.chipPadding,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.systemMessageBackground,
          borderRadius: BubbleRadius.circular(borderRadius ?? 16),
        ),
        child: Text(
          text,
          style: theme.systemTextStyle.copyWith(
            color: textColor ?? theme.systemMessageTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
