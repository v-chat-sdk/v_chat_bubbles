import 'package:flutter/material.dart';

import '../../core/callbacks.dart';
import '../../core/constants.dart';
import '../../core/models.dart';
import '../../utils/text_parser.dart';
import '../bubble_scope.dart';
import 'unified_image.dart';

class VBubbleHeader extends StatelessWidget {
  final bool isMeSender;
  final VForwardData? forwardedFrom;
  final String? senderName;
  final Color? senderColor;
  final VReplyData? replyTo;
  final VBubbleCallbacks? callbacks;
  final String? messageId;

  const VBubbleHeader({
    super.key,
    required this.isMeSender,
    this.forwardedFrom,
    this.senderName,
    this.senderColor,
    this.replyTo,
    this.callbacks,
    this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    if (forwardedFrom == null && senderName == null && replyTo == null) {
      return const SizedBox.shrink();
    }

    // Determine if we need to show sender name (only for incoming messages)
    final showSenderName = senderName != null && !isMeSender;

    if (!showSenderName && forwardedFrom == null && replyTo == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (forwardedFrom != null) _buildForwardHeader(context),
        if (showSenderName) _buildSenderName(context),
        if (replyTo != null) _buildReplyPreview(context),
      ],
    );
  }

  Widget _buildForwardHeader(BuildContext context) {
    final theme = context.bubbleTheme;
    return Container(
      margin: EdgeInsets.only(bottom: BubbleSpacing.inlineM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.forward,
                  size: BubbleSizes.iconTiny, color: theme.forwardHeaderColor),
              BubbleSpacing.gapS,
              Flexible(
                child: Text(
                  'Forwarded from ${forwardedFrom!.originalSenderName}',
                  style: theme.timeTextStyle.copyWith(
                    color: theme.forwardHeaderColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: VTextParser.getTextDirection(
                      forwardedFrom!.originalSenderName),
                ),
              ),
            ],
          ),
          BubbleSpacing.vGapXS,
          Divider(
            height: 1,
            thickness: 0.5,
            color: theme.forwardHeaderColor
                .withValues(alpha: BubbleOpacity.light2),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderName(BuildContext context) {
    final theme = context.bubbleTheme;
    final nameWidget = Padding(
      padding: EdgeInsets.only(bottom: BubbleSpacing.inlineXS),
      child: Text(
        senderName!,
        style: theme.senderNameStyle.copyWith(
          color: senderColor ?? theme.incomingLinkColor,
        ),
        textDirection: VTextParser.getTextDirection(senderName!),
      ),
    );
    // Make sender name tappable (triggers same action as avatar tap)
    if (callbacks?.onAvatarTap != null && messageId != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => callbacks!.onAvatarTap!(messageId!),
        child: nameWidget,
      );
    }
    return nameWidget;
  }

  Widget _buildReplyPreview(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;

    final replyBarColor =
        isMeSender ? theme.outgoingReplyBarColor : theme.incomingReplyBarColor;
    final replyBackground = isMeSender
        ? theme.outgoingReplyBackgroundColor
        : theme.incomingReplyBackgroundColor;
    final replyTextColor = isMeSender
        ? theme.outgoingReplyTextColor
        : theme.incomingReplyTextColor;
    final replySecondaryTextColor = isMeSender
        ? theme.outgoingSecondaryTextColor
        : theme.incomingSecondaryTextColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () =>
          callbacks?.onReplyPreviewTap?.call(replyTo!.originalMessageId),
      child: Container(
        margin: EdgeInsets.only(bottom: BubbleSpacing.inlineM),
        padding: EdgeInsets.all(BubbleSpacing.inlineM),
        decoration: BoxDecoration(
          color: replyBackground,
          borderRadius: BorderRadius.circular(
            config.spacing.bubbleRadius * 0.4,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: replyBarColor,
                  borderRadius: BubbleRadius.extraSmall,
                ),
              ),
              BubbleSpacing.gapL,
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (replyTo!.previewImage != null) ...[
                      ClipRRect(
                        borderRadius: BubbleRadius.tiny,
                        child: VUnifiedImage(
                          imageSource: replyTo!.previewImage!,
                          width: BubbleSizes.replyPreviewImageSize,
                          height: BubbleSizes.replyPreviewImageSize,
                          fit: BoxFit.cover,
                          shimmerBaseColor: replyBackground,
                          shimmerHighlightColor: replyBackground.withValues(
                            alpha: BubbleOpacity.half,
                          ),
                          fadeInDuration: config.animation.fadeIn,
                          errorWidget: Container(
                            width: BubbleSizes.replyPreviewImageSize,
                            height: BubbleSizes.replyPreviewImageSize,
                            color: replyBackground,
                            child: Icon(
                              Icons.image,
                              size: BubbleSizes.iconMedium,
                              color: replyTextColor,
                            ),
                          ),
                        ),
                      ),
                      BubbleSpacing.gapL,
                    ],
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            replyTo!.senderName,
                            style: theme.timeTextStyle.copyWith(
                              color: replyTo!.senderColor ?? replyTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: VTextParser.getTextDirection(
                                replyTo!.senderName),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            replyTo!.previewText,
                            style: theme.timeTextStyle.copyWith(
                              color: replySecondaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: VTextParser.getTextDirection(
                                replyTo!.previewText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
