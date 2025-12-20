import 'dart:io';

import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import 'media_error_placeholder.dart';
import 'shimmer_loading.dart';

/// Unified image widget that handles all VPlatformFile source types:
/// - Network URLs (with shimmer loading)
/// - Local file paths
/// - Asset paths
/// - Byte arrays (memory)
///
/// Features:
/// - Automatic source type detection from VPlatformFile
/// - Shimmer loading animation for network images
/// - Smooth fade-in animation
/// - Error handling with icon placeholder
/// - Circular and border radius support
/// - Memory-optimized caching
class VUnifiedImage extends StatelessWidget {
  const VUnifiedImage({
    super.key,
    required this.imageSource,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isCircular = false,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 200),
    this.filterQuality = FilterQuality.medium,
  });

  /// The image source supporting network, file, asset, or memory
  final VPlatformFile imageSource;

  /// Width constraint for the image
  final double? width;

  /// Height constraint for the image
  final double? height;

  /// How the image should fit within its bounds
  final BoxFit fit;

  /// Border radius for rounded corners (ignored if isCircular is true)
  final BorderRadius? borderRadius;

  /// Whether to clip the image as a circle
  final bool isCircular;

  /// Base color for shimmer loading effect (network images only)
  final Color? shimmerBaseColor;

  /// Highlight color for shimmer loading sweep (network images only)
  final Color? shimmerHighlightColor;

  /// Custom error widget (defaults to VMediaErrorPlaceholder)
  final Widget? errorWidget;

  /// Duration of the fade-in animation
  final Duration fadeInDuration;

  /// Filter quality for image rendering
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final cacheWidth =
        width != null ? (width! * devicePixelRatio).toInt() : null;
    final cacheHeight =
        height != null ? (height! * devicePixelRatio).toInt() : null;

    Widget image = _buildImage(context, cacheWidth, cacheHeight);

    if (isCircular) {
      return ClipOval(child: image);
    }
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _buildImage(BuildContext context, int? cacheWidth, int? cacheHeight) {
    // Network URL - with shimmer loading
    if (imageSource.isFromUrl && imageSource.networkUrl != null) {
      return _buildNetworkImage(cacheWidth, cacheHeight);
    }

    // Local file path
    if (imageSource.isFromPath && imageSource.fileLocalPath != null) {
      return _buildFileImage(cacheWidth, cacheHeight);
    }

    // Asset path
    if (imageSource.isFromAssets && imageSource.assetsPath != null) {
      return _buildAssetImage(cacheWidth, cacheHeight);
    }

    // Memory bytes
    if (imageSource.isFromBytes) {
      return _buildMemoryImage(cacheWidth, cacheHeight);
    }

    // Fallback - no valid source
    return _buildErrorWidget();
  }

  Widget _buildNetworkImage(int? cacheWidth, int? cacheHeight) {
    return Image.network(
      imageSource.networkUrl!,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      filterQuality: filterQuality,
      gaplessPlayback: true,
      frameBuilder: _frameBuilder,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return VShimmerLoading(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
        );
      },
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildFileImage(int? cacheWidth, int? cacheHeight) {
    return Image.file(
      File(imageSource.fileLocalPath!),
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      filterQuality: filterQuality,
      gaplessPlayback: true,
      frameBuilder: _frameBuilder,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildAssetImage(int? cacheWidth, int? cacheHeight) {
    return Image.asset(
      imageSource.assetsPath!,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      filterQuality: filterQuality,
      gaplessPlayback: true,
      frameBuilder: _frameBuilder,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildMemoryImage(int? cacheWidth, int? cacheHeight) {
    return Image.memory(
      imageSource.uint8List,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      filterQuality: filterQuality,
      gaplessPlayback: true,
      frameBuilder: _frameBuilder,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _frameBuilder(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (wasSynchronouslyLoaded || frame != null) {
      return AnimatedOpacity(
        opacity: frame != null ? 1.0 : 0.0,
        duration: fadeInDuration,
        child: child,
      );
    }
    return child;
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        VMediaErrorPlaceholder(
          width: width,
          height: height,
        );
  }
}
