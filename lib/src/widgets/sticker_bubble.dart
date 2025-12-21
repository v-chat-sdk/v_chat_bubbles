import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';
import '../core/constants.dart';
import '../core/models.dart';
import '../utils/platform_image_builder.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';
import 'shared/media_error_placeholder.dart';
import 'shared/message_status_icon.dart';
import 'shared/shimmer_loading.dart';

/// Sticker message bubble (no bubble background)
///
/// Stickers are displayed without the bubble shape wrapper,
/// showing just the sticker image with a small time chip below.
///
/// Supports multiple image sources via VPlatformFile:
/// - Network URLs
/// - Local file paths
/// - Asset paths
/// - Byte arrays
///
/// Features:
/// - Smooth fade-in animation
/// - Shimmer loading placeholder
/// - Memory-optimized rendering
class VStickerBubble extends BaseBubble {
  /// Platform file containing the sticker image
  final VPlatformFile stickerFile;
  @override
  String get messageType => 'sticker';

  /// Sticker size
  final double size;

  const VStickerBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.stickerFile,
    this.size = 160,
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
    final header = buildBubbleHeader(context);
    // Sticker normally doesn't use VBubbleWrapper - no background
    final stickerContent = Column(
      crossAxisAlignment:
          isMeSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStickerImage(context),
        BubbleSpacing.vGapS,
        _buildTimeChip(context),
      ],
    );
    if (header == null) return stickerContent;
    // When there's a header (reply/forward), show it in a bubble above the sticker
    return Column(
      crossAxisAlignment:
          isMeSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        VBubbleWrapper(
          isMeSender: isMeSender,
          showTail: false,
          child: header,
        ),
        BubbleSpacing.vGapS,
        stickerContent,
      ],
    );
  }

  Widget _buildStickerImage(BuildContext context) {
    final callbacks = context.bubbleCallbacks;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final shimmerBase = theme.systemMessageBackground.withValues(alpha: 0.3);
    final shimmerHighlight =
        theme.systemMessageBackground.withValues(alpha: 0.1);
    return GestureDetector(
      onTap: isSelectionMode
          ? null
          : () =>
              callbacks.onMediaTap?.call(VMediaTapData(messageId: messageId)),
      child: SizedBox(
        width: size,
        height: size,
        child: VPlatformImageBuilder.build(
          stickerFile,
          fit: BoxFit.contain,
          config: const VImageRenderConfig(
            filterQuality: FilterQuality.high,
            fadeInDuration: Duration(milliseconds: 200),
          ),
          cacheNetworkImages: config.media.cacheNetworkImages,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return VShimmerLoading(
              width: size,
              height: size,
              baseColor: shimmerBase,
              highlightColor: shimmerHighlight,
              borderRadius: BubbleRadius.chip,
              child: Icon(Icons.emoji_emotions,
                  size: BubbleSizes.iconXXL, color: Colors.white38),
            );
          },
          errorBuilder: (context, error, stack) =>
              const VMediaErrorPlaceholder.sticker(),
        ),
      ),
    );
  }

  Widget _buildTimeChip(BuildContext context) {
    final theme = context.bubbleTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.systemMessageBackground,
        borderRadius: BubbleRadius.standard,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time,
            style: theme.timeTextStyle.copyWith(color: Colors.white),
          ),
          if (isMeSender) ...[
            BubbleSpacing.gapS,
            _buildStatusIcon(context),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    final theme = context.bubbleTheme;
    return VMessageStatusIcon(
      status: status,
      color: Colors.white,
      size: BubbleSizes.iconSmall,
      readColor: theme.readIconColor,
    );
  }
}
