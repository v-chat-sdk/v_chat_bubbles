import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import '../core/constants.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';
import 'shared/animated_media_surface.dart';

/// Dedicated GIF message with reduced-motion and manual playback support.
class VGifBubble extends BaseBubble {
  final VPlatformFile gifFile;
  final VPlatformFile? previewFile;
  final String? caption;
  final double width;
  final double height;
  final bool autoplay;

  @override
  String get messageType => 'gif';

  const VGifBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.gifFile,
    this.previewFile,
    this.caption,
    this.width = 260,
    this.height = 220,
    this.autoplay = true,
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
  });

  @override
  Widget buildContent(BuildContext context) {
    final header = buildBubbleHeader(context);
    final theme = context.bubbleTheme;
    final textColor = selectTextColor(theme);
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: showsGroupEnd,
      padding: EdgeInsets.zero,
      clipContent: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null)
            Padding(padding: const EdgeInsets.all(8), child: header),
          Stack(
            children: [
              VAnimatedMediaSurface(
                messageId: messageId,
                animatedFile: gifFile,
                previewFile: previewFile,
                width: width,
                height: height,
                fit: BoxFit.cover,
                autoplay: autoplay,
                onPlaybackChanged: (isPlaying) => context
                    .bubbleCallbacks
                    .onAnimatedMediaPlaybackChanged
                    ?.call(messageId, isPlaying),
              ),
              PositionedDirectional(
                top: 8,
                start: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BubbleRadius.chip,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    child: Text(
                      'GIF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (caption != null) ...[
                  Flexible(
                    child: Text(
                      caption!,
                      style: theme.captionTextStyle.copyWith(color: textColor),
                    ),
                  ),
                  BubbleSpacing.gapM,
                ],
                buildMeta(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
