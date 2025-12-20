import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/models.dart';
import '../utils/text_parser.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';
import 'shared/unified_image.dart';

/// Quoted content bubble for sharing external content (stories, products, posts)
///
/// Displays a preview of external content with optional reply text.
/// Layout: left thumbnail with title/subtitle, optional parsed text below.
///
/// Example:
/// ```dart
/// VQuotedContentBubble(
///   messageId: 'msg_789',
///   isMeSender: false,
///   time: '2:45 PM',
///   contentData: QuotedContentData(
///     title: 'Summer Collection 2024',
///     subtitle: 'Shop Now',
///     image: VPlatformFile.fromUrl(networkUrl: '...'),
///     contentId: 'story_12345',
///   ),
///   text: 'Check this out!',
/// )
/// ```
class VQuotedContentBubble extends BaseBubble {
  /// Quoted content data (title, subtitle, image, contentId, extraData)
  final QuotedContentData contentData;

  /// Optional message text with pattern parsing support
  final String? text;
  @override
  String get messageType => 'quoted_content';
  const VQuotedContentBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.contentData,
    this.text,
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
    final config = context.bubbleConfig;
    final header = buildBubbleHeader(context);
    final showTail = !isSameSender;
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: showTail,
      child: SizedBox(
        width: config.media.fileMessageWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null) header,
            _buildContentPreview(context),
            if (text != null && text!.isNotEmpty) ...[
              BubbleSpacing.vGapM,
              _buildParsedText(context),
            ],
            BubbleSpacing.vGapXS,
            buildMeta(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPreview(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleContentTap(context),
      child: Row(
        children: [
          _buildThumbnail(context),
          BubbleSpacing.gapXL,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (contentData.title != null) _buildTitle(context),
                if (contentData.title != null && contentData.subtitle != null)
                  BubbleSpacing.vGapXS,
                if (contentData.subtitle != null) _buildSubtitle(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    final theme = context.bubbleTheme;
    const size = 56.0;
    if (contentData.image != null) {
      return ClipRRect(
        borderRadius: BubbleRadius.small,
        child: VUnifiedImage(
          imageSource: contentData.image!,
          height: size,
          width: size,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 250),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selectSecondaryTextColor(theme)
            .withValues(alpha: BubbleOpacity.light),
        borderRadius: BubbleRadius.small,
      ),
      child: Icon(
        Icons.image_outlined,
        color: selectSecondaryTextColor(theme),
        size: BubbleSizes.iconMedium,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = context.bubbleTheme;
    final textColor = selectTextColor(theme);
    final direction = VTextParser.getTextDirection(contentData.title!);
    return Text(
      contentData.title!,
      style: theme.messageTextStyle.copyWith(
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textDirection: direction,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final theme = context.bubbleTheme;
    final secondaryColor = selectSecondaryTextColor(theme);
    final direction = VTextParser.getTextDirection(contentData.subtitle!);
    return Text(
      contentData.subtitle!,
      style: theme.timeTextStyle.copyWith(color: secondaryColor),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textDirection: direction,
    );
  }

  Widget _buildParsedText(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final callbacks = context.bubbleCallbacks;
    final textColor = selectTextColor(theme);
    final linkColor =
        isMeSender ? theme.outgoingLinkColor : theme.incomingLinkColor;
    final baseStyle = theme.messageTextStyle.copyWith(color: textColor);
    final linkStyle = theme.linkTextStyle.copyWith(color: linkColor);
    final mentionStyle = theme.messageTextStyle.copyWith(
      color: linkColor,
      fontWeight: FontWeight.w600,
    );
    final patterns = config.patterns.buildPatterns(
      baseStyle: baseStyle,
      linkStyle: linkStyle,
      mentionStyle: mentionStyle,
    );
    final spans = VTextParser.parseWithPatterns(
      text!,
      baseStyle: baseStyle,
      patterns: patterns,
      onPatternTap: callbacks.onPatternTap,
      messageId: messageId,
    );
    return RichText(text: TextSpan(children: spans));
  }

  void _handleContentTap(BuildContext context) {
    final scope = context.bubbleScope;
    final callbacks = context.bubbleCallbacks;
    if (scope.isSelectionMode) return;
    callbacks.onQuotedContentTap?.call(messageId, contentData.contentId);
  }
}
