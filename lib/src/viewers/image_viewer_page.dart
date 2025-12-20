import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/callbacks.dart';
import '../core/models.dart';
import '../utils/platform_image_builder.dart';
import 'shared/double_tap_zoom.dart';
import 'shared/swipe_to_dismiss.dart';
import 'shared/viewer_app_bar.dart';
import 'shared/viewer_overlay.dart';

/// Full-screen image viewer with pinch-to-zoom, pan, and swipe-to-dismiss
class VImageViewerPage extends StatelessWidget {
  final VMediaViewerData data;
  final VBubbleCallbacks? callbacks;
  const VImageViewerPage({
    super.key,
    required this.data,
    this.callbacks,
  });
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: VSwipeToDismiss(
          onDismiss: () => Navigator.of(context).pop(),
          child: VViewerOverlay(
            overlay: _buildOverlay(context),
            child: Hero(
              tag:
                  'media_${data.messageId}${data.index != null ? '_${data.index}' : ''}',
              child: Center(
                child: VDoubleTapZoomViewer(
                  child: _buildImage(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Column(
      children: [
        VViewerAppBar(
          title: data.senderName,
          subtitle: data.time,
          onClose: () => Navigator.of(context).pop(),
          onDownload: callbacks?.onDownload != null
              ? () => callbacks!.onDownload!(data.messageId)
              : null,
          onShare: callbacks?.onShare != null
              ? () => callbacks!.onShare!(data.messageId)
              : null,
        ),
        const Spacer(),
        if (data.caption != null) _buildCaption(context),
      ],
    );
  }

  Widget _buildCaption(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.paddingOf(context).bottom + 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.6),
            Colors.transparent,
          ],
        ),
      ),
      child: Text(
        data.caption!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return VPlatformImageBuilder.build(
      data.file,
      fit: BoxFit.contain,
      config: VImageRenderConfig.fullImage,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
            color: Colors.white,
          ),
        );
      },
      errorBuilder: (context, error, stack) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image, color: Colors.white54, size: 64),
            SizedBox(height: 16),
            Text(
              'Failed to load image',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
