import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import '../core/constants.dart';
import '../core/models.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';
import 'shared/unified_image.dart';

/// Location message bubble with static map
class VLocationBubble extends BaseBubble {
  /// Location data (lat, lng, address, static map URL)
  final VLocationData locationData;

  @override
  String get messageType => 'location';

  const VLocationBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.locationData,
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
    final callbacks = context.bubbleCallbacks;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final maxWidth =
        MediaQuery.sizeOf(context).width * config.sizing.maxWidthFraction;
    final header = buildBubbleHeader(context);
    final mediaContent = GestureDetector(
      onTap: isSelectionMode ? null : () => callbacks.onTap?.call(messageId),
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(config.media.cornerRadius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMap(context),
              if (locationData.address != null) _buildAddress(context),
            ],
          ),
        ),
      ),
    );
    if (header == null) return mediaContent;
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: !isSameSender,
      padding: EdgeInsets.zero,
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

  Widget _buildMap(BuildContext context) {
    final config = context.bubbleConfig;
    // Show placeholder if no staticMapUrl provided
    // Google Maps Static API requires an API key, so fallback URL won't work
    if (locationData.staticMapUrl == null) {
      return Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on,
                size: BubbleSizes.iconHuge, color: Colors.red),
            BubbleSpacing.vGapL,
            Text(
              '${locationData.latitude.toStringAsFixed(4)}, ${locationData.longitude.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            BubbleSpacing.vGapS,
            Text(
              config.translations.locationTapToOpen,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }
    return Stack(
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: VUnifiedImage(
            imageSource:
                VPlatformFile.fromUrl(networkUrl: locationData.staticMapUrl!),
            height: 150,
            fit: BoxFit.cover,
            shimmerBaseColor: Colors.grey[300],
            shimmerHighlightColor: Colors.grey[100],
            fadeInDuration: config.animation.fadeIn,
            errorWidget: Container(
              height: 150,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on,
                      size: BubbleSizes.iconHuge, color: Colors.red),
                  BubbleSpacing.vGapL,
                  Text(
                    '${locationData.latitude.toStringAsFixed(4)}, ${locationData.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Icon(Icons.location_on,
              color: Colors.red, size: BubbleSizes.iconXL),
        ),
      ],
    );
  }

  Widget _buildAddress(BuildContext context) {
    final theme = context.bubbleTheme;
    final textColor = selectTextColor(theme);
    final bubbleColor = selectBubbleColor(theme);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: bubbleColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              locationData.address!,
              style: theme.messageTextStyle.copyWith(color: textColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          BubbleSpacing.gapM,
          buildMeta(context),
        ],
      ),
    );
  }
}
