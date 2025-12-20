import 'package:flutter/material.dart';

import '../../core/config.dart';
import '../../widgets/bubble_scope.dart';

/// App bar for media viewer with close, share, and download buttons
class VViewerAppBar extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback onClose;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final bool showDownload;
  final bool showShare;
  const VViewerAppBar({
    super.key,
    this.title,
    this.subtitle,
    required this.onClose,
    this.onDownload,
    this.onShare,
    this.showDownload = true,
    this.showShare = true,
  });
  @override
  Widget build(BuildContext context) {
    final scope = VBubbleScopeData.maybeOf(context);
    final translations =
        scope?.config.translations ?? const VTranslationConfig();
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 8,
        left: 4,
        right: 4,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.6),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // Close button
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            tooltip: translations.viewerClose,
          ),
          // Title and subtitle
          if (title != null || subtitle != null)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            )
          else
            const Spacer(),
          // Action buttons
          if (showDownload && onDownload != null)
            IconButton(
              onPressed: onDownload,
              icon: const Icon(Icons.download, color: Colors.white),
              tooltip: translations.viewerDownload,
            ),
          if (showShare && onShare != null)
            IconButton(
              onPressed: onShare,
              icon: const Icon(Icons.share, color: Colors.white),
              tooltip: translations.viewerShare,
            ),
        ],
      ),
    );
  }
}
