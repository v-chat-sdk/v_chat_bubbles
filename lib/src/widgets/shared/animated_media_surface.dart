import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import '../../utils/platform_image_builder.dart';
import '../bubble_scope.dart';

/// Playback surface shared by GIF messages and animated stickers.
///
/// Supply [previewFile] to guarantee a static frame while paused. Without a
/// preview, the animated source remains visible behind the pause affordance.
class VAnimatedMediaSurface extends StatefulWidget {
  final String messageId;
  final VPlatformFile animatedFile;
  final VPlatformFile? previewFile;
  final double width;
  final double height;
  final BoxFit fit;
  final bool autoplay;
  final bool showPlaybackControl;
  final ValueChanged<bool>? onPlaybackChanged;

  const VAnimatedMediaSurface({
    super.key,
    required this.messageId,
    required this.animatedFile,
    required this.width,
    required this.height,
    this.previewFile,
    this.fit = BoxFit.contain,
    this.autoplay = true,
    this.showPlaybackControl = true,
    this.onPlaybackChanged,
  });

  @override
  State<VAnimatedMediaSurface> createState() => _VAnimatedMediaSurfaceState();
}

class _VAnimatedMediaSurfaceState extends State<VAnimatedMediaSurface> {
  late bool _isPlaying;
  bool _userOverrodeReducedMotion = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.autoplay;
  }

  @override
  void didUpdateWidget(covariant VAnimatedMediaSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoplay != widget.autoplay) {
      _isPlaying = widget.autoplay;
      _userOverrodeReducedMotion = false;
    }
  }

  void _togglePlayback() {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    setState(() {
      if (_isPlaying && reduceMotion && !_userOverrodeReducedMotion) {
        _userOverrodeReducedMotion = true;
      } else {
        _isPlaying = !_isPlaying;
        _userOverrodeReducedMotion = _isPlaying;
      }
    });
    widget.onPlaybackChanged?.call(
      _isPlaying && (!reduceMotion || _userOverrodeReducedMotion),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final effectivePlaying =
        _isPlaying && (!reduceMotion || _userOverrodeReducedMotion);
    final source = effectivePlaying
        ? widget.animatedFile
        : widget.previewFile ?? widget.animatedFile;
    final config = context.bubbleConfig;

    return Semantics(
      button: widget.showPlaybackControl,
      label: effectivePlaying ? 'Pause animation' : 'Play animation',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.showPlaybackControl ? _togglePlayback : null,
        child: SizedBox(
          key: ValueKey('v-animated-media-${widget.messageId}'),
          width: widget.width,
          height: widget.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              VPlatformImageBuilder.build(
                source,
                fit: widget.fit,
                config: VImageRenderConfig(
                  cacheWidth:
                      (widget.width * MediaQuery.devicePixelRatioOf(context))
                          .round(),
                  filterQuality: FilterQuality.medium,
                  fadeInDuration: config.animation.fadeIn,
                ),
                cacheNetworkImages: config.media.cacheNetworkImages,
              ),
              if (!effectivePlaying && widget.showPlaybackControl)
                ColoredBox(
                  color: Colors.black.withValues(alpha: 0.22),
                  child: const Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
