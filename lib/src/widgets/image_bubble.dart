import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import '../core/enums.dart';
import '../core/models.dart';
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

/// Image message bubble with optional caption
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
/// - Transfer progress overlay
class VImageBubble extends BaseBubble {
  /// Platform file containing the image source
  final VPlatformFile imageFile;
  @override
  String get messageType => 'image';

  /// Optional caption text
  final String? caption;

  /// Image aspect ratio (width/height)
  final double? aspectRatio;

  /// Upload/download progress (0.0 - 1.0)
  final double? progress;

  /// Transfer state
  final VTransferState transferState;

  /// Whether image is blurred (NSFW/spoiler)
  final bool isBlurred;

  const VImageBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.imageFile,
    this.caption,
    this.aspectRatio,
    this.progress,
    this.transferState = VTransferState.completed,
    this.isBlurred = false,
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
      maxHeight: config.media.imageMaxHeight,
      onTap: () => _handleTap(context),
      fillBubble: hasHeader, // Fill edge-to-edge when inside bubble wrapper
      child: Stack(
        children: [
          _buildImage(context),
          if (isBlurred) _buildBlurOverlay(context),
          if (transferState != VTransferState.completed)
            _buildTransferOverlay(context),
          _buildOverlayInfo(context),
        ],
      ),
    );
    if (!hasHeader) return mediaContent;
    final showTail = !isSameSender;
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: showTail,
      padding: EdgeInsets.zero,
      clipContent: true, // Clip content to bubble shape
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(8), child: header),
          mediaContent,
        ],
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
    // Open internal viewer
    VMediaViewerRoute.openImage(
      context: context,
      data: VMediaViewerData(
        messageId: messageId,
        file: imageFile,
        caption: caption,
        senderName: senderName,
        time: time,
      ),
      callbacks: callbacks,
    );
  }

  Widget _buildImage(BuildContext context) {
    final theme = context.bubbleTheme;
    final shimmerColors = VShimmerHelper.getShimmerColors(theme, isMeSender);
    final imageWidget = VPlatformImageBuilder.build(
      imageFile,
      fit: BoxFit.cover,
      config: VImageRenderConfig.fullImage,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        final progressValue = loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null;
        return Stack(
          children: [
            VShimmerLoading.image(
              height: 200,
              baseColor: shimmerColors.base,
              highlightColor: shimmerColors.highlight,
            ),
            if (progressValue != null)
              Positioned.fill(
                child: Center(
                  child: _buildProgressRing(progressValue, theme.progressColor),
                ),
              ),
          ],
        );
      },
      errorBuilder: (context, error, stack) => _buildErrorPlaceholder(context),
    );
    if (aspectRatio != null) {
      return AspectRatio(aspectRatio: aspectRatio!, child: imageWidget);
    }
    return imageWidget;
  }

  Widget _buildProgressRing(double progress, Color color) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 3,
        color: color,
        backgroundColor: color.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context) {
    final theme = context.bubbleTheme;
    final backgroundColor = isMeSender
        ? theme.outgoingBubbleColor.withValues(alpha: 0.5)
        : theme.incomingBubbleColor.withValues(alpha: 0.5);
    return VMediaErrorPlaceholder.image(
      height: 150,
      backgroundColor: backgroundColor,
    );
  }

  Widget _buildBlurOverlay(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility_off, color: Colors.white, size: 32),
              SizedBox(height: 8),
              Text(
                'Tap to reveal',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
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
