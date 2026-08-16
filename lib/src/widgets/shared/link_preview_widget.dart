import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/enums.dart';
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
    final replyBarColor =
        linkPreview.accentColor ??
        ColorSelectorMixin.getReplyBarColor(theme, isMeSender);
    return GestureDetector(
      onTap: isSelectionMode
          ? null
          : () {
              callbacks.onPatternTap?.call(
                VPatternMatch(
                  patternId: 'url',
                  matchedText: linkPreview.url,
                  rawText: linkPreview.url,
                  messageId: messageId,
                ),
              );
            },
      child: Container(
        key: ValueKey('v-link-preview-${linkPreview.layout.name}'),
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: replyBarColor, width: 2)),
        ),
        child: _buildLayout(context),
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    switch (linkPreview.layout) {
      case VLinkPreviewLayout.compact:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (linkPreview.favicon != null) ...[
              VUnifiedImage(
                imageSource: linkPreview.favicon!,
                width: 24,
                height: 24,
                borderRadius: BubbleRadius.tiny,
              ),
              BubbleSpacing.gapM,
            ],
            Expanded(child: _buildMetadata(context, maxDescriptionLines: 1)),
          ],
        );
      case VLinkPreviewLayout.sideMedia:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildMetadata(context, maxDescriptionLines: 2)),
            if (linkPreview.image != null) ...[
              BubbleSpacing.gapM,
              _buildMedia(width: 76, height: 76),
            ],
          ],
        );
      case VLinkPreviewLayout.largeMedia:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMetadata(context, maxDescriptionLines: 3),
            if (linkPreview.image != null) ...[
              BubbleSpacing.vGapM,
              _buildMedia(height: BubbleSizes.mediaHeightMedium),
            ],
          ],
        );
    }
  }

  Widget _buildMetadata(
    BuildContext context, {
    required int maxDescriptionLines,
  }) {
    final theme = context.bubbleTheme;
    final siteLabel = linkPreview.siteName ?? linkPreview.displayUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (siteLabel != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (linkPreview.favicon != null &&
                  linkPreview.layout != VLinkPreviewLayout.compact) ...[
                VUnifiedImage(
                  imageSource: linkPreview.favicon!,
                  width: 16,
                  height: 16,
                  borderRadius: BubbleRadius.tiny,
                ),
                BubbleSpacing.gapS,
              ],
              Flexible(
                child: Text(
                  siteLabel,
                  style: theme.timeTextStyle.copyWith(
                    color: linkColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (linkPreview.isVerified) ...[
                BubbleSpacing.gapXS,
                Icon(
                  Icons.verified_rounded,
                  size: BubbleSizes.iconTiny,
                  color: linkColor,
                ),
              ],
            ],
          ),
        if (linkPreview.authorName != null) ...[
          BubbleSpacing.vGapXS,
          Text(
            linkPreview.authorName!,
            style: theme.timeTextStyle.copyWith(
              color: textColor.withValues(alpha: 0.72),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
            maxLines: maxDescriptionLines,
            overflow: TextOverflow.ellipsis,
            textDirection: VTextParser.getTextDirection(
              linkPreview.description!,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMedia({double? width, required double height}) {
    return ClipRRect(
      borderRadius: BubbleRadius.small,
      child: Stack(
        children: [
          VUnifiedImage(
            imageSource: linkPreview.image!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 250),
          ),
          if (linkPreview.mediaDuration != null)
            PositionedDirectional(
              end: 6,
              bottom: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BubbleRadius.chip,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Text(
                    _formatDuration(linkPreview.mediaDuration!),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
