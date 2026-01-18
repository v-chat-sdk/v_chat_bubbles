import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/models.dart';
import '../../utils/text_parser.dart';
import '../bubble_scope.dart';
import 'color_selector_mixin.dart';
import 'unified_image.dart';

/// Standalone link preview widget for displaying URL metadata
///
/// Shows site name, title, description, and optional image in a
/// card-like format with a colored left border.
class VLinkPreviewWidget extends StatelessWidget {
  final VLinkPreviewData linkPreview;
  final Color linkColor;
  final Color textColor;
  final bool isMeSender;
  final String messageId;

  const VLinkPreviewWidget({
    super.key,
    required this.linkPreview,
    required this.linkColor,
    required this.textColor,
    required this.isMeSender,
    required this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.bubbleTheme;
    final callbacks = context.bubbleCallbacks;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final replyBarColor = ColorSelectorMixin.getReplyBarColor(theme, isMeSender);
    return GestureDetector(
      onTap: isSelectionMode
          ? null
          : () {
              callbacks.onPatternTap?.call(VPatternMatch(
                patternId: 'url',
                matchedText: linkPreview.url,
                rawText: linkPreview.url,
                messageId: messageId,
              ));
            },
      child: Container(
        padding: const EdgeInsets.only(left: 8, bottom: 8),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: replyBarColor, width: 2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (linkPreview.siteName != null)
              Text(
                linkPreview.siteName!,
                style: theme.timeTextStyle.copyWith(
                  color: linkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (linkPreview.title != null) ...[
              BubbleSpacing.vGapXS,
              Text(
                linkPreview.title!,
                style: theme.messageTextStyle.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: VTextParser.getTextDirection(linkPreview.title!),
              ),
            ],
            if (linkPreview.description != null) ...[
              BubbleSpacing.vGapXS,
              Text(
                linkPreview.description!,
                style: theme.captionTextStyle.copyWith(
                  color: textColor.withValues(alpha: BubbleOpacity.heavy),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textDirection:
                    VTextParser.getTextDirection(linkPreview.description!),
              ),
            ],
            if (linkPreview.image != null) ...[
              BubbleSpacing.gapM,
              ClipRRect(
                borderRadius: BubbleRadius.small,
                child: VUnifiedImage(
                  imageSource: linkPreview.image!,
                  height: BubbleSizes.mediaHeightMedium,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 250),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
