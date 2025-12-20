import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/callbacks.dart';
import '../core/models.dart';
import '../utils/platform_image_builder.dart';
import 'shared/double_tap_zoom.dart';
import 'shared/swipe_to_dismiss.dart';
import 'shared/viewer_app_bar.dart';
import 'shared/viewer_overlay.dart';

/// Gallery viewer with PageView for swiping between images
class VGalleryViewerPage extends StatefulWidget {
  final VMediaViewerData data;
  final VBubbleCallbacks? callbacks;
  const VGalleryViewerPage({
    super.key,
    required this.data,
    this.callbacks,
  });
  @override
  State<VGalleryViewerPage> createState() => _GalleryViewerPageState();
}

class _GalleryViewerPageState extends State<VGalleryViewerPage> {
  late PageController _pageController;
  late int _currentIndex;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.data.index ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (items.isEmpty) return;
    if (_currentIndex > 0) {
      _pageController.animateToPage(
        _currentIndex - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (items.isEmpty) return;
    if (_currentIndex < items.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _goToPrevious();
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _goToNext();
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  List<VGalleryItemData> get items => widget.data.items ?? [];
  VGalleryItemData? get currentItem {
    if (items.isEmpty || _currentIndex < 0 || _currentIndex >= items.length) {
      return null;
    }
    return items[_currentIndex];
  }

  void _onPageChanged(int index) {
    if (index >= 0 && index < items.length) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      // Fallback to single image viewer
      return _buildSingleImageViewer(context);
    }
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: VSwipeToDismiss(
            onDismiss: () => Navigator.of(context).pop(),
            child: VViewerOverlay(
              overlay: _buildOverlay(context),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Hero(
                    tag: 'media_${widget.data.messageId}_$index',
                    child: Center(
                      child: VDoubleTapZoomViewer(
                        child: _buildImage(item),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingleImageViewer(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: VSwipeToDismiss(
            onDismiss: () => Navigator.of(context).pop(),
            child: VViewerOverlay(
              overlay: _buildSingleOverlay(context),
              child: Hero(
                tag:
                    'media_${widget.data.messageId}${widget.data.index != null ? '_${widget.data.index}' : ''}',
                child: Center(
                  child: VDoubleTapZoomViewer(
                    child: VPlatformImageBuilder.build(
                      widget.data.file,
                      fit: BoxFit.contain,
                      config: VImageRenderConfig.fullImage,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final item = currentItem;
    if (item == null) return const SizedBox.shrink();
    return Column(
      children: [
        VViewerAppBar(
          title: '${_currentIndex + 1} of ${items.length}',
          subtitle: widget.data.senderName != null
              ? '${widget.data.senderName} \u2022 ${item.time}'
              : item.time,
          onClose: () => Navigator.of(context).pop(),
          onDownload: widget.callbacks?.onDownload != null
              ? () => widget.callbacks!.onDownload!(item.messageId)
              : null,
          onShare: widget.callbacks?.onShare != null
              ? () => widget.callbacks!.onShare!(item.messageId)
              : null,
        ),
        const Spacer(),
        if (item.caption != null) _buildCaption(context, item.caption!),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildSingleOverlay(BuildContext context) {
    return Column(
      children: [
        VViewerAppBar(
          title: widget.data.senderName,
          subtitle: widget.data.time,
          onClose: () => Navigator.of(context).pop(),
          onDownload: widget.callbacks?.onDownload != null
              ? () => widget.callbacks!.onDownload!(widget.data.messageId)
              : null,
          onShare: widget.callbacks?.onShare != null
              ? () => widget.callbacks!.onShare!(widget.data.messageId)
              : null,
        ),
        const Spacer(),
        if (widget.data.caption != null)
          _buildCaption(context, widget.data.caption!),
      ],
    );
  }

  Widget _buildCaption(BuildContext context, String caption) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        caption,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPageIndicator() {
    if (items.length <= 1) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom + 16,
        top: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(items.length, (index) {
          final isActive = index == _currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 8 : 6,
            height: isActive ? 8 : 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildImage(VGalleryItemData item) {
    return VPlatformImageBuilder.build(
      item.file,
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
