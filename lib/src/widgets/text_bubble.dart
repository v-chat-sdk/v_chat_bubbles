import 'package:flutter/material.dart';

import '../../v_chat_bubbles.dart';
import '../core/constants.dart';

part 'text_bubble_build.dart';
part 'text_bubble_expandable.dart';
part 'text_bubble_parsing.dart';

/// Simple text message bubble
///
/// Renders text content with support for:
/// - Link, email, phone, and mention detection
/// - Expandable text with "See more/less" for long messages
/// - Link preview (optional) with image, title, description
/// - Reply preview, forward header, and sender name (handled by BaseBubble)
class VTextBubble extends BaseBubble {
  /// Message text content
  final String text;

  /// Optional link preview data
  final VLinkPreviewData? linkPreview;

  @override
  String get messageType => 'text message';

  const VTextBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.text,
    this.linkPreview,
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
    final theme = context.bubbleTheme;
    final textColor = selectTextColor(theme);
    final header = buildBubbleHeader(context);
    final showTail = !isSameSender;
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: showTail,
      child: _ExpandableTextWithPreview(
        messageId: messageId,
        text: text,
        linkPreview: linkPreview,
        isMeSender: isMeSender,
        textColor: textColor,
        header: header,
        // Meta values for proper didUpdateWidget comparison
        time: time,
        status: status,
        isEdited: isEdited,
        isPinned: isPinned,
        isStarred: isStarred,
      ),
    );
  }
}
