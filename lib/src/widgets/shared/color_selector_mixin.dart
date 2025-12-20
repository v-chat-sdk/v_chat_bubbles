import 'package:flutter/material.dart';
import '../../theme/bubble_theme.dart';

/// Mixin for selecting colors based on sender direction (isMeSender)
mixin ColorSelectorMixin {
  bool get isMeSender;

  Color selectTextColor(VBubbleTheme theme) =>
      isMeSender ? theme.outgoingTextColor : theme.incomingTextColor;

  Color selectSecondaryTextColor(VBubbleTheme theme) => isMeSender
      ? theme.outgoingSecondaryTextColor
      : theme.incomingSecondaryTextColor;

  Color selectLinkColor(VBubbleTheme theme) =>
      isMeSender ? theme.outgoingLinkColor : theme.incomingLinkColor;

  Color selectBubbleColor(VBubbleTheme theme) =>
      isMeSender ? theme.outgoingBubbleColor : theme.incomingBubbleColor;

  Color selectReplyBarColor(VBubbleTheme theme) =>
      isMeSender ? theme.outgoingReplyBarColor : theme.incomingReplyBarColor;

  /// Static helper methods for use in widgets that can't use the mixin
  static Color getTextColor(VBubbleTheme theme, bool isMeSender) =>
      isMeSender ? theme.outgoingTextColor : theme.incomingTextColor;

  static Color getSecondaryTextColor(VBubbleTheme theme, bool isMeSender) =>
      isMeSender
          ? theme.outgoingSecondaryTextColor
          : theme.incomingSecondaryTextColor;

  static Color getLinkColor(VBubbleTheme theme, bool isMeSender) =>
      isMeSender ? theme.outgoingLinkColor : theme.incomingLinkColor;

  static Color getBubbleColor(VBubbleTheme theme, bool isMeSender) =>
      isMeSender ? theme.outgoingBubbleColor : theme.incomingBubbleColor;

  static Color getReplyBarColor(VBubbleTheme theme, bool isMeSender) =>
      isMeSender ? theme.outgoingReplyBarColor : theme.incomingReplyBarColor;
}
