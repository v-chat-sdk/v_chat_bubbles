import 'package:flutter/material.dart';

import '../core/custom_bubble_types.dart';
import 'base_bubble.dart';

/// Generic custom bubble widget that extends BaseBubble
///
/// Provides all standard bubble features while allowing custom content.
/// Users implement the content builder for their specific data type.
///
/// This widget provides two usage modes:
///
/// **Mode 1: With VBubbleWrapper (default)**
/// Content is wrapped in a styled bubble with tail, background, and padding.
/// ```dart
/// VCustomBubble<PaymentData>(
///   messageId: 'msg_123',
///   isMeSender: true,
///   time: '12:30',
///   data: PaymentData(amount: 50.0, currency: 'USD'),
///   builder: (context, data) {
///     return Row(
///       children: [
///         Icon(Icons.payment, color: Colors.green),
///         Text('\$${data.amount} ${data.currency}'),
///       ],
///     );
///   },
/// )
/// ```
///
/// **Mode 2: Without VBubbleWrapper**
/// Full control over bubble styling. Set `useBubbleWrapper: false`.
/// ```dart
/// VCustomBubble<CustomData>(
///   messageId: 'msg_123',
///   isMeSender: true,
///   time: '12:30',
///   data: CustomData(...),
///   useBubbleWrapper: false,
///   builder: (context, data) {
///     // Complete custom rendering
///     return MyCustomWidget(data: data);
///   },
/// )
/// ```
///
/// **Using Helper Methods**
/// Inside the builder, access theme and use helper widgets:
/// ```dart
/// builder: (context, data) {
///   final theme = context.bubbleTheme;
///   final textColor = isMeSender
///       ? theme.outgoingTextColor
///       : theme.incomingTextColor;
///   return Text(data.title, style: TextStyle(color: textColor));
/// },
/// ```
class VCustomBubble<T extends VCustomBubbleData> extends BaseBubble {
  /// Custom data for this bubble
  final T data;

  /// Content type identifier (defaults to data.contentType)
  ///
  /// Override this to use a different content type than the data provides.
  final String? contentTypeOverride;

  /// Builder for custom content
  ///
  /// Receives context and typed data, returns the content widget.
  /// The widget returned will be placed inside the bubble.
  final Widget Function(BuildContext context, T data) builder;

  /// Whether to wrap content in VBubbleWrapper
  ///
  /// Set to false if you want full control over bubble styling.
  /// When false, only the builder's widget is rendered without
  /// the standard bubble background, tail, and padding.
  final bool useBubbleWrapper;

  /// Custom padding when using bubble wrapper
  ///
  /// Only applies when [useBubbleWrapper] is true.
  final EdgeInsetsGeometry? padding;

  /// Whether to show the header (forward, sender name, reply preview)
  ///
  /// Set to false to hide the header even if data exists.
  final bool showHeader;

  /// Whether to show the metadata (timestamp, status, flags)
  ///
  /// Set to false to hide the metadata row.
  final bool showMeta;

  @override
  String get messageType => contentTypeOverride ?? data.contentType;

  const VCustomBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.data,
    required this.builder,
    this.contentTypeOverride,
    this.useBubbleWrapper = true,
    this.padding,
    this.showHeader = true,
    this.showMeta = true,
    super.status,
    super.isSameSender,
    super.avatar,
    super.senderName,
    super.senderColor,
    super.replyTo,
    super.forwardedFrom,
    super.reactions,
    super.isEdited,
    super.isPinned,
    super.isStarred,
    super.isHighlighted,
  });

  @override
  Widget buildContent(BuildContext context) {
    final customContent = builder(context, data);
    if (!useBubbleWrapper) {
      return customContent;
    }
    final header = showHeader ? buildBubbleHeader(context) : null;
    return buildBubbleContainer(
      context: context,
      showTail: !isSameSender,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header,
          customContent,
          if (showMeta) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: buildMeta(context),
            ),
          ],
        ],
      ),
    );
  }

  /// Create CommonBubbleProps from this bubble's properties
  ///
  /// Useful when you need to pass bubble props to another widget.
  CommonBubbleProps toCommonProps() {
    return CommonBubbleProps(
      status: status,
      isSameSender: isSameSender,
      avatar: avatar,
      senderName: senderName,
      senderColor: senderColor,
      replyTo: replyTo,
      forwardedFrom: forwardedFrom,
      reactions: reactions,
      isEdited: isEdited,
      isPinned: isPinned,
      isStarred: isStarred,
      isHighlighted: isHighlighted,
    );
  }
}

/// Extension to easily create VCustomBubble from CommonBubbleProps
extension CustomBubblePropsExtension on CommonBubbleProps {
  /// Apply these props to create a VCustomBubble
  VCustomBubble<T> toCustomBubble<T extends VCustomBubbleData>({
    required String messageId,
    required bool isMeSender,
    required String time,
    required T data,
    required Widget Function(BuildContext context, T data) builder,
    String? contentTypeOverride,
    bool useBubbleWrapper = true,
    EdgeInsetsGeometry? padding,
    bool showHeader = true,
    bool showMeta = true,
  }) {
    return VCustomBubble<T>(
      messageId: messageId,
      isMeSender: isMeSender,
      time: time,
      data: data,
      builder: builder,
      contentTypeOverride: contentTypeOverride,
      useBubbleWrapper: useBubbleWrapper,
      padding: padding,
      showHeader: showHeader,
      showMeta: showMeta,
      status: status,
      isSameSender: isSameSender,
      avatar: avatar,
      senderName: senderName,
      senderColor: senderColor,
      replyTo: replyTo,
      forwardedFrom: forwardedFrom,
      reactions: reactions,
      isEdited: isEdited,
      isPinned: isPinned,
      isStarred: isStarred,
      isHighlighted: isHighlighted,
    );
  }
}
