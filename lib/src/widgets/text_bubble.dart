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

  /// Optional translated-text state rendered below the original message.
  final VMessageTranslationData? translation;

  @override
  String get messageType => 'text message';

  const VTextBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.text,
    this.linkPreview,
    this.translation,
    super.status,
    super.isSameSender,
    super.groupPosition,
    super.avatar,
    super.senderName,
    super.senderColor,
    super.replyTo,
    super.forwardedFrom,
    super.reactions,
    super.isEdited,
    super.lifecycle,
    super.isPinned,
    super.isStarred,
    super.isHighlighted,
    super.searchQuery,
    super.searchHighlightStyle,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = context.bubbleTheme;
    final textColor = selectTextColor(theme);
    final header = buildBubbleHeader(context);
    final showTail = effectiveShowTail(context);
    final String? query = searchQuery;
    final TextStyle highlightStyle =
        searchHighlightStyle ?? theme.searchHighlightStyle;
    final textContent = _ExpandableTextWithPreview(
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
      lifecycle: lifecycle,
      isPinned: isPinned,
      isStarred: isStarred,
      searchQuery: query,
      searchHighlightStyle: highlightStyle,
    );
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: showTail,
      child: translation == null
          ? textContent
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                textContent,
                VTranslatedTextPanel(
                  messageId: messageId,
                  translation: translation!,
                  textColor: textColor,
                ),
              ],
            ),
    );
  }
}
