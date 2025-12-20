import 'dart:io';

import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

/// Configuration for optimized image rendering
class VImageRenderConfig {
  /// Target width for memory caching (reduces memory usage)
  final int? cacheWidth;

  /// Target height for memory caching (reduces memory usage)
  final int? cacheHeight;

  /// Filter quality for image rendering
  final FilterQuality filterQuality;

  /// Whether to use gapless playback (prevents flickering on source change)
  final bool gaplessPlayback;

  /// Duration for fade-in animation
  final Duration fadeInDuration;

  /// Curve for fade-in animation
  final Curve fadeInCurve;

  const VImageRenderConfig({
    this.cacheWidth,
    this.cacheHeight,
    this.filterQuality = FilterQuality.medium,
    this.gaplessPlayback = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeInCurve = Curves.easeOut,
  });

  /// Default configuration for thumbnails (smaller, faster loading)
  static const thumbnail = VImageRenderConfig(
    cacheWidth: 200,
    filterQuality: FilterQuality.low,
    fadeInDuration: Duration(milliseconds: 200),
  );

  /// Default configuration for full images (higher quality)
  static const fullImage = VImageRenderConfig(
    filterQuality: FilterQuality.medium,
    fadeInDuration: Duration(milliseconds: 300),
  );

  /// Default configuration for gallery items (balanced)
  static const gallery = VImageRenderConfig(
    cacheWidth: 300,
    filterQuality: FilterQuality.medium,
    fadeInDuration: Duration(milliseconds: 250),
  );
}

/// Builds optimized Image widgets from VPlatformFile supporting all source types:
/// - Network URLs
/// - Local file paths
/// - Asset paths
/// - Byte arrays
///
/// Features:
/// - Smooth fade-in animation
/// - Memory-optimized caching
/// - Gapless playback (no flickering)
/// - Configurable filter quality
///
/// Usage:
/// ```dart
/// VPlatformImageBuilder.build(
///   platformFile,
///   fit: BoxFit.cover,
///   config: VImageRenderConfig.fullImage,
///   errorBuilder: (context, error, stack) => ErrorPlaceholder(),
/// )
/// ```
class VPlatformImageBuilder {
  const VPlatformImageBuilder._();

  /// Builds an optimized Image widget from VPlatformFile
  static Widget build(
    VPlatformFile platformFile, {
    BoxFit fit = BoxFit.cover,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder,
    double? width,
    double? height,
    VImageRenderConfig config = const VImageRenderConfig(),
  }) {
    // Frame builder for fade-in animation
    Widget frameBuilder(
      BuildContext context,
      Widget child,
      int? frame,
      bool wasSynchronouslyLoaded,
    ) {
      if (wasSynchronouslyLoaded) return child;
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: config.fadeInDuration,
        curve: config.fadeInCurve,
        child: child,
      );
    }

    if (platformFile.isFromAssets) {
      return Image.asset(
        platformFile.assetsPath!,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: config.cacheWidth,
        cacheHeight: config.cacheHeight,
        filterQuality: config.filterQuality,
        gaplessPlayback: config.gaplessPlayback,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
      );
    }
    if (platformFile.isFromBytes) {
      return Image.memory(
        platformFile.uint8List,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: config.cacheWidth,
        cacheHeight: config.cacheHeight,
        filterQuality: config.filterQuality,
        gaplessPlayback: config.gaplessPlayback,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
      );
    }
    if (platformFile.isFromUrl) {
      return Image.network(
        platformFile.networkUrl!,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: config.cacheWidth,
        cacheHeight: config.cacheHeight,
        filterQuality: config.filterQuality,
        gaplessPlayback: config.gaplessPlayback,
        frameBuilder: frameBuilder,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
      );
    }

    if (platformFile.isFromPath) {
      return Image.file(
        File(platformFile.fileLocalPath!),
        fit: fit,
        width: width,
        height: height,
        cacheWidth: config.cacheWidth,
        cacheHeight: config.cacheHeight,
        filterQuality: config.filterQuality,
        gaplessPlayback: config.gaplessPlayback,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
      );
    }

    // Fallback: return error widget if no valid source
    if (errorBuilder != null) {
      return Builder(
        builder: (context) => errorBuilder(context, 'Unknown source', null),
      );
    }
    return const _DefaultErrorPlaceholder();
  }
}

/// Default error placeholder when no custom error builder provided
class _DefaultErrorPlaceholder extends StatelessWidget {
  const _DefaultErrorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}
