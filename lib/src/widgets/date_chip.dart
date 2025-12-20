import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'bubble_scope.dart';

/// Date separator chip displayed between message groups
///
/// Shows the date when messages were sent, typically used to separate
/// messages from different days.
class VDateChip extends StatelessWidget {
  /// Formatted date string to display
  final String date;

  /// Custom background color (defaults to theme dateChipBackground)
  final Color? backgroundColor;

  /// Custom text color (defaults to theme dateChipTextColor)
  final Color? textColor;

  const VDateChip({
    super.key,
    required this.date,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.bubbleTheme;
    return Center(
      child: Container(
        margin: BubbleSpacing.chipMargin,
        padding: BubbleSpacing.chipPadding,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.dateChipBackground,
          borderRadius: BubbleRadius.chip,
        ),
        child: Text(
          date,
          style: theme.systemTextStyle.copyWith(
            color: textColor ?? theme.dateChipTextColor,
          ),
        ),
      ),
    );
  }
}
