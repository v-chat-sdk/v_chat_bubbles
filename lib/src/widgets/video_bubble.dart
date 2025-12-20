import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';
import '../core/constants.dart';
import '../core/enums.dart';
import '../core/models.dart';
import '../utils/format_utils.dart';
import '../utils/platform_image_builder.dart';
import '../utils/shimmer_helper.dart';
import '../viewers/media_viewer_route.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';
import 'shared/media_container.dart';
import 'shared/media_error_placeholder.dart';
import 'shared/media_overlay_info.dart';
import 'shared/shimmer_loading.dart';
import 'shared/transfer_overlay.dart';

/// Video message bubble with thumbnail and play button
///
/// Supports multiple file sources via VPlatformFile:
/// - Network URLs
/// - Local file paths
/// - Asset paths
/// - Byte arrays
///
/// Features:
/// - Smooth fade-in animation for thumbnail
/// - Shimmer loading placeholder
/// - Memory-optimized thumbnail rendering
/// - Transfer progress overlay
/// - Duration badge
class VVideoBubble extends BaseBubble {
  /// Platform file containing the video file
  final VPlatformFile videoFile;

  /// Platform file containing the video thumbnail (optional)
  /// If not provided, a placeholder will be shown
  final VPlatformFile? thumbnailFile;
  @override
  String get messageType => 'video';

  /// Video duration
  final Duration duration;

  /// Optional caption
  final String? caption;

  /// Video aspect ratio
  final double? aspectRatio;

  /// Transfer state
  final VTransferState transferState;

  /// Upload/download progress
  final double? progress;

  const VVideoBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.videoFile,
    this.thumbnailFile,
    required this.duration,
    this.caption,
    this.aspectRatio,
    this.transferState = VTransferState.completed,
    this.progress,
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
    final hasHeader = header != null;
    final mediaContent = VMediaContainer(
      messageId: messageId,
      maxHeight: config.media.videoMaxHeight,
      fillBubble: hasHeader, // Fill edge-to-edge when inside bubble wrapper
      child: Stack(
        children: [
          _buildThumbnail(context),
          _buildPlayButton(context),
          if (transferState != VTransferState.completed)
            _buildTransferOverlay(context),
          _buildOverlayInfo(context),
          Positioned(
            top: 8,
            left: 8,
            child: _buildDurationBadge(context),
          ),
        ],
      ),
    );
    if (!hasHeader) return mediaContent;
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: !isSameSender,
      padding: EdgeInsets.zero,
      clipContent: true, // Clip content to bubble shape
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: header,
          ),
          mediaContent,
        ],
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    final theme = context.bubbleTheme;
    final shimmerColors = VShimmerHelper.getShimmerColors(theme, isMeSender);
    // If no thumbnail, show placeholder
    if (thumbnailFile == null) {
      final placeholder = Container(
        height: 200,
        color: shimmerColors.base,
        child: Center(
          child: Icon(Icons.videocam,
              color: Colors.white54, size: BubbleSizes.iconHuge),
        ),
      );
      if (aspectRatio != null) {
        return AspectRatio(aspectRatio: aspectRatio!, child: placeholder);
      }
      return placeholder;
    }
    final imageWidget = VPlatformImageBuilder.build(
      thumbnailFile!,
      fit: BoxFit.cover,
      config: VImageRenderConfig.thumbnail,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return VShimmerLoading.video(
          height: 200,
          baseColor: shimmerColors.base,
          highlightColor: shimmerColors.highlight,
        );
      },
      errorBuilder: (context, error, stack) =>
          const VMediaErrorPlaceholder.video(),
    );
    if (aspectRatio != null) {
      return AspectRatio(aspectRatio: aspectRatio!, child: imageWidget);
    }
    return imageWidget;
  }

  Widget _buildPlayButton(BuildContext context) {
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    if (transferState != VTransferState.completed)
      return const SizedBox.shrink();
    return Positioned.fill(
      child: Center(
        child: GestureDetector(
          onTap: isSelectionMode ? null : () => _handleTap(context),
          child: Container(
            width: BubbleSizes.playButtonSize,
            height: BubbleSizes.playButtonSize,
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(Icons.play_arrow,
                color: Colors.white, size: BubbleSizes.iconXXL),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    final callbacks = context.bubbleCallbacks;
    // If user provided onMediaTap callback, use it instead of internal viewer
    if (callbacks.onMediaTap != null) {
      callbacks.onMediaTap!(VMediaTapData(messageId: messageId));
      return;
    }
    // Open internal video player
    VMediaViewerRoute.openVideo(
      context: context,
      data: VMediaViewerData(
        messageId: messageId,
        file: videoFile,
        isVideo: true,
        caption: caption,
        senderName: senderName,
        time: time,
      ),
      callbacks: callbacks,
    );
  }

  Widget _buildTransferOverlay(BuildContext context) {
    final callbacks = context.bubbleCallbacks;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    return VTransferOverlay(
      state: transferState,
      progress: progress,
      onCancel: isSelectionMode
          ? null
          : () => callbacks.onMediaTransferAction?.call(
                messageId,
                VMediaTransferAction.cancel,
              ),
      onRetry: isSelectionMode
          ? null
          : () => callbacks.onMediaTransferAction?.call(
                messageId,
                VMediaTransferAction.retry,
              ),
      onDownload: isSelectionMode
          ? null
          : () => callbacks.onMediaTransferAction?.call(
                messageId,
                VMediaTransferAction.download,
              ),
    );
  }

  Widget _buildDurationBadge(BuildContext context) {
    final fileSize = videoFile.fileSize;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BubbleRadius.tiny,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.videocam,
              color: Colors.white, size: BubbleSizes.iconSmall),
          BubbleSpacing.gapS,
          Text(
            formatDuration(duration),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          if (fileSize > 0) ...[
            const Text(
              ' • ',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              formatFileSize(fileSize),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOverlayInfo(BuildContext context) {
    final theme = context.bubbleTheme;
    return VMediaOverlayInfo(
      time: time,
      status: isMeSender ? status : null,
      caption: caption,
      isMeSender: isMeSender,
      maxCaptionLines: 2,
      readIconColor: theme.readIconColor,
    );
  }
}
