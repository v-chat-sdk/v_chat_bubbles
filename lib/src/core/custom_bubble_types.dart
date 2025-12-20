import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import 'enums.dart';
import 'models.dart';

/// Base class for custom bubble data
///
/// Users extend this class to define their custom message data types.
/// The [contentType] getter identifies the bubble type for routing.
///
/// Example:
/// ```dart
/// class VReceiptData extends VCustomBubbleData {
///   final String orderId;
///   final double total;
///
///   const VReceiptData({required this.orderId, required this.total});
///
///   @override
///   String get contentType => 'receipt';
/// }
/// ```
@immutable
abstract class VCustomBubbleData {
  /// Content type identifier (e.g., 'receipt', 'product', 'payment')
  ///
  /// This is used to route messages to the correct bubble builder.
  String get contentType;

  const VCustomBubbleData();
}

/// Common properties shared across all bubble types
///
/// Passed to custom bubble builders for convenience.
/// Contains all the standard bubble properties that can be applied to custom content.
@immutable
class CommonBubbleProps {
  /// Message delivery status
  final VMessageStatus status;

  /// Whether this message is from the same sender as the previous message
  final bool isSameSender;

  /// Sender avatar image source
  final VPlatformFile? avatar;

  /// Sender name (for incoming messages in groups)
  final String? senderName;

  /// Sender name color
  final Color? senderColor;

  /// Reply data if this is a reply message
  final VReplyData? replyTo;

  /// Forward data if this is a forwarded message
  final VForwardData? forwardedFrom;

  /// List of reactions on this message
  final List<VBubbleReaction> reactions;

  /// Whether message is edited
  final bool isEdited;

  /// Whether message is pinned
  final bool isPinned;

  /// Whether message is starred
  final bool isStarred;

  /// Whether to show search highlight
  final bool isHighlighted;

  const CommonBubbleProps({
    this.status = VMessageStatus.sent,
    this.isSameSender = false,
    this.avatar,
    this.senderName,
    this.senderColor,
    this.replyTo,
    this.forwardedFrom,
    this.reactions = const [],
    this.isEdited = false,
    this.isPinned = false,
    this.isStarred = false,
    this.isHighlighted = false,
  });

  /// Creates a copy with updated values
  CommonBubbleProps copyWith({
    VMessageStatus? status,
    bool? isSameSender,
    VPlatformFile? avatar,
    String? senderName,
    Color? senderColor,
    VReplyData? replyTo,
    VForwardData? forwardedFrom,
    List<VBubbleReaction>? reactions,
    bool? isEdited,
    bool? isPinned,
    bool? isStarred,
    bool? isHighlighted,
  }) {
    return CommonBubbleProps(
      status: status ?? this.status,
      isSameSender: isSameSender ?? this.isSameSender,
      avatar: avatar ?? this.avatar,
      senderName: senderName ?? this.senderName,
      senderColor: senderColor ?? this.senderColor,
      replyTo: replyTo ?? this.replyTo,
      forwardedFrom: forwardedFrom ?? this.forwardedFrom,
      reactions: reactions ?? this.reactions,
      isEdited: isEdited ?? this.isEdited,
      isPinned: isPinned ?? this.isPinned,
      isStarred: isStarred ?? this.isStarred,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CommonBubbleProps) return false;
    return status == other.status &&
        isSameSender == other.isSameSender &&
        avatar == other.avatar &&
        senderName == other.senderName &&
        senderColor == other.senderColor &&
        replyTo == other.replyTo &&
        forwardedFrom == other.forwardedFrom &&
        isEdited == other.isEdited &&
        isPinned == other.isPinned &&
        isStarred == other.isStarred &&
        isHighlighted == other.isHighlighted;
  }

  @override
  int get hashCode => Object.hash(
        status,
        isSameSender,
        avatar,
        senderName,
        senderColor,
        replyTo,
        forwardedFrom,
        isEdited,
        isPinned,
        isStarred,
        isHighlighted,
      );
}

/// Builder function for custom bubbles
///
/// Called by the registration system to build a custom bubble widget.
///
/// Parameters:
/// - [context]: Build context for accessing theme and config
/// - [messageId]: Unique message identifier
/// - [isMeSender]: Whether sent by current user
/// - [time]: Formatted timestamp string
/// - [data]: Custom data for this bubble type (cast to your specific type)
/// - [props]: Common bubble properties (status, reactions, reply, etc.)
///
/// Example:
/// ```dart
/// final CustomBubbleBuilder receiptBuilder = (
///   context, messageId, isMeSender, time, data, props,
/// ) {
///   return VReceiptBubble(
///     messageId: messageId,
///     isMeSender: isMeSender,
///     time: time,
///     receiptData: data as VReceiptData,
///     status: props.status,
///     isSameSender: props.isSameSender,
///     // ... other props
///   );
/// };
/// ```
typedef CustomBubbleBuilder = Widget Function(
  BuildContext context,
  String messageId,
  bool isMeSender,
  String time,
  VCustomBubbleData data,
  CommonBubbleProps props,
);
