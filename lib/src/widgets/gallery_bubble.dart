import 'package:flutter/material.dart';
import '../core/enums.dart';
import '../core/models.dart';
import '../core/modern_message_models.dart';
import '../utils/shimmer_helper.dart';
import '../utils/platform_image_builder.dart';
import '../viewers/media_viewer_route.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';
import 'shared/media_error_placeholder.dart';
import 'shared/shimmer_loading.dart';

/// Gallery message bubble with multiple images
///
/// Layout configurations:
/// - 1 image: Full width
/// - 2 images: Side-by-side
/// - 3 images: 1 on top + 2 on bottom
/// - 4+ images: 2x2 grid with +N overlay on last cell
///
/// Features:
/// - Smooth fade-in animation for all images
/// - Shimmer loading placeholders
/// - Memory-optimized gallery rendering
/// - Intelligent grid layout
///
/// Each image uses VGalleryItemData with its own messageId and metadata.
class VGalleryBubble extends BaseBubble {
  /// List of gallery items - each with unique messageId and metadata
  final List<VGalleryItemData> items;

  /// Optional shared-album metadata, quality, and collaboration state.
  final VMediaCollectionData? collection;
  @override
  String get messageType => 'gallery';
  const VGalleryBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.items,
    this.collection,
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
    final config = context.bubbleConfig;
    final maxWidth =
        MediaQuery.sizeOf(context).width * config.sizing.maxWidthFraction;
    final header = buildBubbleHeader(context);
    final hasHeader = header != null;
    final galleryContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (collection != null) _buildCollectionHeader(context),
        _buildGalleryGrid(context, maxWidth),
        if (_hasAnyCaption) _buildCaptions(context),
      ],
    );
    // Only clip when not inside bubble wrapper
    final mediaContent = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: hasHeader
          ? galleryContent
          : ClipRRect(
              borderRadius: BorderRadius.circular(config.media.cornerRadius),
              child: galleryContent,
            ),
    );
    if (!hasHeader) return mediaContent;
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: effectiveShowTail(context),
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

  bool get _hasAnyCaption =>
      items.any((item) => item.caption != null && item.caption!.isNotEmpty);

  Widget _buildGalleryGrid(BuildContext context, double maxWidth) {
    final config = context.bubbleConfig;
    final spacing = config.media.gallerySpacing;
    if (items.isEmpty) return const SizedBox.shrink();
    if (items.length == 1) {
      return _buildImage(context, items[0], 0, maxWidth, 200);
    }
    if (items.length == 2) {
      return Row(
        children: [
          Expanded(child: _buildImage(context, items[0], 0, null, 150)),
          SizedBox(width: spacing),
          Expanded(child: _buildImage(context, items[1], 1, null, 150)),
        ],
      );
    }
    if (items.length == 3) {
      return Column(
        children: [
          _buildImage(context, items[0], 0, maxWidth, 150),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(child: _buildImage(context, items[1], 1, null, 100)),
              SizedBox(width: spacing),
              Expanded(child: _buildImage(context, items[2], 2, null, 100)),
            ],
          ),
        ],
      );
    }
    final totalItemCount = collection?.totalItemCount ?? items.length;
    final showMore = totalItemCount > 4;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildImage(context, items[0], 0, null, 120)),
            SizedBox(width: spacing),
            Expanded(child: _buildImage(context, items[1], 1, null, 120)),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            Expanded(child: _buildImage(context, items[2], 2, null, 120)),
            SizedBox(width: spacing),
            Expanded(
              child: Stack(
                children: [
                  _buildImage(context, items[3], 3, null, 120),
                  if (showMore)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: context.bubbleScope.isSelectionMode
                            ? null
                            : () => _onItemTap(context, items[3], 3),
                        child: Container(
                          color: Colors.black45,
                          child: Center(
                            child: Text(
                              '+${totalItemCount - 4}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCollectionHeader(BuildContext context) {
    final theme = context.bubbleTheme;
    final callbacks = context.bubbleCallbacks;
    final textColor = selectTextColor(theme);
    final secondaryColor = selectSecondaryTextColor(theme);
    final data = collection!;
    final qualityLabel = switch (data.quality) {
      VMediaQuality.standard => null,
      VMediaQuality.highDefinition => 'HD',
      VMediaQuality.original => 'Original',
    };
    return Container(
      key: ValueKey('v-media-collection-${data.collectionId}'),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: selectBubbleColor(theme),
      child: Row(
        children: [
          Icon(Icons.photo_library_outlined, color: textColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title ?? 'Shared album',
                  style: theme.messageTextStyle.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${data.totalItemCount} items'
                  '${data.contributors.isEmpty ? '' : ' · ${data.contributors.length} contributors'}',
                  style: theme.timeTextStyle.copyWith(color: secondaryColor),
                ),
              ],
            ),
          ),
          if (qualityLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                qualityLabel,
                style: theme.timeTextStyle.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (data.canAddItems && callbacks.onMediaCollectionAdd != null)
            IconButton(
              key: ValueKey('v-media-collection-add-${data.collectionId}'),
              tooltip: 'Add media',
              onPressed: () =>
                  callbacks.onMediaCollectionAdd!(messageId, data.collectionId),
              icon: Icon(Icons.add_photo_alternate_outlined, color: textColor),
            ),
        ],
      ),
    );
  }

  void _onItemTap(BuildContext context, VGalleryItemData item, int index) {
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    if (isSelectionMode) return;
    final callbacks = context.bubbleCallbacks;
    // If user provided onMediaTap callback, use it instead of internal viewer
    if (callbacks.onMediaTap != null) {
      callbacks.onMediaTap!(
        VMediaTapData(messageId: messageId, index: index, galleryItem: item),
      );
      return;
    }
    // Open internal gallery viewer
    VMediaViewerRoute.openGallery(
      context: context,
      data: VMediaViewerData(
        messageId: messageId,
        file: item.file,
        caption: item.caption,
        senderName: senderName,
        time: item.time,
        index: index,
        items: items,
      ),
      callbacks: callbacks,
    );
  }

  Widget _buildImage(
    BuildContext context,
    VGalleryItemData item,
    int index,
    double? width,
    double height,
  ) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final shimmerColors = VShimmerHelper.getShimmerColors(theme, isMeSender);
    return GestureDetector(
      onTap: isSelectionMode ? null : () => _onItemTap(context, item, index),
      child: Hero(
        tag: 'media_${messageId}_$index',
        child: SizedBox(
          width: width,
          height: height,
          child: VPlatformImageBuilder.build(
            item.file,
            fit: BoxFit.cover,
            config: VImageRenderConfig.gallery,
            cacheNetworkImages: config.media.cacheNetworkImages,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return VShimmerLoading.gallery(
                width: width,
                height: height,
                baseColor: shimmerColors.base,
                highlightColor: shimmerColors.highlight,
              );
            },
            errorBuilder: (context, error, stack) =>
                const VMediaErrorPlaceholder.gallery(),
          ),
        ),
      ),
    );
  }

  Widget _buildCaptions(BuildContext context) {
    final theme = context.bubbleTheme;
    final textColor = selectTextColor(theme);
    final bubbleColor = selectBubbleColor(theme);
    final captions = items
        .where((item) => item.caption != null && item.caption!.isNotEmpty)
        .toList();
    if (captions.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: bubbleColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...captions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item.caption!,
                style: theme.captionTextStyle.copyWith(color: textColor),
              ),
            ),
          ),
          Align(alignment: Alignment.centerRight, child: buildMeta(context)),
        ],
      ),
    );
  }
}
