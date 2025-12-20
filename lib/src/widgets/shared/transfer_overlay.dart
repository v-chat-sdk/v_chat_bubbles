import 'package:flutter/material.dart';
import '../../core/enums.dart';

/// Shared transfer overlay widget for media bubbles
///
/// Displays overlay UI for download/upload states:
/// - Progress indicator during download/upload
/// - Cancel button during transfer
/// - Retry button on error
/// - Download button when idle
class VTransferOverlay extends StatelessWidget {
  /// Current transfer state
  final VTransferState state;

  /// Transfer progress (0.0 - 1.0), null if indeterminate
  final double? progress;

  /// Callback when cancel button is tapped
  final VoidCallback? onCancel;

  /// Callback when retry button is tapped
  final VoidCallback? onRetry;

  /// Callback when download button is tapped
  final VoidCallback? onDownload;

  /// Color for progress indicator
  final Color? progressColor;

  /// Background overlay color
  final Color? backgroundColor;

  /// Size of the transfer button
  final double buttonSize;

  /// Stroke width for progress indicator
  final double strokeWidth;

  const VTransferOverlay({
    super.key,
    required this.state,
    this.progress,
    this.onCancel,
    this.onRetry,
    this.onDownload,
    this.progressColor,
    this.backgroundColor,
    this.buttonSize = 56,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (state == VTransferState.completed) {
      return const SizedBox.shrink();
    }
    IconData icon;
    VoidCallback? onTap;
    switch (state) {
      case VTransferState.downloading:
      case VTransferState.uploading:
        icon = Icons.close;
        onTap = onCancel;
      case VTransferState.error:
        icon = Icons.refresh;
        onTap = onRetry;
      case VTransferState.idle:
        icon = Icons.download;
        onTap = onDownload;
      default:
        return const SizedBox.shrink();
    }
    return Positioned.fill(
      child: Container(
        color: backgroundColor ?? Colors.black45,
        child: Center(
          child: _buildTransferButton(icon, onTap),
        ),
      ),
    );
  }

  Widget _buildTransferButton(IconData icon, VoidCallback? onTap) {
    final hasProgress = (state == VTransferState.downloading ||
            state == VTransferState.uploading) &&
        progress != null;
    if (hasProgress) {
      return SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              color: progressColor ?? Colors.white,
              backgroundColor:
                  (progressColor ?? Colors.white).withValues(alpha: 0.24),
            ),
            GestureDetector(
              onTap: onTap,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
