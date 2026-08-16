import 'package:flutter/material.dart';
import 'enums.dart';
import 'models.dart';
import 'modern_message_models.dart';

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

  /// Called when a failed lifecycle entry requests another send attempt.
  final void Function(String messageId)? onRetryMessage;

  /// Called when selection state changes
  final void Function(String messageId, bool isSelected)? onSelectionChanged;

  /// Called when avatar is tapped
  final void Function(String senderId)? onAvatarTap;

  /// Called when reply preview is tapped (jump to original)
  final void Function(String originalMessageId)? onReplyPreviewTap;

  /// Called when a thread summary is opened.
  final void Function(String threadId)? onThreadTap;

  // ===== GROUPED CALLBACKS =====

  /// Called for reaction actions (add/remove) - typically from context menu
  final void Function(String messageId, String emoji, VReactionAction action)?
  onReaction;

  /// Called when a reaction pill is tapped on the bubble
  /// Use this to show who reacted with this emoji (e.g., display a popup)
  final void Function(String messageId, String emoji, Offset position)?
  onReactionTap;

  /// Called with actor details when a rendered reaction pill is opened.
  final void Function(
    String messageId,
    VBubbleReaction reaction,
    Offset position,
  )?
  onReactionDetailsTap;

  /// Called when the "+" button is tapped to show more reactions
  /// Use this to display a full emoji picker for the user to choose from
  final void Function(String messageId)? onMoreReactions;

  /// Called for any pattern tap (supports custom patterns)
  final void Function(VPatternMatch match)? onPatternTap;

  /// Called when media is tapped (images, videos, galleries)
  final void Function(VMediaTapData data)? onMediaTap;

  /// Called when custom menu item is tapped
  /// Provides the full VBubbleMenuItem object for easy handling
  final void Function(String messageId, VBubbleMenuItem item)?
  onMenuItemSelected;

  // ===== TYPE-SPECIFIC CALLBACKS =====

  /// Called when poll option is selected
  final void Function(String messageId, String optionId)? onPollVote;

  /// Called when text expand/collapse is toggled (see more/less)
  final void Function(String messageId, bool isExpanded)? onExpandToggle;

  /// Called when quoted content preview is tapped (stories, products, posts)
  final void Function(String messageId, String? contentId)? onQuotedContentTap;

  /// Called when translated text is shown or the original is restored.
  final void Function(String messageId, bool showTranslation)?
  onTranslationToggle;

  /// Called when a failed translation should be attempted again.
  final void Function(String messageId)? onTranslationRetry;

  /// Called when a voice transcript is expanded or collapsed.
  final void Function(String messageId, bool isExpanded)? onTranscriptToggle;

  /// Called when a failed transcript should be attempted again.
  final void Function(String messageId)? onTranscriptRetry;

  /// Called when a time-aligned transcript segment is selected.
  final void Function(String messageId, Duration start)? onTranscriptSegmentTap;

  /// Called when a GIF or animated sticker changes local playback state.
  final void Function(String messageId, bool isPlaying)?
  onAnimatedMediaPlaybackChanged;

  /// Called when the user adds media to a shared collection.
  final void Function(String messageId, String collectionId)?
  onMediaCollectionAdd;

  /// Called when a collaborative checklist item changes state.
  final void Function(String messageId, String itemId, bool isCompleted)?
  onChecklistItemToggle;

  /// Called when the add-item affordance is selected.
  final void Function(String messageId)? onChecklistAddItem;

  /// Called when the current user's event response changes.
  final void Function(String messageId, VEventResponse response)?
  onEventResponse;

  /// Called when the event details should be opened.
  final void Function(String messageId, String eventId)? onEventOpen;

  /// Called when a live-location session should be opened.
  final void Function(String messageId, String sessionId)? onLiveLocationTap;

  // ===== TRANSFER CALLBACKS =====

  /// Called when media transfer action is triggered (download, cancel, retry)
  /// Used by file, image, video, voice bubbles for download state management
  final void Function(String messageId, VMediaTransferAction action)?
  onTransferStateChanged;

  /// Called when spoiler, view-once, or expiring content is revealed.
  final void Function(String messageId, VContentProtectionData protection)?
  onProtectedContentReveal;

  /// Called when protected content becomes unavailable while mounted.
  final void Function(String messageId, VContentProtectionData protection)?
  onProtectedContentExpired;

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
    this.onRetryMessage,
    this.onSelectionChanged,
    this.onAvatarTap,
    this.onReplyPreviewTap,
    this.onThreadTap,
    // Grouped
    this.onReaction,
    this.onReactionTap,
    this.onReactionDetailsTap,
    this.onMoreReactions,
    this.onPatternTap,
    this.onMediaTap,
    this.onMenuItemSelected,
    // Type-specific
    this.onPollVote,
    this.onExpandToggle,
    this.onQuotedContentTap,
    this.onTranslationToggle,
    this.onTranslationRetry,
    this.onTranscriptToggle,
    this.onTranscriptRetry,
    this.onTranscriptSegmentTap,
    this.onAnimatedMediaPlaybackChanged,
    this.onMediaCollectionAdd,
    this.onChecklistItemToggle,
    this.onChecklistAddItem,
    this.onEventResponse,
    this.onEventOpen,
    this.onLiveLocationTap,
    // Transfer
    this.onTransferStateChanged,
    this.onProtectedContentReveal,
    this.onProtectedContentExpired,
    // Media viewer
    this.onDownload,
    this.onShare,
  });

  /// Create a copy with some callbacks replaced
  VBubbleCallbacks copyWith({
    void Function(String messageId)? onTap,
    void Function(String messageId, Offset position)? onLongPress,
    void Function(String messageId)? onSwipeReply,
    void Function(String messageId)? onRetryMessage,
    void Function(String messageId, bool isSelected)? onSelectionChanged,
    void Function(String senderId)? onAvatarTap,
    void Function(String originalMessageId)? onReplyPreviewTap,
    void Function(String threadId)? onThreadTap,
    void Function(String messageId, String emoji, VReactionAction action)?
    onReaction,
    void Function(String messageId, String emoji, Offset position)?
    onReactionTap,
    void Function(String messageId, VBubbleReaction reaction, Offset position)?
    onReactionDetailsTap,
    void Function(String messageId)? onMoreReactions,
    void Function(VPatternMatch match)? onPatternTap,
    void Function(VMediaTapData data)? onMediaTap,
    void Function(String messageId, VBubbleMenuItem item)? onMenuItemSelected,
    void Function(String messageId, String optionId)? onPollVote,
    void Function(String messageId, bool isExpanded)? onExpandToggle,
    void Function(String messageId, String? contentId)? onQuotedContentTap,
    void Function(String messageId, bool showTranslation)? onTranslationToggle,
    void Function(String messageId)? onTranslationRetry,
    void Function(String messageId, bool isExpanded)? onTranscriptToggle,
    void Function(String messageId)? onTranscriptRetry,
    void Function(String messageId, Duration start)? onTranscriptSegmentTap,
    void Function(String messageId, bool isPlaying)?
    onAnimatedMediaPlaybackChanged,
    void Function(String messageId, String collectionId)? onMediaCollectionAdd,
    void Function(String messageId, String itemId, bool isCompleted)?
    onChecklistItemToggle,
    void Function(String messageId)? onChecklistAddItem,
    void Function(String messageId, VEventResponse response)? onEventResponse,
    void Function(String messageId, String eventId)? onEventOpen,
    void Function(String messageId, String sessionId)? onLiveLocationTap,
    void Function(String messageId, VMediaTransferAction action)?
    onTransferStateChanged,
    void Function(String messageId, VContentProtectionData protection)?
    onProtectedContentReveal,
    void Function(String messageId, VContentProtectionData protection)?
    onProtectedContentExpired,
    void Function(String messageId)? onDownload,
    void Function(String messageId)? onShare,
  }) {
    return VBubbleCallbacks(
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      onSwipeReply: onSwipeReply ?? this.onSwipeReply,
      onRetryMessage: onRetryMessage ?? this.onRetryMessage,
      onSelectionChanged: onSelectionChanged ?? this.onSelectionChanged,
      onAvatarTap: onAvatarTap ?? this.onAvatarTap,
      onReplyPreviewTap: onReplyPreviewTap ?? this.onReplyPreviewTap,
      onThreadTap: onThreadTap ?? this.onThreadTap,
      onReaction: onReaction ?? this.onReaction,
      onReactionTap: onReactionTap ?? this.onReactionTap,
      onReactionDetailsTap: onReactionDetailsTap ?? this.onReactionDetailsTap,
      onMoreReactions: onMoreReactions ?? this.onMoreReactions,
      onPatternTap: onPatternTap ?? this.onPatternTap,
      onMediaTap: onMediaTap ?? this.onMediaTap,
      onMenuItemSelected: onMenuItemSelected ?? this.onMenuItemSelected,
      onPollVote: onPollVote ?? this.onPollVote,
      onExpandToggle: onExpandToggle ?? this.onExpandToggle,
      onQuotedContentTap: onQuotedContentTap ?? this.onQuotedContentTap,
      onTranslationToggle: onTranslationToggle ?? this.onTranslationToggle,
      onTranslationRetry: onTranslationRetry ?? this.onTranslationRetry,
      onTranscriptToggle: onTranscriptToggle ?? this.onTranscriptToggle,
      onTranscriptRetry: onTranscriptRetry ?? this.onTranscriptRetry,
      onTranscriptSegmentTap:
          onTranscriptSegmentTap ?? this.onTranscriptSegmentTap,
      onAnimatedMediaPlaybackChanged:
          onAnimatedMediaPlaybackChanged ?? this.onAnimatedMediaPlaybackChanged,
      onMediaCollectionAdd: onMediaCollectionAdd ?? this.onMediaCollectionAdd,
      onChecklistItemToggle:
          onChecklistItemToggle ?? this.onChecklistItemToggle,
      onChecklistAddItem: onChecklistAddItem ?? this.onChecklistAddItem,
      onEventResponse: onEventResponse ?? this.onEventResponse,
      onEventOpen: onEventOpen ?? this.onEventOpen,
      onLiveLocationTap: onLiveLocationTap ?? this.onLiveLocationTap,
      onTransferStateChanged:
          onTransferStateChanged ?? this.onTransferStateChanged,
      onProtectedContentReveal:
          onProtectedContentReveal ?? this.onProtectedContentReveal,
      onProtectedContentExpired:
          onProtectedContentExpired ?? this.onProtectedContentExpired,
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
      onRetryMessage: other.onRetryMessage ?? onRetryMessage,
      onSelectionChanged: other.onSelectionChanged ?? onSelectionChanged,
      onAvatarTap: other.onAvatarTap ?? onAvatarTap,
      onReplyPreviewTap: other.onReplyPreviewTap ?? onReplyPreviewTap,
      onThreadTap: other.onThreadTap ?? onThreadTap,
      onReaction: other.onReaction ?? onReaction,
      onReactionTap: other.onReactionTap ?? onReactionTap,
      onReactionDetailsTap: other.onReactionDetailsTap ?? onReactionDetailsTap,
      onMoreReactions: other.onMoreReactions ?? onMoreReactions,
      onPatternTap: other.onPatternTap ?? onPatternTap,
      onMediaTap: other.onMediaTap ?? onMediaTap,
      onMenuItemSelected: other.onMenuItemSelected ?? onMenuItemSelected,
      onPollVote: other.onPollVote ?? onPollVote,
      onExpandToggle: other.onExpandToggle ?? onExpandToggle,
      onQuotedContentTap: other.onQuotedContentTap ?? onQuotedContentTap,
      onTranslationToggle: other.onTranslationToggle ?? onTranslationToggle,
      onTranslationRetry: other.onTranslationRetry ?? onTranslationRetry,
      onTranscriptToggle: other.onTranscriptToggle ?? onTranscriptToggle,
      onTranscriptRetry: other.onTranscriptRetry ?? onTranscriptRetry,
      onTranscriptSegmentTap:
          other.onTranscriptSegmentTap ?? onTranscriptSegmentTap,
      onAnimatedMediaPlaybackChanged:
          other.onAnimatedMediaPlaybackChanged ??
          onAnimatedMediaPlaybackChanged,
      onMediaCollectionAdd: other.onMediaCollectionAdd ?? onMediaCollectionAdd,
      onChecklistItemToggle:
          other.onChecklistItemToggle ?? onChecklistItemToggle,
      onChecklistAddItem: other.onChecklistAddItem ?? onChecklistAddItem,
      onEventResponse: other.onEventResponse ?? onEventResponse,
      onEventOpen: other.onEventOpen ?? onEventOpen,
      onLiveLocationTap: other.onLiveLocationTap ?? onLiveLocationTap,
      onTransferStateChanged:
          other.onTransferStateChanged ?? onTransferStateChanged,
      onProtectedContentReveal:
          other.onProtectedContentReveal ?? onProtectedContentReveal,
      onProtectedContentExpired:
          other.onProtectedContentExpired ?? onProtectedContentExpired,
      onDownload: other.onDownload ?? onDownload,
      onShare: other.onShare ?? onShare,
    );
  }

  /// Empty callbacks instance (no-op)
  static const empty = VBubbleCallbacks();
}
