import 'package:flutter/material.dart';
import 'enums.dart';
import 'models.dart';

/// Centralized callbacks for all bubble interactions
///
/// Consolidates callbacks into logical groups:
/// - Core interactions (tap, long press, swipe, select)
/// - Grouped callbacks with action enums (reactions, text detection, media, message actions)
/// - Type-specific callbacks (poll, expand toggle, quoted content)
class VBubbleCallbacks {
  // ===== CORE INTERACTIONS =====

  /// Called when bubble is tapped
  final void Function(String messageId)? onTap;

  /// Called on long press - shows context menu
  final void Function(String messageId, Offset position)? onLongPress;

  /// Called when user swipes to reply
  final void Function(String messageId)? onSwipeReply;

  /// Called when selection state changes
  final void Function(String messageId, bool isSelected)? onSelect;

  /// Called when avatar is tapped
  final void Function(String senderId)? onAvatarTap;

  /// Called when reply preview is tapped (jump to original)
  final void Function(String originalMessageId)? onReplyTap;

  // ===== GROUPED CALLBACKS =====

  /// Called for reaction actions (add/remove) - typically from context menu
  final void Function(String messageId, String emoji, VReactionAction action)?
      onReaction;

  /// Called when a reaction pill is tapped on the bubble
  /// Use this to show who reacted with this emoji (e.g., display a popup)
  final void Function(String messageId, String emoji, Offset position)?
      onReactionInfoTap;

  /// Called for any pattern tap (supports custom patterns)
  final void Function(VPatternMatch match)? onPatternTap;

  /// Called when media is tapped (images, videos, galleries)
  final void Function(VMediaTapData data)? onMediaTap;

  /// Called when custom menu item is tapped
  /// Provides the full VBubbleMenuItem object for easy handling
  final void Function(String messageId, VBubbleMenuItem item)? onMenuItemTap;

  // ===== TYPE-SPECIFIC CALLBACKS =====

  /// Called when poll option is selected
  final void Function(String messageId, String optionId)? onPollVote;

  /// Called when text expand/collapse is toggled (see more/less)
  final void Function(String messageId, bool isExpanded)? onExpandToggle;

  /// Called when quoted content preview is tapped (stories, products, posts)
  final void Function(String messageId, String? contentId)? onQuotedContentTap;

  // ===== TRANSFER CALLBACKS =====

  /// Called when media transfer action is triggered (download, cancel, retry)
  /// Used by file, image, video, voice bubbles for download state management
  final void Function(String messageId, VMediaTransferAction action)?
      onMediaTransferAction;

  // ===== MEDIA VIEWER CALLBACKS =====

  /// Called when download/save button is tapped in media viewer
  final void Function(String messageId)? onDownload;

  /// Called when share button is tapped in media viewer
  final void Function(String messageId)? onShare;

  const VBubbleCallbacks({
    // Core
    this.onTap,
    this.onLongPress,
    this.onSwipeReply,
    this.onSelect,
    this.onAvatarTap,
    this.onReplyTap,
    // Grouped
    this.onReaction,
    this.onReactionInfoTap,
    this.onPatternTap,
    this.onMediaTap,
    this.onMenuItemTap,
    // Type-specific
    this.onPollVote,
    this.onExpandToggle,
    this.onQuotedContentTap,
    // Transfer
    this.onMediaTransferAction,
    // Media viewer
    this.onDownload,
    this.onShare,
  });

  /// Create a copy with some callbacks replaced
  VBubbleCallbacks copyWith({
    void Function(String messageId)? onTap,
    void Function(String messageId, Offset position)? onLongPress,
    void Function(String messageId)? onSwipeReply,
    void Function(String messageId, bool isSelected)? onSelect,
    void Function(String senderId)? onAvatarTap,
    void Function(String originalMessageId)? onReplyTap,
    void Function(String messageId, String emoji, VReactionAction action)?
        onReaction,
    void Function(String messageId, String emoji, Offset position)?
        onReactionInfoTap,
    void Function(VPatternMatch match)? onPatternTap,
    void Function(VMediaTapData data)? onMediaTap,
    void Function(String messageId, VBubbleMenuItem item)? onMenuItemTap,
    void Function(String messageId, String optionId)? onPollVote,
    void Function(String messageId, bool isExpanded)? onExpandToggle,
    void Function(String messageId, String? contentId)? onQuotedContentTap,
    void Function(String messageId, VMediaTransferAction action)?
        onMediaTransferAction,
    void Function(String messageId)? onDownload,
    void Function(String messageId)? onShare,
  }) {
    return VBubbleCallbacks(
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      onSwipeReply: onSwipeReply ?? this.onSwipeReply,
      onSelect: onSelect ?? this.onSelect,
      onAvatarTap: onAvatarTap ?? this.onAvatarTap,
      onReplyTap: onReplyTap ?? this.onReplyTap,
      onReaction: onReaction ?? this.onReaction,
      onReactionInfoTap: onReactionInfoTap ?? this.onReactionInfoTap,
      onPatternTap: onPatternTap ?? this.onPatternTap,
      onMediaTap: onMediaTap ?? this.onMediaTap,
      onMenuItemTap: onMenuItemTap ?? this.onMenuItemTap,
      onPollVote: onPollVote ?? this.onPollVote,
      onExpandToggle: onExpandToggle ?? this.onExpandToggle,
      onQuotedContentTap: onQuotedContentTap ?? this.onQuotedContentTap,
      onMediaTransferAction:
          onMediaTransferAction ?? this.onMediaTransferAction,
      onDownload: onDownload ?? this.onDownload,
      onShare: onShare ?? this.onShare,
    );
  }

  /// Merge with another callbacks instance, preferring other's non-null values
  VBubbleCallbacks merge(VBubbleCallbacks? other) {
    if (other == null) return this;
    return VBubbleCallbacks(
      onTap: other.onTap ?? onTap,
      onLongPress: other.onLongPress ?? onLongPress,
      onSwipeReply: other.onSwipeReply ?? onSwipeReply,
      onSelect: other.onSelect ?? onSelect,
      onAvatarTap: other.onAvatarTap ?? onAvatarTap,
      onReplyTap: other.onReplyTap ?? onReplyTap,
      onReaction: other.onReaction ?? onReaction,
      onReactionInfoTap: other.onReactionInfoTap ?? onReactionInfoTap,
      onPatternTap: other.onPatternTap ?? onPatternTap,
      onMediaTap: other.onMediaTap ?? onMediaTap,
      onMenuItemTap: other.onMenuItemTap ?? onMenuItemTap,
      onPollVote: other.onPollVote ?? onPollVote,
      onExpandToggle: other.onExpandToggle ?? onExpandToggle,
      onQuotedContentTap: other.onQuotedContentTap ?? onQuotedContentTap,
      onMediaTransferAction:
          other.onMediaTransferAction ?? onMediaTransferAction,
      onDownload: other.onDownload ?? onDownload,
      onShare: other.onShare ?? onShare,
    );
  }

  /// Empty callbacks instance (no-op)
  static const empty = VBubbleCallbacks();
}
